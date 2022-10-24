if #databanks > 0 and emitter ~= nil and selected_machine ~= nil and (displayType == 0 or displayType == 1) then
    --Send Command 3
    for _,db in pairs(databanks) do
        if command_3:find("MAINTAIN") or command_3:find("BATCH") then
            craft_quantity = ""
            for _,digit in pairs(craft_quantity_digits) do
                craft_quantity = craft_quantity .. digit
            end
            command_3 = command_3 .. "_" .. craft_quantity
        end
        db.setStringValue(selected_machine.id, command_3)
        if command_3:find("MAINTAIN") then command_3 = "MAINTAIN" end
        if command_3:find("BATCH") then command_3 = "BATCH" end
    end
    emitter.send(channels[selected_machine.typeFilter:lower()], "")
end
