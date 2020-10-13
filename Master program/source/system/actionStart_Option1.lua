--Send Command 1
local selected_machine = elements[selected_machine_index]
for _,db in pairs(databanks) do
    if db.hasKey(selected_machine.id) == 1 then
        selected_machine.command = command_1
        db.setStringValue(selected_machine.id, MyJson.stringify(selected_machine))
    end
end