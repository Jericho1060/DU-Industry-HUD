--load all the machines from the core step by step to avoid CPU Load Errors

maxAmountOfElementsLoadedBySecond = 2500 --export: if cpu load errors at start, lower that value

local maxForLoop = initIndex + maxAmountOfElementsLoadedBySecond
if maxForLoop > #elementsIdList then maxForLoop = #elementsIdList end
--system.print("init --- " .. initIndex .. " --- " .. maxForLoop)

for i = initIndex, maxForLoop, 1 do
    	initIndex = i
    	local id = elementsIdList[i]
        elementType = core.getElementTypeById(id):lower()
        if (elementType == "assembly line" and enableAssemblyMonitoring == true) or
           (elementType == "glass furnace" and enableGlassMonitoring == true) or
           (elementType == "3d printer" and enable3DPrinterMonitoring == true) or
           (elementType == "smelter" and enableSmelterMonitoring == true) or
           (elementType == "recycler" and enableRecyclerMonitoring == true) or
           (elementType:find("refinery") and enableHoneycombMonitoring == true) or
           (elementType == "refiner" and enableRefinerMonitoring == true) or
           (elementType:find("industry")
                and (
                    (elementType:find("chemical") and enableChemicalMonitoring == true) or
                    (elementType:find("electronics") and enableElectronicsMonitoring == true) or
                    (elementType:find("metalwork") and enableMetalworkMonitoring == true)
                )
            ) or
           (elementType == "transfer unit" and enableTransferMonitoring == true) or
           (elementType:find("container") and enableContainerMonitoring == true)
        then
            if machines_count[elementType:lower()] ~= nil then
                machines_count[elementType:lower()] = machines_count[elementType:lower()] + 1
            else
                machines_count[elementType:lower()] = 1
            end
            table.insert(elementsId, id)
        end
        if elementType:find("core") then
            --thx to Archargo for that
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