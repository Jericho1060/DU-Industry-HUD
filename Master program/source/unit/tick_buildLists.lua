local maxForLoop = initIndex + maxAmountOfElementsLoadedBySecond
if maxForLoop > #elementsId then maxForLoop = #elementsId end

selectedElementsId = {}
elementsTypes = {}
for i = listIndex, maxForLoop, 1 do
    --for _,id in pairs(elementsId) do
    listIndex = i
    local id = elementsId[i]
    elementType = core.getElementTypeById(id)
    local elementName = core.getElementNameById(id):lower()
    if
    (elementType:lower():find("container") and elementName:find(containerMonitoringPrefix:lower()))
            or (not elementType:lower():find("container"))
    then
        table.insert(elementsTypes, elementType)
    end
    if selected_type == elementType then
        if
        (elementType:lower():find("container") and elementName:find(containerMonitoringPrefix:lower()))
                or (not elementType:lower():find("container"))
        then
            table.insert(selectedElementsId, id)
        end
    end
end
elementsTypes = removeDuplicatesInTable(elementsTypes)
table.sort(elementsTypes, function(a,b) return a:lower() < b:lower() end)
maxPage = math.ceil(#selectedElementsId / elementsByPage)
if listIndex >= #elementsId then listIndex = 1 end