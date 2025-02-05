fx_version 'cerulean'
game 'gta5'

author 'AgateCobra'
description 'FiveM Standalone Anti-Cheat med oxmysql, screenshot-basic, Lua executor scanning og Discord logs'
version '1.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'oxmysql',
    'screenshot-basic'
}
