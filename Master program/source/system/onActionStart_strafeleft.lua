if ctrlPressed and (displayMode == 0 or displayMode == 1) then
    statusFilter = statusFilter - 1
    if statusFilter < 0 then statusFilter = #statusList end
    onFilterChange()
elseif (displayType == 0 or displayType == 1) then
    page = page - 1
    if page < 1 then page = maxPage end
    onTablePageChange()
end
