if emitter ~= nil and #elementsTypes > 0 then
    for _,db in pairs(databanks) do
        for _,id in pairs(refresh_id_list) do
        	db.setIntValue("refresh_" .. tostring(id), 1)
        end
    end
    if refreshActivated == true then
    	emitter.send(channels[elementsTypes[selected_index]:lower()], "")
    end
end
