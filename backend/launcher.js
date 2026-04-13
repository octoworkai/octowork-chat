'use strict';
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const jscPath = path.join(__dirname, 'server.jsc');
const hash = crypto.createHash('sha256').update(fs.readFileSync(jscPath)).digest('hex');
if (hash !== '743c26b529fdecef049b1fac80ca0a9ff53bb3e0d5ecbb55cc7f150823f8f30b') {
  console.error('程序文件损坏或被篡改，拒绝启动');
  process.exit(1);
}
require('bytenode');
require('./server.jsc');
