local RSGCore = exports['rsg-core']:GetCoreObject()
local crafttable = 0
isLoggedIn = false
PlayerJob = {}

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded')
AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = RSGCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('RSGCore:Client:OnJobUpdate')
AddEventHandler('RSGCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

-- setup crafttable
RegisterNetEvent('rsg-crafttable:client:crafttable')
AddEventHandler('rsg-crafttable:client:crafttable', function(itemName) 
    if crafttable ~= 0 then
        SetEntityAsMissionEntity(crafttable)
        DeleteObject(crafttable)
        crafttable = 0
    else
        local playerPed = PlayerPedId()
        TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
        Wait(10000)
        ClearPedTasks(playerPed)
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
        --local pos = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55))
        local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55)
        --local modelHash = `p_troughtable01x`
        local modelHash = -652904703
        if not HasModelLoaded(modelHash) then
            -- If the model isnt loaded we request the loading of the model and wait that the model is loaded
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(1)
            end
        end
        local prop = CreateObject(modelHash, pos, true)
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(prop)
        PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
        crafttable = prop
    end
end, false)

-- create Craft Table
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
        local ctableObject = GetClosestObjectOfType(pos, 5.0, -652904703, false, false, false)
        if ctableObject ~= 0 then
            local objectPos = GetEntityCoords(ctableObject)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Craft [J]")
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    TriggerEvent('rsg-crafttable:client:craftmenu')
                end
            end
        end
    end
end)

-- Craft Menu
RegisterNetEvent('rsg-crafttable:client:craftmenu', function(data)
    exports['rsg-menu']:openMenu({
        {
            header = "| Crafting |",
            isMenuHeader = true,
        },
        {
            header = "Grind Weed",
            txt = "1 x Marijuana and 1 x Grinder",
            params = {
                event = 'rsg-crafttable:client:weed',
                isServer = false,
            }
        },
        {
            header = "Roll Joint",
            txt = "1 x Weed and 1 x Rolling Paper",
            params = {
                event = 'rsg-crafttable:client:joint',
                isServer = false,
            }
        },
        {
            header = "Close Menu",
            txt = '',
            params = {
                event = 'rsg-menu:closeMenu',
            }
        },
    })
end)

--===Craftable Items===--

--item Template
--[[
RegisterNetEvent("rsg-crafttable:client:<name of item>")--
AddEventHandler("rsg-crafttable:client:<name of item>", function()
    local hasItem1 = RSGCore.Functions.HasItem('<ingredient>', <amount>) --ingredient and amount
    local hasItem2 = RSGCore.Functions.HasItem('<ingredient>',<amount>) 
    if hasItem1 and hasItem2  then
        local player = PlayerPedId()
        TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), <craft time in milliseconds>, true, false, false, false)
        Wait(Config.BrewTime)
        ClearPedTasks(player)
        SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
        TriggerServerEvent('rsg-crafttable:server:give<item creadted>', <amount>)
        PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
    else
        RSGCore.Functions.Notify('you don\'t have the ingredients to make this!', 'error')
    end
end)]]

--make weed
RegisterNetEvent("rsg-crafttable:client:weed")--
AddEventHandler("rsg-crafttable:client:weed", function()
    local hasItem1 = RSGCore.Functions.HasItem('marijuana', 1)
    local hasItem2 = RSGCore.Functions.HasItem('grinder', 1)
    if hasItem1 and hasItem2  then
        local player = PlayerPedId()
        TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_BARTENDER_CLEAN_GLASS'), 15000, true, false, false, false)
        Wait(15000)
        ClearPedTasks(player)
        SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)

        TriggerServerEvent('rsg-crafttable:server:giveweed', 3)
        PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
    else
        RSGCore.Functions.Notify('you don\'t have the ingredients to make this!', 'error')
    end
end)

-- make Joint
RegisterNetEvent("rsg-crafttable:client:joint")
AddEventHandler("rsg-crafttable:client:joint", function()
    local hasItem1 = RSGCore.Functions.HasItem('weed', 1)
    local hasItem2 = RSGCore.Functions.HasItem('rollingpaper', 1)
    if hasItem1 and hasItem2  then
        local player = PlayerPedId()
        TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_INSPECT'), 15000, true, false, false, false)
        Wait(15000)
        ClearPedTasks(player)
        SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
        TriggerServerEvent('rsg-crafttable:server:givejoint', 1)
        PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
    else
        RSGCore.Functions.Notify('you don\'t have the ingredients to make this!', 'error')
    end
end)

function getMenuTitle(menuid)
    for k,v in pairs(Config.MoonshineVendor)  do
        if menuid == v.uid then
            return v.header
        end
    end
end
