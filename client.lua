-- Teleport-check hver 10 sekunder
Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("ac:checkTeleport")
        Citizen.Wait(10000)
    end
end)

-- Lua Executor Detection
Citizen.CreateThread(function()
    for _, func in pairs(Config.BlacklistedFunctions) do
        if _G[func] then
            TriggerServerEvent("ac:detectLuaExecutor", func)
        end
    end
end)
