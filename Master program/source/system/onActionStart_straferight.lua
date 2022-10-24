if ctrlPressed and (displayMode == 0 or displayMode == 1) then
    statusFilter = statusFilter + 1
    if statusFilter > #statusList then statusFilter = 0 end
    onFilterChange()
elseif (displayType == 0 or displayType == 1) then
    page = page + 1
    if page > maxPage then page = 1 end
    onTablePageChange()
end
