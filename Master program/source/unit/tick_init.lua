--load all the machines from the core step by step to avoid CPU Load Errors

local maxForLoop = initIndex + maxAmountOfElementsLoadedBySecond
if maxForLoop > #elementsIdList then maxForLoop = #elementsIdList end
system.print("Loading elements from " .. initIndex .. " to " .. maxForLoop .. " on " .. #elementsIdList)

for i = initIndex, maxForLoop, 1 do
    initIndex = i
    local id = elementsIdList[i]
    elementType = core.getElementTypeById(id):lower()
    if (elementType:find("assembly line") and enableAssemblyMonitoring == true) or
            (elementType:find("glass furnace") and enableGlassMonitoring == true) or
            (elementType:find("3d printer") and enable3DPrinterMonitoring == true) or
            (elementType:find("smelter") and enableSmelterMonitoring == true) or
            (elementType:find("recycler") and enableRecyclerMonitoring == true) or
            (elementType:find("refinery") and enableHoneycombMonitoring == true) or
            (elementType:find("refiner") and enableRefinerMonitoring == true) or
            (elementType:find("industry")
                    and (
                    (elementType:find("chemical") and enableChemicalMonitoring == true) or
                            (elementType:find("electronics") and enableElectronicsMonitoring == true) or
                            (elementType:find("metalwork") and enableMetalworkMonitoring == true)
            )
            ) or
            (elementType == "transfer unit" and enableTransferMonitoring == true) --[[or
           (elementType:find("container") and enableContainerMonitoring == true)
        ]]--
    then
        local formatedType = removeQualityInName(elementType)
        if machines_count[formatedType] ~= nil then
            machines_count[formatedType] = machines_count[formatedType] + 1
        else
            machines_count[formatedType] = 1
        end
        table.insert(elementsId, id)
    end
    if elementType:find("core") then
        --thx to Archaego for the idea of getting the core size by HP
        --thx to Rutiik for the offset values
        local hp = core.getElementHitPointsById(id)
        if hp > 10000 then
            coreOffset = 128
        elseif hp > 1000 then
            coreOffset = 64
        elseif hp > 150 then
            coreOffset = 32
        end
    end
end