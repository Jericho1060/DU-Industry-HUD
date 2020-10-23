--[[
	Remove duplicate elements in a lua table
	By Jericho
]]
function removeDuplicatesInTable(data)
    local hash = {}
    local res = {}
    for _,v in ipairs(data) do
        if (not hash[v]) then
            res[#res+1] = v
            hash[v] = true
        end
    end
    return res
end

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