if ctrlPressed and displayMode < 3 then
    statusFilterType = statusFilterType + 1
    if statusFilterType > maxFilterType then statusFilterType = 0 end
    onFilterChange()
elseif displayMode < 3 then
    selectedRow = selectedRow + 1
    if selectedRow > maxOnPage then selectedRow = 1 end
    onRowChange()
end
