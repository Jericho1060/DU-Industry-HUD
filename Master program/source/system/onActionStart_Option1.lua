if #databanks > 0 and emitter ~= nil and selected_machine ~= nil and (displayType == 0 or displayType == 1) then
    --Send Command 1
    for _,db in pairs(databanks) do
        db.setStringValue(selected_machine.id, command_1)
    end
    emitter.send(channels[selected_machine.typeFilter:lower()], "")
end
