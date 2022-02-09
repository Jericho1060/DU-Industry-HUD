hud_main_css = [[
    <style>
	   * {
		  font-size: ]] .. tostring(contentFontSize) .. [[px;
	   }
        .hud_container {
            border: 2px solid orange;
            border-radius:10px;
            background-color: rgba(0,0,0,.75);
            padding:10px;
        }
        .hud_help_commands {
            position: absolute;
            top: ]] .. tostring((10/1080)*100) .. [[vh;
            left: ]] .. tostring((50/1920)*100) .. [[vw;
            text-transform: uppercase;
            font-weight: bold;
        }
        .hud_list_container {
            position: absolute;
            top: ]] .. tostring((125/1080)*100) .. [[vh;
            left: ]] .. tostring((50/1920)*100) .. [[vw;
            text-transform: uppercase;
            font-weight: bold;
        }
        .hud_machine_detail {
            position: absolute;
            top: ]] .. tostring((250/1080)*100) .. [[vh;
            right: ]] .. tostring((50/1920)*100) .. [[vw;
            text-transform: uppercase;
            font-weight: bold;
        }
        .hud_machines_container {
            position: absolute;
            top: ]] .. tostring((125/1080)*100) .. [[vh;
            left: ]] .. tostring((300/1920)*100) .. [[vw;
        }
        .elementType {
            margin-top:10px;
            border-radius:5px;
        }
        .elementType.selected {
            border: 2px solid green;
            background-color: rgba(0,200,0,.45);
        }
        tr.selected td, tr.selected th{
            border: 2px solid green;
            background-color: rgba(0,200,0,.1);
        }
        td, th {
            border-bottom:1px solid white;
            padding:5px;
            text-align: center;
        }
        th {
            font-weight: bold;
        }
        .text-success{color: #28a745;}
        .text-danger{color:#dc3545;}
        .text-warning{color:#ffc107;}
        .text-info{color:#17a2b8;}
        .text-primary{color:#007bff;}
        .text-orangered{color:orangered;}
        .bg-success{background-color: #28a745;}
        .bg-danger{background-color:#dc3545;}
        .bg-warning{background-color:#ffc107;}
        .bg-info{background-color:#17a2b8;}
        .bg-primary{background-color:#007bff;}
    </style>
]]

if initIndex >= #elementsIdList then
    unit.stopTimer("init")
    --system.print(MyJson.stringify(allTypes))
    if not isTimerStarted then
        isTimerStarted = true
        unit.setTimer("buildLists",1)
        system.setScreen(hud_main_css .. hud_help_command .. [[
            <div class="hud_list_container hud_container">
            	<table style="width:100%">
            		<tr>
            			<th>LOADING ]] .. math.floor(initIndex*100/#elementsIdList) .. [[% ...</th>
            		</tr>
            	</table>
            </div>
        ]])
    else
        hud_elements_type_list = ""
        hud_machines = ""
        hud_machine_detail = ""

        minOnPage = ((page - 1) * elementsByPage) + 1
        maxOnPage = page * elementsByPage
    
        elements = {}
        refresh_id_list = {}
        local temp_elements_for_sorting = {}
        for i,id in pairs(selectedElementsId) do
            elementData = {}
            elementData.id = id
            elementData.name = core.getElementNameById(id)
            table.insert(temp_elements_for_sorting, elementData)
        end
        table.sort(temp_elements_for_sorting, function(a,b) return a.name:lower() < b.name:lower() end)
        for i,elementData in pairs(temp_elements_for_sorting) do
            if i >= minOnPage and i <= maxOnPage then
                elementType = core.getElementTypeById(elementData.id)
                --if Storage.hasKey(elementData.id) == 1 then
                --    elementData = MyJson.parse(Storage.getStringValue(elementData.id))
                --end
                elementData.type = elementType
                elementData.name = core.getElementNameById(elementData.id)
                elementData.position = core.getElementPositionById(elementData.id)
                --elementData.status = core.getElementIndustryStatus(elementData.id)
                
                table.insert(refresh_id_list, elementData.id)
                table.insert(elements, elementData)
            end
        end
        
        if hud_displayed == true then
            selected_type = elementsTypes[selected_index]
            
            hud_elements_type_list = [[<div class="hud_list_container hud_container">
                <div style="text-align:center;font-weight:bold;border-bottom:1px solid white;">&#x2191; &nbsp;&nbsp; Ctrl+Arrow Up</div>
            ]]
            for i, elementType in pairs(elementsTypes) do
                --system.print(elementType)
                hud_elements_type_list = hud_elements_type_list .. [[<div class="elementType]]
                if i == selected_index then
                    hud_elements_type_list = hud_elements_type_list .. " selected"
                end
                local count = 0
                if machines_count[elementType:lower()] ~= nil then count = machines_count[elementType:lower()] end
                hud_elements_type_list = hud_elements_type_list .. [[">
                    <table style="width:100%;">
                        <tr>
                            <th style="text-align:left;border-bottom:none;">]].. elementType .. [[</th>
                            <td style="text-align:right;border-bottom:none;">]] .. tostring(count) .. [[</td>
                        </tr>
                    </table>
                </div>
                ]]
            end
            hud_elements_type_list = hud_elements_type_list .. [[<div style="margin-top:10px;text-align:center;font-weight:bold;border-top:1px solid white;">&#x2193; &nbsp;&nbsp; Ctrl+Arrow Down</div></div>]]
            local minOnPage = ((page - 1) * elementsByPage) + 1
            if maxOnPage > #selectedElementsId then maxOnPage = #selectedElementsId end
            hud_machines = [[<div class="hud_machines_container hud_container">
                <div style="text-align:center;font-weight:bold;border-bottom:1px solid white;">&#x2191; &nbsp;&nbsp; Arrow Up</div>
                <table class="elements_table" style="width:100%">
                    <tr>
                        <th>&#x2190; &nbsp;&nbsp; Arrow Left</th>
                        <th> Page ]] .. page .. [[/]] .. maxPage .. [[ (from ]] .. minOnPage .. [[ to ]] .. maxOnPage .. [[)</th>
                        <th>Arrow Right &nbsp;&nbsp; &#x2192;</th>
                    </tr>
                </table>
                <table class="elements_table" style="width:100%;">]]
            if selected_index > 0 and #elementsTypes > 0 and elementsTypes[selected_index]:lower():find("container") then
                hud_machines = hud_machines  .. [[
                    <tr>
                       <th>id</th>
                       <th>Container Name</th>
                       <th>Item Name</th>
                       <th>Container Size</th>
                       <th>Item Type</th>
                       <th>Unit Mass</th>
                      <th>Total Mass</th>
                      <th>Amount of Items</th>
                    ]]
                    if not elementsTypes[selected_index]:lower():find("hub") then
                        hud_machines = hud_machines .. [[
                            <th>Container Fill</th>
                        ]]
                    end
                    hud_machines = hud_machines .. [[</tr>
                ]]
                for i, element in pairs(elements) do
                    local splittedName = strSplit(element.name, "_")
                    local itemName = splittedName[2]
                    if not itemName then itemName = "-" end
                    local machine_id = "-"
                    if element.id then machine_id = element.id end
                    local container_size = "hub"
                    local container_empty_mass = getIngredient("Container Hub").mass
                    local container_volume = 0
                    local contentQuantity = 0
                    local ingredient = getIngredient(cleanName(itemName))
                    if not element.type:lower():find("hub") then
                        local containerMaxHP = core.getElementMaxHitPointsById(element.id)
                        if containerMaxHP > 17000 then
                            container_size = "L"
                            container_empty_mass = getIngredient("Container L").mass
                            container_volume = 128000 * (container_proficiency_lvl * 0.1) + 128000
                        elseif containerMaxHP > 7900 then
                            container_size = "M"
                            container_empty_mass = getIngredient("Container M").mass
                            container_volume = 64000 * (container_proficiency_lvl * 0.1) + 64000
                        elseif containerMaxHP > 900 then
                            container_size = "S"
                            container_empty_mass = getIngredient("Container S").mass
                            container_volume = 8000 * (container_proficiency_lvl * 0.1) + 8000
                        else
                            container_size = "XS"
                            container_empty_mass = getIngredient("Container XS").mass
                            container_volume = 1000 * (container_proficiency_lvl * 0.1) + 1000
                        end
                    end
                    local totalMass = core.getElementMassById(element.id)
                    local contentMassKg = totalMass - container_empty_mass
                    local contentMass = contentMassKg
                    local contentMassUnit = "Kg"
                    if contentMass > 1000 then
                        contentMass = contentMass/1000
                        contentMassUnit = "T"
                    end
                    contentMass = utils.round(contentMass*100)/100
                    contentQuantity = contentMassKg / ingredient.mass
                    local contentPercent = 0
                    if (not element.type:lower():find("hub")) --not a hub
                        and (not ingredient.type:lower():find("error")) --not item not found
                    then
                        contentPercent = math.floor((ingredient.volume * contentQuantity)*100/container_volume)
                    end
                    hud_machines = hud_machines .. [[<tr]]
                    if selected_machine_index == i then
                        hud_machines = hud_machines .. [[ class="selected"]]
                    end
                    hud_machines = hud_machines .. [[>
                            <th>]] .. machine_id .. [[</th>
                            <th>]] .. itemName .. [[</th>
                            <th>]] .. ingredient.name .. [[</th>
                           <td>]] .. container_size .. [[</td>
                           <td>]] .. ingredient.type .. [[</td>
                           <td>]] .. ingredient.mass .. [[</td>
                           <td>]] .. contentMass .. " " .. contentMassUnit .. [[</td>
                           <td>]] .. utils.round(contentQuantity*100)/100 .. [[</td>
                    ]]
                    if not element.type:lower():find("hub") then
                         local gauge_color_class = "bg-success"
                         local text_color_class = ""
                         if contentPercent < container_fill_red_level then
                            gauge_color_class = "bg-danger"
                         elseif  contentPercent < container_fill_yellow_level then
                            gauge_color_class = "bg-warning"
                            text_color_class = "text-orangered"
                         end
                        if ingredient.type:lower():find("error") then
                            hud_machines = hud_machines .. [[
                              <th style="position:relative;width: ]] .. tostring((150/1920)*100) .. [[vw;">
                                    -
                               </th>
                            </tr>
                            ]]
                        else
                        hud_machines = hud_machines .. [[
                              <th style="position:relative;width: ]] .. tostring((150/1920)*100) .. [[vw;">
                                    <div class="]] .. gauge_color_class .. [[" style="width:]] .. contentPercent .. [[%;">&nbsp;</div>
                                    <div class="]] .. text_color_class .. [[" style="position:absolute;width:100%;top:0;padding-top:5px;font-weight:bold;">
                                        ]] .. contentPercent .. [[%
                                    </div>
                               </th>
                            </tr>
                        ]]
                        end
                    end
                end
            else
                hud_machines = hud_machines  .. [[
                    <tr>
                       <th>id</th>
                        <th>Machine Name</th>
                	   <th>Selected Recipe</th>
                        <th>Cycles From Start</th>
                        <th>Status</th>
                        <th>Mode</th>
                        <th>Time Remaining</th>
                    </tr>
                ]]

                local elementTable = {}


                for i, element in pairs(elements) do
                    local elementData = {}
                    local statusData = json.decode(core.getElementIndustryStatus(element.id))
                    local recipeName = "-"
                    if not (element.type:lower() == 'transfer unit') then
                        if loadedRecipes[statusData.schematicId] then
                            recipeName = loadedRecipes[statusData.schematicId]
                        else
                            if has_value(recipeToLoad,statusData.schematicId) == false then
                                table.insert(recipeToLoad, statusData.schematicId)
                            end
                        end
                    end
                    local remainingTime = 0
                    if (statusData) and (statusData.remainingTime) and (statusData.remainingTime <= (3600*24*365)) then
                        remainingTime = statusData.remainingTime
                    end
                    element.recipeName = recipeName
                    element.remainingTime = remainingTime
                    element.status = statusData.state
                    element.unitsProduced = statusData.unitsProduced
                    local mode = ""
                    element.maintainProductAmount = statusData.maintainProductAmount
                    element.batchesRequested = statusData.batchesRequested
                    if statusData.maintainProductAmount > 0 then
                        mode = "Maintain " .. math.floor(statusData.maintainProductAmount)
                    elseif statusData.batchesRequested > 0 and statusData.batchesRequested <= 99999999 then
                        mode = "Produce " .. math.floor(statusData.batchesRequested)
                    end
                    local status = "-"
                    if element.status then status = element.status end
                    local status_class = ""
                    if status:lower():find("running") then status_class = "text-success" end
                    if status:lower():find("stopped") then status_class = "text-info" end
                    if status:lower():find("jammed") then status_class = "text-danger" end
                    if status:lower():find("pending") then status_class = "text-primary" end
                    status = status:gsub("JAMMED_", ""):gsub("_", " ")
                    local machine_id = "-"
                    if element.id then machine_id = element.id end
                    local unitsProduced = 0
                    if element.unitsProduced then unitsProduced = element.unitsProduced end
                    elementData.time =  SecondsToClockString(remainingTime)
                    elementData.Machine_id = machine_id
                    elementData.Status_Class = status_class
                    elementData.ElementName = element.name
                    elementData.recipeName = recipeName
                    elementData.unitsProduced = unitsProduced
                    elementData.status_class =status_class
                    elementData.status=status
                    elementData.mode=mode
                    elementData.status_class = status_class
                    table.insert(elementTable,1,elementData)
                end
                table.sort(elementTable, function(a,b) return a.recipeName:lower() < b.recipeName:lower() end)

                for i, element in pairs(elementTable) do
                    hud_machines = hud_machines .. [[<tr]]
                    if (selected_machine_index == i) then
                        hud_machines = hud_machines .. [[ class="selected"]]
                    end
                   hud_machines = hud_machines .. [[>
                             <th>]] .. element.Machine_id .. [[</th>
                             <th class="]] .. element.Status_Class .. [[">]] .. element.ElementName .. [[</th>
                             <th>]] ..  element.recipeName  .. [[</th>
                             <td>]] ..  element.unitsProduced .. [[</td>
                             <th class="]] .. element.status_class .. [[">]] .. element.status .. [[</th>
                           <th>]] .. element.mode .. [[</th>
                             <td class="]] .. element.status_class .. [[">]] .. element.time .. [[</td>
                         </tr>
                     ]]
                end
            end
            hud_machines = hud_machines .. [[</table>
            <table class="elements_table" style="width:100%">
                <tr>
                    <th>&#x2190; &nbsp;&nbsp; Arrow Left</th>
                    <th> Page ]] .. page .. [[/]] .. maxPage .. [[ (from ]] .. minOnPage .. [[ to ]] .. maxOnPage .. [[)</th>
                    <th>Arrow Right &nbsp;&nbsp; &#x2192;</th>
                </tr>
            </table>
            <div style="text-align:center;font-weight:bold;border-top:1px solid white;">&#x2193; &nbsp;&nbsp; Arrow Down</div>
            </div>]]
            if #elements > 0 then
                local selected_machine = elements[selected_machine_index]
                local position = vec3(selected_machine.position)
                local x = position.x
                local y = position.y
                local z = position.z
                local offset1 = 1
                local offset15 = 1.5
                local offset2 = 2
                local offset25 = 2.5
                local offsetFromCenter = 0
                if selected_machine.type:lower():find("container") then
                    offset1 = 0
                    offset15 = 0
                    offset2 = 0
                    offset25 = 0
                end
                if selected_machine.type:lower() == "container" then
                    local containerMaxHP = core.getElementMaxHitPointsById(selected_machine.id)
                    if containerMaxHP > 17000 then
                        offsetFromCenter = 4
                    elseif containerMaxHP > 7900 then
                        offsetFromCenter = 2
                    elseif containerMaxHP > 900 then
                        offsetFromCenter = 1
                    else
                        offsetFromCenter = 0.5
                    end
                end
                if #markers == 0 then
                    table.insert(markers, core.spawnArrowSticker(x, y, z, "down"))
                    table.insert(markers, core.spawnArrowSticker(x, y, z, "down"))
                    core.rotateSticker(markers[2],0,0,90)
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "north"))
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "north"))
                    core.rotateSticker(markers[4],90,90,0)
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "south"))
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "south"))
                    core.rotateSticker(markers[6],90,-90,0)
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "east"))
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "east"))
                    core.rotateSticker(markers[8],90,0,90)
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "west"))
                    table.insert(markers, core.spawnArrowSticker(x, y, z + offset15, "west"))
                    core.rotateSticker(markers[10],-90,0,90)
                else
                    core.moveSticker(markers[1], x, y, z + offset25 + offsetFromCenter)
                    core.moveSticker(markers[2], x, y, z + offset25 + offsetFromCenter)
                    core.moveSticker(markers[3], x + offset1 + offsetFromCenter, y, z + offset15)
                    core.moveSticker(markers[4], x + offset1 + offsetFromCenter, y, z + offset15)
                    core.moveSticker(markers[5], x - offset1 - offsetFromCenter, y, z + offset15)
                    core.moveSticker(markers[6], x - offset1 - offsetFromCenter, y, z + offset15)
                    core.moveSticker(markers[7], x, y - offset2 - offsetFromCenter, z + offset15)
                    core.moveSticker(markers[8], x, y - offset2 - offsetFromCenter, z + offset15)
                    core.moveSticker(markers[9], x, y + offset2 + offsetFromCenter, z + offset15)
                    core.moveSticker(markers[10], x, y + offset2 + offsetFromCenter, z + offset15)
                end
                if (not selected_machine.type:lower():find("container")) and (enableRemoteControl == true) then
                    local status = "-"
                    if selected_machine.status then status = selected_machine.status end
                    local status_class = ""
                    local machines_actions = {}
                    if status:lower():find("running") then status_class = "text-success" end
                    if status:lower():find("stopped") then status_class = "text-info" end
                    if status:lower():find("jammed") then status_class = "text-danger" end
                    if status:lower():find("pending") then status_class = "text-primary" end
                    status = status:gsub("JAMMED_", ""):gsub("_", " ")
                    hud_machine_detail = [[<div class="hud_machine_detail hud_container">
                            <table>
                                <tr>
                                    <th colspan="3">]] .. selected_machine.name .. [[</th>
                                </tr>
                                <tr>
                                    <th class="]] .. status_class .. [[" colspan="3">]] .. status .. [[</th>
                                </tr>
                    ]]
                    if status == "-" then
                        command_1 = ""
                        command_2 = ""
                        command_3 = ""
                        hud_machine_detail = hud_machine_detail .. [[
                            <tr>
                                <td>Machine Not Connected</td>
                            </tr>
                        ]]
                    elseif status:lower():find("stopped") then
                        command_1 = "START"
                        command_2 = "BATCH"
                        command_3 = "MAINTAIN"
                        hud_machine_detail = hud_machine_detail .. [[
                            <tr>
                                <th>START</th>
                                <th></th>
                                <th>ALT+1</th>
                            </tr>
                            <tr>
                                <th style="height:65px;">BATCH</th>
                                <th rowspan="2">
                                    <table>
                                        <tr>
                                            <th colspan="3">Quantity:</th>
                                        </tr>
                                        <tr>
                                            <th style="font-size:20px;">
                        ]]
                        local has_quantity = false
                        for k,v in pairs(craft_quantity_digits) do
                             if tonumber(v) == nil then v = 0 end
                        	if tonumber(v) > 0 then
                            	has_quantity = true
                        	end
                        end
                        if not has_quantity then
                            local value = "0"
                            if selected_machine.maintainProductAmount > 0 then
                                --mode = "Maintain " .. selected_machine.maintainProductAmount
                                value = tostring(math.floor(selected_machine.maintainProductAmount))
                            elseif selected_machine.batchesRequested > 0 and selected_machine.batchesRequested <= 99999999 then
                                --mode = "Produce " .. selected_machine.batchesRequested
                                value = tostring(math.floor(selected_machine.batchesRequested))
                            end
                            for i = #value, 1, -1 do
                                local c = value:sub(i,i)
                                craft_quantity_digits[9-(#value-(i-1))] = c
                            end
                        end
                        for digit_index,digit in pairs(craft_quantity_digits) do
                            hud_machine_detail = hud_machine_detail .. digit
                        end
                        hud_machine_detail = hud_machine_detail .. [[
                                        </th>
                                     </tr>
                                    </table>
                                </th>
                                <th>ALT+2</th>
                            </tr>
                            <tr>
                                <th>MAINTAIN</th>
                                <th>ALT+3</th>
                            </tr>
                        ]]
                    else
                        command_1 = "STOP"
                        command_2 = "SOFT_STOP"
                        command_3 = ""
                        hud_machine_detail = hud_machine_detail .. [[
                            <tr>
                                <th>STOP</th>
                                <th>ALT+1</th>
                            </tr>
                            <tr>
                                <th>FINISH AND STOP</th>
                                <th>ALT+2</th>
                            </tr>
                        ]]
    
                    end
                    hud_machine_detail = hud_machine_detail .. [[</table></div>]]
                end
            end
        end
        system.setScreen(hud_main_css .. hud_help_command .. hud_elements_type_list .. hud_machines .. hud_machine_detail)
    end
    
else
    system.setScreen(hud_main_css .. hud_help_command .. [[
        <div class="hud_list_container hud_container">
        	<table style="width:100%">
        		<tr>
        			<th>LOADING ]] .. math.floor(initIndex*100/#elementsIdList) .. [[% ...</th>
        		</tr>
        	</table>
        </div>
    ]])
end