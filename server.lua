-- {steamID, points, source}
local players = {}

-- {steamID}
local waiting = {}

-- {steamID}
local connecting = {}

-- Initial points (priority or negative)
local prePoints = Config.Points;

-- Emojis for the queue lottery
local EmojiList = Config.EmojiList

-- Stop the default hardcap resource
StopResource('hardcap')

-- Restart hardcap if this resource stops
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if GetResourceState('hardcap') == 'stopped' then
            StartResource('hardcap')
        end
    end
end)

-- Client connection handler
AddEventHandler("playerConnecting", function(name, reject, def)
    local source = source
    local steamID = GetSteamID(source)

    -- Reject players without Steam
    if not steamID then
        reject(Config.NoSteam)
        CancelEvent()
        return
    end

    -- Start the queue, cancel if client exits
    if not QueueHandler(steamID, def, source) then
        CancelEvent()
    end
end)

-- Main function for queue handling using 'deferrals' from playerConnecting
function QueueHandler(steamID, def, source)
    def.defer()

    -- Prevent spamming and give time for lists to update
    AntiSpam(def)

    -- Remove player from any waiting or connecting list
    Purge(steamID)

    -- Add or update the player list
    AddPlayer(steamID, source)

    -- Add player to the waiting list
    table.insert(waiting, steamID)

    local stop = false
    repeat
        for i, p in ipairs(connecting) do
            if p == steamID then
                stop = true
                break
            end
        end

        -- Check if a player in the queue has ping = 0 (cancel detected)
        for j, sid in ipairs(waiting) do
            for i, p in ipairs(players) do
                if sid == p[1] and p[1] == steamID and (GetPlayerPing(p[3]) == 0) then
                    Purge(steamID)
                    def.done(Config.Accident)
                    return false
                end
            end
        end

        -- Update waiting message
        def.update(GetMessage(steamID))

        Citizen.Wait(Config.TimerRefreshClient * 1000)

    until stop
    
    -- Allow connection once done
    def.done()
    return true
end

-- Regularly check for available slots and connect players
Citizen.CreateThread(function()
    local maxServerSlots = GetConvarInt('sv_maxclients', 32)
    
    while true do
        Citizen.Wait(Config.TimerCheckPlaces * 1000)

        CheckConnecting()

        if #waiting > 0 and #connecting + #GetPlayers() < maxServerSlots then
            ConnectFirst()
        end
    end
end)

-- Update player points regularly
Citizen.CreateThread(function()
    while true do
        UpdatePoints()
        Citizen.Wait(Config.TimerUpdatePoints * 1000)
    end
end)

-- Deduct points if a player is kicked
RegisterServerEvent("rocademption:playerKicked")
AddEventHandler("rocademption:playerKicked", function(src, points)
    local sid = GetSteamID(src)
    Purge(sid)
    
    for i, p in ipairs(prePoints) do
        if p[1] == sid then
            p[2] = p[2] - points
            return
        end
    end

    local initialPoints = GetInitialPoints(sid)
    table.insert(prePoints, {sid, initialPoints - points})
end)

-- Remove player from queue when they connect
RegisterServerEvent("rocademption:playerConnected")
AddEventHandler("rocademption:playerConnected", function()
    local sid = GetSteamID(source)
    Purge(sid)
end)

-- Remove player from queue if they disconnect
AddEventHandler("playerDropped", function(reason)
    local steamID = GetSteamID(source)
    Purge(steamID)
end)

-- Remove players from connecting list if their ping exceeds a threshold
function CheckConnecting()
    for i, sid in ipairs(connecting) do
        for j, p in ipairs(players) do
            if p[1] == sid and (GetPlayerPing(p[3]) == 500) then
                table.remove(connecting, i)
                break
            end
        end
    end
end

-- Connect the player with the highest points from the waiting list
function ConnectFirst()
    if #waiting == 0 then return end

    local maxPoint = 0
    local maxSid = waiting[1][1]
    local maxWaitId = 1

    for i, sid in ipairs(waiting) do
        local points = GetPoints(sid)
        if points > maxPoint then
            maxPoint = points
            maxSid = sid
            maxWaitId = i
        end
    end
    
    table.remove(waiting, maxWaitId)
    table.insert(connecting, maxSid)
end

-- Retrieve player points
function GetPoints(steamID)
    for i, p in ipairs(players) do
        if p[1] == steamID then
            return p[2]
        end
    end
end

-- Update points for all players
function UpdatePoints()
    for i, p in ipairs(players) do
        local found = false
        for j, sid in ipairs(waiting) do
            if p[1] == sid then
                p[2] = p[2] + Config.AddPoints
                found = true
                break
            end
        end
        
        if not found then
            p[2] = p[2] - Config.RemovePoints
            if p[2] < GetInitialPoints(p[1]) - Config.RemovePoints then
                Purge(p[1])
                table.remove(players, i)
            end
        end
    end
end
