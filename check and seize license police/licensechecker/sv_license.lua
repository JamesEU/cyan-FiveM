local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')

--settings-
DISCORD_URL = "" --your own webhook--
discordbotname = "Helper" --The username of the bot who sends the message to your discord
permission = "police.drag" -- the permission you want to be able to access this command
license = "driver" -- this is the license it wants to check for/ must be set up in groups.lua



RegisterCommand("checklicense", function(source)
    local player = source
    local userid = vRP.getUserId({source})
    if vRP.hasPermission({userid, permission}) then
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            local target = vRP.getUserId({nplayer})
            if target == nil then 
                vRPclient.notify(source,{"~r~No Player Nearby"})
            elseif vRP.hasGroup({target, license}) then
                vRPclient.notify(target,{"Officer is checking your driving license."})
                vRPclient.notify(source,{"~g~Driver has license."})
            else
                vRPclient.notify(source,{"~r~Driver does not a driving license."})
            end
        end)
    end
end)


 RegisterCommand("removelicense", function(source)
    local player = source 
    local userid = vRP.getUserId({source})
    local name = GetPlayerName(source)
    if vRP.hasPermission({userid, permission}) then 
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            local target = vRP.getUserId({nplayer})
            if target == nil then
                vRPclient.notify(source,{"~r~No Player Nearby"})
            elseif vRP.hasGroup({target, license}) then 
                vRP.removeUserGroup({target,license})
                vRP.removeUserGroup({target,"driver"})
                vRPclient.notify(source,{"~g~Removed Driving License from ID: " ..target})
                vRPclient.notify(target,{"~r~Officer " ..name.. " Has removed your driving license."})
                sendToDiscord(name,"Officer: " ..name.. " ID: " ..userid.. " Removed Driving License from ID: "..target)
            else
                vRPclient.notify(source,{"~r~Driver does not have a driving license."})
            end
        end)
    end
end)

function sendToDiscord(name, message)
    PerformHttpRequest(DISCORD_URL, function(err, text, headers) end, 'POST', json.encode({username = discordbotname, content = message}), { ['Content-Type'] = 'application/json' })
  end

