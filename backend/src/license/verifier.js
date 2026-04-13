/**
 * License 校验器 — 启动时调用
 * 
 * 校验流程:
 *   1. 检查开发模式环境变量（跳过校验）
 *   2. 检查 license.key 是否存在
 *   3. 解码 Base64 -> JSON
 *   4. 验证 HMAC-SHA256 签名（防伪造）
 *   5. 验证机器指纹（防复制）
 *   6. 验证过期时间
 * 
 * 任何一步失败 -> console.error + process.exit(1)
 */
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const { generateFingerprint, generateLegacyFingerprint, generateUltraStableFingerprint } = require('../utils/fingerprint');
const { LICENSE_SECRET, LICENSE_PATH, SKIP_LICENSE_ENV } = require('./constants');

function verifyLicense() {
  // ========== 0. 开发模式跳过 ==========
  if (process.env[SKIP_LICENSE_ENV] === '1') {
    console.log('⚙️  开发模式 — 跳过 License 校验');
    return { customer: 'Developer', plan: 'dev', expire: 'unlimited' };
  }

  // ========== 1. 检查 license.key 存在 ==========
  if (!fs.existsSync(LICENSE_PATH)) {
    const fingerprint = generateFingerprint();
    console.error('');
    console.error('========================================================');
    console.error('         OctoWork 聊天管理器 — 未激活');
    console.error('========================================================');
    console.error('');
    console.error('  未检测到授权文件 (license.key)');
    console.error('');
    console.error(`  您的机器指纹: ${fingerprint}`);
    console.error('');
    console.error('  请将以上指纹发送给管理员获取授权文件');
    console.error('  授权文件放置路径: ~/octowork-chat/license.key');
    console.error('');
    console.error('========================================================');
    console.error('');
    process.exit(1);
  }

  // ========== 2. 读取 + Base64 解码 ==========
  let payload;
  try {
    const encoded = fs.readFileSync(LICENSE_PATH, 'utf8').trim();
    const decoded = Buffer.from(encoded, 'base64').toString('utf8');
    payload = JSON.parse(decoded);
  } catch (e) {
    console.error('❌ 授权文件格式错误，无法解析');
    console.error('   请确认 license.key 内容完整且未被修改');
    process.exit(1);
  }

  // ========== 3. 验证 HMAC-SHA256 签名 ==========
  const { signature, ...data } = payload;
  if (!signature) {
    console.error('❌ 授权文件缺少签名字段');
    process.exit(1);
  }

  // 签名时 key 排序保证一致性
  const sortedKeys = Object.keys(data).sort();
  const payloadStr = JSON.stringify(data, sortedKeys);
  const expectedSig = crypto
    .createHmac('sha256', LICENSE_SECRET)
    .update(payloadStr)
    .digest('hex');

  if (signature !== expectedSig) {
    console.error('❌ 授权文件签名无效（文件可能被篡改）');
    process.exit(1);
  }

  // ========== 4. 验证机器指纹（支持新旧算法） ==========
  const currentFingerprint = generateFingerprint(); // 新版算法（稳定网络ID）
  const legacyFingerprint = generateLegacyFingerprint(); // 旧版算法（单个MAC地址）
  const ultraStableFingerprint = generateUltraStableFingerprint(); // 超稳定算法（不依赖网络）
  
  if (payload.fingerprint !== currentFingerprint && payload.fingerprint !== legacyFingerprint && payload.fingerprint !== ultraStableFingerprint) {
    console.error('');
    console.error('========================================================');
    console.error('        OctoWork 聊天管理器 — 授权设备不匹配');
    console.error('========================================================');
    console.error('');
    console.error('  此授权仅限原设备使用，不可复制到其他电脑');
    console.error('');
    console.error(`  授权设备指纹: ${payload.fingerprint}`);
    console.error(`  当前设备指纹（新版）: ${currentFingerprint}`);
    console.error(`  当前设备指纹（旧版）: ${legacyFingerprint}`);
    console.error(`  当前设备指纹（超稳定）: ${ultraStableFingerprint}`);
    console.error('');
    console.error('  可能原因：');
    console.error('    1. 更换了网络环境（Wi-Fi/有线切换、更换路由器）');
    console.error('    2. 更换了电脑硬件（CPU、内存、主机名变化）');
    console.error('    3. 授权文件被复制到其他电脑');
    console.error('    4. 电脑重启后主机名或网络配置发生变化');
    console.error('');
    console.error('  建议联系管理员使用超稳定指纹重新生成授权文件');
    console.error('  超稳定指纹对网络环境和重启更宽容');
    console.error('');
    console.error('========================================================');
    console.error('');
    process.exit(1);
  }
  
  // 如果使用旧版指纹匹配，提示升级到新版（更宽松）
  if (payload.fingerprint === legacyFingerprint && payload.fingerprint !== currentFingerprint) {
    console.warn('⚠️  检测到旧版授权（对网络环境变化敏感）');
    console.warn('   建议联系管理员更新为新版授权，避免网络切换导致授权失效');
    console.warn(`   当前网络标识: ${currentFingerprint}`);
  }
  
  // 如果使用超稳定指纹匹配，显示稳定提示
  if (payload.fingerprint === ultraStableFingerprint) {
    console.log('✅ 授权基于超稳定指纹（对重启和网络变化免疫）');
  }

  // ========== 5. 验证过期时间 ==========
  if (payload.expire && payload.expire !== 'unlimited') {
    const expireDate = new Date(payload.expire + 'T23:59:59');
    if (isNaN(expireDate.getTime())) {
      console.error('❌ 授权文件中的过期日期格式错误');
      process.exit(1);
    }
    if (Date.now() > expireDate.getTime()) {
      console.error('');
      console.error(`❌ 授权已过期 (${payload.expire})`);
      console.error('   请联系管理员获取新的授权文件');
      console.error('');
      process.exit(1);
    }

    // 提醒即将过期（30 天内）
    const daysLeft = Math.ceil((expireDate.getTime() - Date.now()) / (1000 * 60 * 60 * 24));
    if (daysLeft <= 30) {
      console.warn(`⚠️  授权将在 ${daysLeft} 天后过期 (${payload.expire})，请提前联系管理员续期`);
    }
  }

  // ========== 6. 校验通过 ==========
  console.log(`🔑 授权校验通过 — ${payload.customer}${payload.company ? ' (' + payload.company + ')' : ''} | ${payload.plan} | 有效期至 ${payload.expire}`);

  return payload;
}

/**
 * 获取当前机器指纹（供 API 调用）
 */
function getMachineFingerprint() {
  return generateFingerprint();
}

module.exports = { verifyLicense, getMachineFingerprint };
