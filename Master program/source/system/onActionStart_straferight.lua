if page < maxPage then
    page = page + 1
    reloadMachinesOnPageChange()
elseif page ~= 1 then
    page = 1
    reloadMachinesOnPageChange()
end
