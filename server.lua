-- Teleport Detection
local lastCoords = {}

RegisterServerEvent("ac:checkTeleport")
AddEventHandler("ac:checkTeleport", function()
    local player = source
    local ped = GetPlayerPed(player)
    local coords = GetEntityCoords(ped)

    if lastCoords[player] then
        local distance = #(coords - lastCoords[player])

        if distance > 200.0 then -- Hvis spilleren teleporteres langt væk
            if Config.EnableTeleportDetection then
                CaptureScreenshot(player, "Teleport Hack")
                LogBan(player, "Teleport Hack")
                DropPlayer(player, "[ANTI-CHEAT] Teleport Hack Detected!")
            end
        end
    end

    lastCoords[player] = coords
end)

-- Explosions Detection (kan aktiveres/deaktiveres via config)
if Config.EnableExplosionDetection then
    AddEventHandler("explosionEvent", function(sender, ev)
        if Config.BlacklistedExplosions[ev.explosionType] then
            CancelEvent()
            CaptureScreenshot(sender, "Explosions Hack")
            LogBan(sender, "Explosions Hack")
            DropPlayer(sender, "[ANTI-CHEAT] Explosions Hack Detected!")
        end
    end)
end

-- Lua Executor Detection
RegisterServerEvent("ac:detectLuaExecutor")
AddEventHandler("ac:detectLuaExecutor", function(detectedFunction)
    local player = source

    for _, func in pairs(Config.BlacklistedFunctions) do
        if string.find(detectedFunction, func) then
            CaptureScreenshot(player, "Lua Executor Detected")
            LogBan(player, "Lua Executor Detected")
            DropPlayer(player, "[ANTI-CHEAT] Lua Executor Detected!")
            break
        end
    end
end)

-- Logger bans til MySQL & sender besked til Discord
function LogBan(player, reason)
    local playerName = GetPlayerName(player)
    local playerIP = GetPlayerEndpoint(player)
    local identifiers = GetPlayerIdentifiers(player)

    local license, discord = "N/A", "N/A"
    for _, id in ipairs(identifiers) do
        if string.find(id, "license:") then license = id end
        if string.find(id, "discord:") then discord = id end
    end

    exports.oxmysql:execute("INSERT INTO anticheat_logs (name, ip, license, discord, reason) VALUES (?, ?, ?, ?, ?)", {
        playerName, playerIP, license, discord, reason
    })

    SendDiscordLog(playerName, reason)

    print("[ANTI-CHEAT] Ban logget: " .. playerName .. " (" .. reason .. ")")
end

-- Screenshot-funktion
function CaptureScreenshot(player, reason)
    exports['screenshot-basic']:requestClientScreenshot(player, {
        encoding = 'jpg',
        quality = 70
    }, function(image)
        if image then
            exports.oxmysql:execute("INSERT INTO anticheat_screenshots (name, reason, image) VALUES (?, ?, ?)", {
                GetPlayerName(player), reason, image
            })
            SendDiscordLog(GetPlayerName(player), reason, image)
            print("[ANTI-CHEAT] Screenshot taget for " .. GetPlayerName(player) .. " (" .. reason .. ")")
        end
    end)
end

-- Sender besked til Discord
function SendDiscordLog(playerName, reason, image)
    local embed = {
        {
            ["color"] = 16711680, -- Rød
            ["title"] = "🚨 AntiCheat Alert 🚨",
            ["description"] = "**Spiller:** " .. playerName .. "\n**Grund:** " .. reason,
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    
    if image then
        table.insert(embed, {["image"] = {["url"] = "data:image/jpeg;base64," .. image}})
    end

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, "POST", json.encode({embeds = embed}), {["Content-Type"] = "application/json"})
end
