local RSGCore = exports['rsg-core']:GetCoreObject()

-- use crafttable
RSGCore.Functions.CreateUseableItem("crafttable", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
    --if Player.Functions.RemoveItem(item.name, 1, item.slot) then
    TriggerClientEvent('rsg-crafttable:client:crafttable', source, item.name)
    --end
end)

--template
--[[
RegisterServerEvent('rsg-crafttable:server:give<item created>')
AddEventHandler('rsg-crafttable:server:give<item created>', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if amount >= 1 then
        Player.Functions.RemoveItem('<ingredent removed>', <amount>)
        Player.Functions.AddItem('<item given>', <amount>)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['<item given'], "add")
        RSGCore.Functions.Notify(src, 'you made some <item given>', 'success')
    else
        RSGCore.Functions.Notify(src, 'something went wrong!', 'error')
        print('something went wrong with Crafting script could be exploint!')
    end
end)]]

-- Craft Weed
RegisterServerEvent('rsg-crafttable:server:giveweed')
AddEventHandler('rsg-crafttable:server:giveweed', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if amount >= 1 then
        Player.Functions.RemoveItem('marijuana', 1)
        Player.Functions.AddItem('weed', 3)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['weed'], "add")
        RSGCore.Functions.Notify(src, 'you made some weed', 'success')
    else
        RSGCore.Functions.Notify(src, 'something went wrong!', 'error')
        print('something went wrong with Crafting script could be exploint!')
    end
end)

--Craft Joint
RegisterServerEvent('rsg-crafttable:server:givejoint')
AddEventHandler('rsg-crafttable:server:givejoint', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if amount >= 1 then
        Player.Functions.RemoveItem('weed', 1)
        Player.Functions.RemoveItem('rollingpaper', 1)
        Player.Functions.AddItem('joint', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['joint'], "add")
        RSGCore.Functions.Notify(src, 'you made a Joint', 'success')
    else
        RSGCore.Functions.Notify(src, 'something went wrong!', 'error')
        print('something went wrong with Crafting script could be exploint!')
    end
end)



