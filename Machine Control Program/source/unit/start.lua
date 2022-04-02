unit.hide()

--[[
	split a string on a delimiter
	By jericho
]]
function strSplit(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

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
        if (slot_type:find("industry")) then
            table.insert(industries, slot)
        end
    end
end
if databank ~= nil then
    for _,slot in pairs(industries) do
        local slot_id = slot.getId()
        if databank.hasKey(tostring(slot_id)) == 1 then
            local command = databank.getStringValue(slot_id)
            if command ~= nil and command ~= "" then
                if command:lower() == "start" then
                    slot.start()
                elseif command:lower():find("maintain") then
                    local splitted = strSplit(command, "_")
                    local quantity = tonumber(splitted[2])
                    slot.startAndMaintain(quantity)
                elseif command:lower():find("batch") then
                    local splitted = strSplit(command, "_")
                    local quantity = tonumber(splitted[2])
                    slot.batchStart(quantity)
                elseif command:lower() == "stop" then
                    slot.hardStop(0)
                elseif command:lower() == "soft_stop" then
                    slot.softStop()
                end
                databank.setStringValue(id, "")
            end
        end
    end
end
unit.exit()
