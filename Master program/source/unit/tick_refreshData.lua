if emitter ~= nil and #elementsTypes > 0 then
    for _,db in pairs(databanks) do
        db.setStringValue("refresh_id_list", MyJson.stringify(refresh_id_list))
    end
    emitter.send(channels[elementsTypes[selected_index]:lower()], "")
end
