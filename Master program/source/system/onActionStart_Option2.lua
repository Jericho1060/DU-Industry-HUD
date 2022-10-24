if #databanks > 0 and emitter ~= nil and selected_machine ~= nil and (displayType == 0 or displayType == 1) then
    --Send Command 2
    for _,db in pairs(databanks) do
        if command_2:find("MAINTAIN") or command_2:find("BATCH") then
            craft_quantity = ""
            for _,digit in pairs(craft_quantity_digits) do
                craft_quantity = craft_quantity .. digit
            end
            command_2 = command_2 .. "_" .. craft_quantity
        end
        db.setStringValue(selected_machine.id, command_2)
        if command_2:find("MAINTAIN") then command_2 = "MAINTAIN" end
        if command_2:find("BATCH") then command_2 = "BATCH" end
    end
    emitter.send(channels[selected_machine.typeFilter:lower()], "")
end
