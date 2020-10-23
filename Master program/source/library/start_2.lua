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

--[[
	Convert timestamp in a string representing a dureation in days, hours, minutes and seconds
	By Jericho
]]
function SecondsToClockString(seconds)
  local seconds = tonumber(seconds)

  if seconds == nil or seconds <= 0 then
    return "-";
  else
    days = string.format("%2.f", math.floor(seconds/(3600*24)));
    hours = string.format("%2.f", math.floor(seconds/3600 - (days*24)));
    mins = string.format("%2.f", math.floor(seconds/60 - (hours*60) - (days*24*60)));
    secs = string.format("%2.f", math.floor(seconds - hours*3600  - (days*24*60*60) - mins *60));
    str = ""
    if tonumber(days) > 0 then str = str .. days.."d " end
    if tonumber(hours) > 0 then str = str .. hours.."h " end
    if tonumber(mins) > 0 then str = str .. mins.."m " end
    if tonumber(secs) > 0 then str = str .. secs .."s" end
    return str
  end
end