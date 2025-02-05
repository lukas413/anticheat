Config = {}

Config.DiscordWebhook = "DIN_DISCORD_WEBHOOK_HER" -- Webhook til logs

-- Teleport-detektion (true = aktiveret, false = deaktiveret)
Config.EnableTeleportDetection = false

-- Eksplosions-detektion (true = aktiveret, false = deaktiveret)
Config.EnableExplosionDetection = true

-- Eksplosions-blacklist (f.eks. tank granater)
Config.BlacklistedExplosions = { 0, 1, 2, 4, 5, 6, 18, 20 }

-- Liste over kendte Lua Executor variabler (anti-executor)
Config.BlacklistedFunctions = {
    "TriggerServerEvent",
    "ExecuteCommand",
    "cheat",
    "exploit"
}
