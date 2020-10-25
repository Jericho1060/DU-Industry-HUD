unit.hide()
databank = nil
industries = {}
for slot_name, slot in pairs(unit) do
    if
        type(slot) == "table"
        and type(slot.export) == "table"
        and slot.getElementClass
    then
        slot_type = slot.getElementClass():lower()
        if slot_type == 'databankunit' then
            databank = slot
        end

        if slot_type == "assembly line" or
           slot_type == "glass furnace" or
           slot_type == "3d printer" or
           slot_type == "smelter" or
           slot_type == "recycler" or
           slot_type:find("refiner") or
           slot_type:find("industry") or
           slot_type == "transfer unit"
        then
            table.insert(industries, slot)
        end
    end
end
if databank ~= nil then
    local refresh_id_list = {}
    for _,slot in pairs(industries) do
        local slot_id = slot.getId()
        if databank.hasKey("refresh_" .. tostring(slot_id)) then
            table.insert(refresh_id_list, slot_id)
        end
    end
    for i = 1, #industries, 1 do
         local id = industries[i].getId()
         if hasValue(refresh_id_list, id) then
            local data = {}
             if databank.hasKey(id) == 1 then
                data = MyJson.parse(databank.getStringValue(id))
                if data.command ~= nil and data.command ~= "" then
                    if data.command:lower() == "start" then
                        industries[i].start()
                    elseif data.command:lower():find("maintain") then
                        local splitted = strSplit(data.command, "_")
                        local quantity = tonumber(splitted[2])
                        if quantity == 0 then industries[i].startAndMaintain()
                        else industries[i].startAndMaintain(quantity)
                        end
                    elseif data.command:lower():find("batch") then
                        local splitted = strSplit(data.command, "_")
                        local quantity = tonumber(splitted[2])
                        if quantity == 0 then industries[i].batchStart()
                        else industries[i].batchStart(quantity)
                        end
                    elseif data.command:lower() == "stop" then
                        industries[i].hardStop(0)
                    elseif data.command:lower() == "soft_stop" then
                        industries[i].softStop()
                    end
                    data.command = ""
                end
             else
                data.command = ""
             end
             data.id = id
             data.status = industries[i].getStatus()
             data.cyclesFromStart = industries[i].getCycleCountSinceStartup()
             data.efficiency = industries[i].getEfficiency()
             data.uptime = industries[i].getUptime()
             local jsonData = MyJson.stringify(data)
             databank.setStringValue(id, jsonData)
         end
    end
end
unit.exit()