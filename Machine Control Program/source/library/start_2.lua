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
	check if a table contains an element
	By Jericho
]]
function hasValue(tab, val)
  for _,v in ipairs(tab) do
    if v == val then
      return true
    end
  end
  return false
end



function removeQualityInName(name)
  if not name then return '' end
  return name:lower():gsub('basic ', ''):gsub('uncommon ', ''):gsub('advanced ', ''):gsub('rare ', ''):gsub('exotic ', '')
end