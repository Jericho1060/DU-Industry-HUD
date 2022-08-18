if page > 1 then
    page = page - 1
    reloadMachinesOnPageChange()
elseif page ~= maxPage then
    page = maxPage
    reloadMachinesOnPageChange()
end
