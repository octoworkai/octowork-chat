'use strict';
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const jscPath = path.join(__dirname, 'server.jsc');
const hash = crypto.createHash('sha256').update(fs.readFileSync(jscPath)).digest('hex');
if (hash !== '9e082c7179ea678b6a14814edcf91c10fa39c4ef7de92ae5304329a2e8304611') {
  console.error('程序文件损坏或被篡改，拒绝启动');
  process.exit(1);
}
require('bytenode');
require('./server.jsc');
