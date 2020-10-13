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