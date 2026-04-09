'use strict';
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const jscPath = path.join(__dirname, 'server.jsc');
const hash = crypto.createHash('sha256').update(fs.readFileSync(jscPath)).digest('hex');
if (hash !== '683d51cd733227cd8a4a6aa73df638b71ef66e722bed67945de15d3a6786d872') {
  console.error('程序文件损坏或被篡改，拒绝启动');
  process.exit(1);
}
require('bytenode');
require('./server.jsc');
