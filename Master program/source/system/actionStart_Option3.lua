--Send Command 3
local selected_machine = elements[selected_machine_index]
for _,db in pairs(databanks) do
    if db.hasKey(selected_machine.id) == 1 then
        if command_3:find("MAINTAIN") or command_3:find("BATCH") then
            craft_quantity = ""
            for _,digit in pairs(craft_quantity_digits) do
                craft_quantity = craft_quantity .. digit
            end
            command_3 = command_3 .. "_" .. craft_quantity
        end
        selected_machine.command = command_3
        db.setStringValue(selected_machine.id, json.encode(selected_machine))
        if command_3:find("MAINTAIN") then command_3 = "MAINTAIN" end
        if command_3:find("BATCH") then command_3 = "BATCH" end
    end
end