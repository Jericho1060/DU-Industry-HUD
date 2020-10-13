--Send Command 2
local selected_machine = elements[selected_machine_index]
for _,db in pairs(databanks) do
    if db.hasKey(selected_machine.id) == 1 then
        if command_2:find("MAINTAIN") or command_2:find("BATCH") then
            craft_quantity = ""
            for _,digit in pairs(craft_quantity_digits) do
                craft_quantity = craft_quantity .. digit
            end
            command_2 = command_2 .. "_" .. craft_quantity
        end
        selected_machine.command = command_2
        db.setStringValue(selected_machine.id, MyJson.stringify(selected_machine))
        if command_2:find("MAINTAIN") then command_2 = "MAINTAIN" end
        if command_2:find("BATCH") then command_2 = "BATCH" end
    end
end