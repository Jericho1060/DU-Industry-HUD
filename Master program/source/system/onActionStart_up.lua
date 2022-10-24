if ctrlPressed and displayMode < 3 then
    statusFilterType = statusFilterType - 1
    local max = #elementsTypes
    if statusFilterType < 0 then statusFilterType = maxFilterType end
    onFilterChange()
elseif displayMode < 3 then
    selectedRow = selectedRow - 1
    if selectedRow < 1 then selectedRow = maxOnPage end
    onRowChange()
end
