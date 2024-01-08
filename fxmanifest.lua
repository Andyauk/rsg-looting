fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'RexShack#3041'
description 'rsg-looting'
version '1.0.1'

client_script {
	'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

shared_scripts {
	'config.lua',
}

dependencies {
    'rsg-core',
    'rsg-lawman'
}

lua54 'yes'
