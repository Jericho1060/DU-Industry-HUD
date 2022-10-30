if hud.actions.start[action] ~= nil then
    local success, message = pcall(hud.actions.start[action])
    if not success then
        system.print("Action Start '" .. action .. "' Error : " .. message)
    end
end
