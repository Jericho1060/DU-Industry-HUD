if enableRemoteControl == true then
    system.print("command 1")
    --Send Command 1
    local selected_machine = elements[selected_machine_index]
    for _,db in pairs(databanks) do
        --selected_machine.command = command_1
        db.setStringValue(selected_machine.id, command_1)
    end
    if emitter ~= nil then
        emitter.send(channels[elementsTypes[selected_index]:lower()], "")
    else
        system.print("Emitter not Linked")
    end
end