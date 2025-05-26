print('[GarbageJob] server.lua geladen')

ESX = exports['es_extended']:getSharedObject()

-- Sicherstellen, dass Config verfügbar ist
Config = Config or {}
if not Config.PaymentAmount then Config.PaymentAmount = 200 end
if not Config.PaymentType then Config.PaymentType = 'bank' end

RegisterServerEvent('garbagejob:payPlayer')
AddEventHandler('garbagejob:payPlayer', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local reward = Config.PaymentAmount
    local account = Config.PaymentType == 'cash' and 'money' or 'bank'

    xPlayer.addAccountMoney(account, reward)
    TriggerClientEvent('esx:showNotification', source, 'Du hast ~g~$' .. reward .. '~s~ für die Müllentsorgung erhalten.')
end)
