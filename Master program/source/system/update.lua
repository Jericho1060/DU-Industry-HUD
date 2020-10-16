local year, month, day, hour, minute, second = epochTime()
local dateStr = year .. "/" .. month .. "/" .. day .. " " .. hour .. ":" .. minute .. ":" .. second
if dateFormat:lower() == "fr" then
    dateStr = day .. "/" .. month .. "/" .. year .. " " .. hour .. ":" .. minute .. ":" .. second
end

hud_main_css = [[
<style>
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
		top: ]] .. tostring((100/1080)*100) .. [[vh;
		left: ]] .. tostring((50/1920)*100) .. [[vw;
		text-transform: uppercase;
		font-weight: bold;
	}
	.hud_machine_detail {
		position: absolute;
		top: ]] .. tostring((100/1080)*100) .. [[vh;
		right: ]] .. tostring((450/1920)*100) .. [[vw;
		text-transform: uppercase;
		font-weight: bold;
	}
	.hud_machines_container {
		position: absolute;
		top: ]] .. tostring((100/1080)*100) .. [[vh;
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
</style>
]]

hud_help_command = [[<div class="hud_help_commands hud_container">
	<table>
		<tr>
			<th colspan="2">
				]] .. dateStr .. [[
			</th>
		</tr>
		<tr>
			<td>Show/Hide HUD</td>
			<th style="text-align:right;">Alt+7</th>
		</tr>
	</table>
</div>]]

hud_elements_type_list = ""
hud_machines = ""
hud_machine_detail = ""

if hud_displayed == true then
    selected_type = elementsTypes[selected_index]
    elementsTypes = {}
    elements = {}
    refresh_id_list = {}
    selectedElementsId = {}
    for _,id in pairs(elementsId) do
        elementType = core.getElementTypeById(id)
        table.insert(elementsTypes, elementType)
        if selected_type == elementType then table.insert(selectedElementsId, id) end
    end
    elementsTypes = removeDuplicatesInTable(elementsTypes)
    table.sort(elementsTypes)
    maxPage = math.ceil(#selectedElementsId / elementsByPage)

    local minOnPage = ((page - 1) * elementsByPage) + 1
    local maxOnPage = page * elementsByPage
    local temp_elements_for_sorting = {}
    for i,id in pairs(selectedElementsId) do
        elementData = {}
        elementData.id = id
        elementData.name = core.getElementNameById(id)
        table.insert(temp_elements_for_sorting, elementData)
    end
    --sorting by name
    table.sort(temp_elements_for_sorting, function(a,b) return a.name:lower() < b.name:lower() end)
    --only get data from displayed elements
    for i,elementData in pairs(temp_elements_for_sorting) do
        if i >= minOnPage and i <= maxOnPage then
            elementType = core.getElementTypeById(elementData.id)
            if Storage.hasKey(elementData.id) == 1 then
                elementData = MyJson.parse(Storage.getStringValue(elementData.id))
            end
            elementData.type = elementType
            elementData.name = core.getElementNameById(elementData.id)
            elementData.position = core.getElementPositionById(elementData.id)
            table.insert(refresh_id_list, elementData.id)
            table.insert(elements, elementData)
        end
    end
    hud_elements_type_list = [[<div class="hud_list_container hud_container">
        <div style="text-align:center;font-weight:bold;border-bottom:1px solid white;">&#x2191; &nbsp;&nbsp; Ctrl+Arrow Up</div>
    ]]
    for i, elementType in pairs(elementsTypes) do
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
        			<td style="text-align:right;border-bottom:none;">]] .. count .. [[</td>
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
        <table class="elements_table">
        <tr>
    	   <th>id</th>
            <th>Machine Name</th>
            <th>Cycles From Start</th>
            <th>Efficiency</th>
            <th>Status</th>
            <th>Uptime</th>
        </tr>
    ]]
    for i, element in pairs(elements) do
        --system.print(json.encode(element))
        --system.print(elementType[selected_index])
        local status = "-"
        if element.status then status = element.status end
        local status_class = ""
        if status:lower():find("running") then status_class = "text-success" end
        if status:lower():find("stopped") then status_class = "text-info" end
        if status:lower():find("jammed") then status_class = "text-danger" end
        if status:lower():find("pending") then status_class = "text-primary" end
        status = status:gsub("JAMMED_", ""):gsub("_", " ")
        local cyclesFromStart = "-"
        if element.cyclesFromStart then cyclesFromStart = element.cyclesFromStart end
        local efficiency = "-"
        if element.efficiency then efficiency = math.floor(element.efficiency*100) end
        local uptime = 0
        if element.uptime then uptime = math.floor(element.uptime) end
        hud_machines = hud_machines .. [[<tr]]
        if selected_machine_index == i then
            hud_machines = hud_machines .. [[ class="selected"]]
        end
        local machine_id = "-"
        if element.id then machine_id = element.id end
        hud_machines = hud_machines .. [[>
                <th>]] .. machine_id .. [[</th>
                <th class="]] .. status_class .. [[">]] .. element.name .. [[</th>
                <td>]] .. cyclesFromStart .. [[</td>
                <td>]] .. efficiency .. [[%</td>
                <th class="]] .. status_class .. [[">]] .. status .. [[</th>
                <td class="]] .. status_class .. [[">]] .. SecondsToClockString(uptime) .. [[</td>
            </tr>
        ]]
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
        local x =  position.x - coreOffset
        local y =  position.y - coreOffset
        local z =  position.z - coreOffset
        if #markers == 0 then
            table.insert(markers, core.spawnArrowSticker(x, y, z+2, "down"))
            table.insert(markers, core.spawnArrowSticker(x, y, z+2, "down"))
            core.rotateSticker(markers[2],0,0,90)
            table.insert(markers, core.spawnArrowSticker(x+1, y, z+1, "north"))
            table.insert(markers, core.spawnArrowSticker(x+1, y, z+1, "north"))
            core.rotateSticker(markers[4],90,90,0)
            table.insert(markers, core.spawnArrowSticker(x-1, y, z+1, "south"))
            table.insert(markers, core.spawnArrowSticker(x-1, y, z+1, "south"))
            core.rotateSticker(markers[6],90,-90,0)
            table.insert(markers, core.spawnArrowSticker(x, y-2, z+1, "east"))
            table.insert(markers, core.spawnArrowSticker(x, y-2, z+1, "east"))
            core.rotateSticker(markers[8],90,0,90)
            table.insert(markers, core.spawnArrowSticker(x, y+2, z+1, "west"))
            table.insert(markers, core.spawnArrowSticker(x, y+2, z+1, "west"))
            core.rotateSticker(markers[10],-90,0,90)
        else
            core.moveSticker(markers[1], x, y, z+2)
            core.moveSticker(markers[2], x, y, z+2)
            core.moveSticker(markers[3], x+1, y, z+1)
            core.moveSticker(markers[4], x+1, y, z+1)
            core.moveSticker(markers[5], x-1, y, z+1)
            core.moveSticker(markers[6], x-1, y, z+1)
            core.moveSticker(markers[7], x, y-2, z+1)
            core.moveSticker(markers[8], x, y-2, z+1)
            core.moveSticker(markers[9], x, y+2, z+1)
            core.moveSticker(markers[10], x, y+2, z+1)
        end
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
            					<th colspan="3">&#x2191; &nbsp;&nbsp; Alt+Arrow Up</th>
            				</tr>
            				<tr>
            					<th colspan="3">Quantity:</th>
            				</tr>
            				<tr>
            					<th>&#x2190; &nbsp;&nbsp; Alt+<br>Arrow Left</th>
            					<th style="font-size:20px;">
            ]]
            for digit_index,digit in pairs(craft_quantity_digits) do
                if digit_index == (#craft_quantity_digits - craft_selected_digit + 1) then
                	hud_machine_detail = hud_machine_detail .. [[<span class="text-success">]]
                end
                hud_machine_detail = hud_machine_detail .. digit
                if digit_index == (#craft_quantity_digits - craft_selected_digit + 1) then
                	hud_machine_detail = hud_machine_detail .. [[</span>]]
                end
            end
            hud_machine_detail = hud_machine_detail .. [[
            				</th>
            				<th>Alt+ &nbsp;&nbsp; &#x2192;<br>Arrow Right</th>
            			 </tr>
                            <tr>
                                <th colspan="3" style="border-bottom:none;">&#x2193; &nbsp;&nbsp; Alt+Arrow Down</th>
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
system.setScreen(hud_main_css .. hud_help_command .. hud_elements_type_list .. hud_machines .. hud_machine_detail)