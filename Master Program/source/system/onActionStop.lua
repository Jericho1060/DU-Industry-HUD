if hud.actions.stop[action] ~= nil then
    local success, message = pcall(hud.actions.stop[action])
    if not success then
        system.print("Action Stop '" .. action .. "' Error : " .. message)
    end
end
