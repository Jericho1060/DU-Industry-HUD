if emitter ~= nil and #elementsTypes > 0 then
    emitter.send(channels[elementsTypes[selected_index]:lower()], "")
end
