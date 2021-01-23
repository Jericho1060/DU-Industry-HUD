local maxForLoop = listIndex + maxAmountOfElementsLoadedBySecond
if maxForLoop > #elementsId then maxForLoop = #elementsId end

for i = listIndex, maxForLoop, 1 do
    listIndex = i
    local id = elementsId[i]
    elementType = core.getElementTypeById(id)
    local elementName = core.getElementNameById(id):lower()
    if
    (elementType:lower():find("container")
            and elementName:find(containerMonitoringPrefix:lower()))
            or (not elementType:lower():find("container"))
    then
        local formatedName = removeQualityInName(elementType)
        table.insert(elementsTypes, formatedName)
    end
    if selected_type == removeQualityInName(elementType) then
        if
        (elementType:lower():find("container") and elementName:find(containerMonitoringPrefix:lower()))
                or (not elementType:lower():find("container"))
        then
            table.insert(selectedElementsId, id)
        end
    end
end
elementsTypes = removeDuplicatesInTable(elementsTypes)
selectedElementsId = removeDuplicatesInTable(selectedElementsId)
table.sort(elementsTypes, function(a,b) return a:lower() < b:lower() end)
maxPage = math.ceil(#selectedElementsId / elementsByPage)
if listIndex >= #elementsId then listIndex = 1 end