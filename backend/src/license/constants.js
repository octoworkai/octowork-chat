/**
 * License 系统常量
 * 
 * LICENSE_SECRET 是签名密钥，仅存在于：
 *   1. 此文件（开发版源码）
 *   2. tools/generate-license.js（开发机工具）
 *   3. server.jsc 字节码（用户版，不可读）
 * 
 * 绝对不能泄露给客户！
 */
const path = require('path');

// 签名密钥（已替换为随机生成的 128 位十六进制）
const LICENSE_SECRET = 'de0e8f808747b8a111124cdc0746e3e7f31daa86a243d4ac0ea68501113ba3fb3d68646b9d690cab7849eded227f159e9c331388383fad4d738755f31bf5ba19';

// License 文件路径:
// 开发环境: __dirname = backend/src/license/ → 上3级到项目根
// 用户版(ncc打包后): __dirname = backend/ → 上1级到 octowork-chat/
// 用两个路径兜底
const LICENSE_PATH_DEV = path.join(__dirname, '../../../license.key');
const LICENSE_PATH_PROD = path.join(__dirname, '../license.key');
const LICENSE_PATH = require('fs').existsSync(LICENSE_PATH_DEV) ? LICENSE_PATH_DEV : LICENSE_PATH_PROD;

// 开发模式标识: 设置此环境变量可跳过 License 校验（仅限开发）
const SKIP_LICENSE_ENV = 'OCTOWORK_DEV_MODE';

module.exports = {
  LICENSE_SECRET,
  LICENSE_PATH,
  SKIP_LICENSE_ENV,
};
