-- FatumDev Mülljob Script für ESX Legacy

fx_version 'cerulean'
game 'gta5'

author 'FatumDev'
description 'ESX Mülljob mit Animationen, Fahrzeug, Depot und Zahlung'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client/main.lua',
    'client/interaction.lua',
    'data/routes.lua'
}

server_script 'server/main.lua'
