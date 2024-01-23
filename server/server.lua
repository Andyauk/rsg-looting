local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Rexshack-RedM/rsg-looting/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

RegisterNetEvent('rsg-looting:server:lootreward', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local chance = math.random(1,100)
    -- common reward (95% chance)
    if chance <= 95 then -- reward : 1 x common
        local item = Config.CommonItems[math.random(1, #Config.CommonItems)]
        -- add items
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "add")
        Player.Functions.AddMoney('cash', math.random(1,5))
        -- webhook
        TriggerEvent('rsg-log:server:CreateLog', 'loot', 'looted 🌟', 'orange', firstname..' '..lastname..' found '..item..' standard loot!')
    -- rare reward (5% chance)
    elseif chance > 95 then -- reward : 1 x rare
        local item = Config.RareItems[math.random(1, #Config.RareItems)]
        -- add items
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "add")
        Player.Functions.AddMoney('cash', math.random(5,10))
        -- webhook
        TriggerEvent('rsg-log:server:CreateLog', 'loot', 'looted citizen 🌟', 'orange', firstname..' '..lastname..' found '..item..' rare loot!')
    else
        print("something went wrong check for exploit!")
    end
end)

-- Callbacks
RSGCore.Functions.CreateCallback('rsg-looting:server:isPlayerDead', function(_, cb, playerId)
    local Player = RSGCore.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

-- loot cash / bloodmoney from player
RegisterNetEvent('rsg-looting:server:robplayermoney', function(playerId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local SearchedPlayer = RSGCore.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        if Config.TakeCash then
            local takecash = SearchedPlayer.PlayerData.money["cash"]
            Player.Functions.AddMoney("cash", takecash, "cash-robbed")
            SearchedPlayer.Functions.RemoveMoney("cash", takecash, "cash-robbed")
            TriggerClientEvent('ox_lib:notify', SearchedPlayer.PlayerData.source, {title = 'Cash Robbed', description = 'your cash has been robbed', type = 'inform', duration = 7000 })
            TriggerClientEvent('ox_lib:notify', Player.PlayerData.source, {title = 'Cash Robbed', description = 'you robbed the players cash', type = 'inform', duration = 7000 })
        end
        if Config.TakeBloodMoney then
            local takebloodmoney = SearchedPlayer.PlayerData.money["bloodmoney"]
            Player.Functions.AddMoney("bloodmoney", takebloodmoney, "bloodmoney-robbed")
            SearchedPlayer.Functions.RemoveMoney("bloodmoney", takebloodmoney, "bloodmoney-robbed")
            TriggerClientEvent('ox_lib:notify', SearchedPlayer.PlayerData.source, {title = 'Blood Money Robbed', description = 'your blood money has been robbed', type = 'inform', duration = 7000 })
            TriggerClientEvent('ox_lib:notify', Player.PlayerData.source, {title = 'Blood Money Robbed', description = 'you robbed the players blood money', type = 'inform', duration = 7000 })
        end
    end
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
