fx_version 'adamant'
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 'AddZodus#6269'
description 'by addzodus'
version '1.0.0'

ui_page 'ui/index.html'

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/server.lua',
  'config.lua'
}

client_scripts {
  'client/client.lua',
  'client/hairs.lua',
  'config.lua'
}

files {
  'ui/*',
  'ui/css/*',
  'ui/img/*',
  'ui/js/*',
}
