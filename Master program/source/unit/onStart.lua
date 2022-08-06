--[[
    DU Industry HUD By Jericho
]]

local version = "V 3.0.7 - alpha"
local log_split = "================================================="
--printing version in lua chat
system.print(log_split)local a=""local b=math.ceil((50-#version-2)/2)for c=1,b,1 do a=a..'='end;a=a.." "..version.." "for c=1,b,1 do a=a..'='end;system.print(a)system.print(log_split)

--[[
	receivers channels for each type of machine
]]
channel_for_refiner = "receiver_refiner" --export: receiver channel to send orders to refiners
channel_for_assembly = "receiver_assembly" --export: receiver channel to send orders to assembly lines
channel_for_smelter = "receiver_smelters" --export: receiver channel to send orders to smelters
channel_for_chemical = "receiver_chemical" --export: receiver channel to send orders to chemical indutries
channel_for_electronics = "receiver_electronics" --export: receiver channel to send orders to electronic industries
channel_for_glass = "receiver_glass" --export: receiver channel to send orders to glass furnace
channel_for_honeycomb = "receiver_honeycomb_recycler" --export: receiver channel to send orders to honeycomb refiniries
channel_for_recycler = "receiver_honeycomb_recycler" --export: receiver channel to send orders to recylers
channel_for_metalwork = "receiver_metalworks" --export: receiver channel to send orders to metalworks
channel_for_3d_printer = "receiver_3dprinters" --export: receiver channel to send orders to 3d printers
channel_for_transfer = "receiver_transfert" --export: receiver channel to send orders to tranfer units

--[[
    Lua parameters
]]
enableRefinerMonitoring = true --export: enable or disable the Refiners monitoring
enableAssemblyMonitoring = true --export: enable or disable the Assembly lines monitoring
enableSmelterMonitoring = true --export: enable or disable the Smelters monitoring
enableChemicalMonitoring = true --export: enable or disable the Chemical industries monitoring
enableElectronicsMonitoring = true --export: enable or disable the Electronics Industries monitoring
enableGlassMonitoring = true --export: enable or disable the Glass Furnace monitoring
enableHoneycombMonitoring = true --export: enable or disable the Honeycomb Refineries monitoring
enableRecyclerMonitoring = true --export: enable or disable the Recyclers monitoring
enableMetalworkMonitoring = true --export: enable or disable the Metalworks monitoring
enable3DPrinterMonitoring = true --export: enable or disable the 3D Printers monitoring
enableTransferMonitoring = true --export: enable or disable the transfer units monitoring
enableRemoteControl = true --export: enable the HUD to control machines (start/stop/batch/maintain)
elementsByPage = 20 --export: maximum amount of elements displayed on a single page
dateFormat = "en" --export: the country code to format the date
maxAmountOfElementsLoadedByFrame = 1000 --export: if cpu load errors at start, lower that value

--[[
	DO NOT CHANGE THE FOLLOWING
]]

--Utility functions By jericho, see full source at https://github.com/Jericho1060/DualUniverse
function removeDuplicatesInTable(a)local b={}local c={}for d,e in ipairs(a)do if not b[e]then c[#c+1]=e;b[e]=true end end;return c end;function strSplit(a,b)result={}for c in(a..b):gmatch("(.-)"..b)do table.insert(result,c)end;return result end;function SecondsToClockString(a)local a=tonumber(a)if a==nil or a<=0 then return"-"else days=string.format("%2.f",math.floor(a/(3600*24)))hours=string.format("%2.f",math.floor(a/3600-days*24))mins=string.format("%2.f",math.floor(a/60-hours*60-days*24*60))secs=string.format("%2.f",math.floor(a-hours*3600-days*24*60*60-mins*60))str=""if tonumber(days)>0 then str=str..days.."d "end;if tonumber(hours)>0 then str=str..hours.."h "end;if tonumber(mins)>0 then str=str..mins.."m "end;if tonumber(secs)>0 then str=str..secs.."s"end;return str end end;function removeQualityInName(a)if not a then return''end;return a:lower():gsub('basic ',''):gsub('uncommon ',''):gsub('advanced ',''):gsub('rare ',''):gsub('exotic ','')end;function has_value(a,b)for c,d in ipairs(a)do if d==b then return true end end;return false end

--time script to get client date and time by Jericho, see full source at https://github.com/Jericho1060/DualUniverse
function DUCurrentDateTime(a)local b=system.getUtcTime()if not a then b=b+system.getUtcOffset()end;local c=24*60*60;local d=365*c;local e=d+c;local f=4*d+c;local g=4;local h=1970;local i={-1,30,58,89,119,150,180,211,242,272,303,333,364}local j={}for k=1,2 do j[k]=i[k]end;for k=3,13 do j[k]=i[k]+1 end;local l,m,n,o,p,q,r,s;local t=i;s=b;l=math.floor(s/f)s=s-l*f;l=l*4+h;if s>=d then l=l+1;s=s-d;if s>=d then l=l+1;s=s-d;if s>=e then l=l+1;s=s-e else t=j end end end;m=math.floor(s/c)s=s-m*c;local n=1;while t[n]<m do n=n+1 end;n=n-1;local o=m-t[n]p=(math.floor(b/c)+g)%7;if p==0 then p=7 end;q=math.floor(s/3600)s=s-q*3600;r=math.floor(s/60)function round(u,v)if v then return utils.round(u/v)*v end;return u>=0 and math.floor(u+0.5)or math.ceil(u-0.5)end;s=round(s-r*60)local w={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"}local x={"Mon","Tue","Wed","Thu","Fri","Sat","Sun"}local y={"January","February","March","April","May","June","July","August","September","October","November","December"}local z={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}return l,n,o,q,r,s,p,w[p],x[p],y[n],z[n],m+1 end

--databank hub library By Jericho, see full source at https://github.com/Jericho1060/DualUniverse
bankhub={}function bankhub:new(banks)o={}setmetatable(o,self)self.__index=self;o.banks=banks or{}function o.clear()return o:_clear()end;function o.getNbKeys()return o:_getNbKeys()end;function o.getKeys()return o:_getKeys()end;function o.hasKey(a)return o:_hasKey(a)end;function o.getStringValue(a)return o:_getStringValue(a)end;function o.getIntValue(a)return o:_getIntValue(a)end;function o.getFloatValue(a)return o:_getFloatValue(a)end;return o end;function bankhub:add(b)table.insert(self.banks,b)self.banks_size=#self.banks end;function bankhub:_clear()for c,d in pairs(self.banks)do d.clear()end end;function bankhub:_getNbKeys()local e=0;for c,d in pairs(self.banks)do e=e+d.getNbKeys()end;return e end;function bankhub:_getKeys()local e={}for c,d in pairs(self.banks)do local f=json.decode(d.getKeys())for c,g in pairs(f)do table.insert(e,g)end end;return json.encode(e)end;function bankhub:_hasKey(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return 1 end end;return 0 end;function bankhub:_getStringValue(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return d.getStringValue(a)end end;return nil end;function bankhub:_getIntValue(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return banks.getIntValue(a)end end;return nil end;function bankhub:_getFloatValue(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return banks.getFloatValue(a)end end;return nil end

channels = {}
channels['refiner'] = channel_for_refiner
channels['assembly line'] = channel_for_assembly
channels['smelter'] = channel_for_smelter
channels['chemical industry'] = channel_for_chemical
channels['electronics industry'] = channel_for_electronics
channels['glass furnace'] = channel_for_glass
channels['honeycomb refinery'] = channel_for_honeycomb
channels['recycler'] = channel_for_recycler
channels['metalwork industry'] = channel_for_metalwork
channels['3d printer'] = channel_for_3d_printer
channels['transfer unit'] = channel_for_transfer

--[[
    Detecting elements connected on slots
]]
databanks = {}
core = nil
emitter = nil
for slot_name, slot in pairs(unit) do
    if
        type(slot) == "table"
        and type(slot.export) == "table"
        and slot.getClass
    then
        if slot.getClass():lower() == 'databankunit' then
            table.insert(databanks, slot)
        end
        if slot.getClass():lower():find("coreunit") then
            core = slot
        end
        if slot.getClass():lower() == 'emitterunit' then
            emitter = slot
        end
    end
end
if core == nil then
    system.print("Connection to the core is missing")
    unit.exit()
end
if emitter == nil then
    enableRemoteControl = false
    system.print("Connect an Emitter to enable machine control from industry")
end
if #databanks == 0 then
    enableRemoteControl = false
    system.print("No Databank linked")
end

--init of bank hub
Storage = bankhub:new(databanks)

--variable init and loading elements from the core
elementsId = {}
elements = {}
elementsTypes = {}
machines_count = {}
machines_count.total = 0
initIndex = 1
listIndex = 1
init = false
channel_index = 1
selected_index = 1
selected_type = nil
selected_machine_index = 1
selected_machine = nil
hud_displayed = true
page = 1
maxPage = 1
selectedElementsId = {}
Ctrl_pressed = false
craft_quantity = ""
craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
refresh_id_list = {}
craft_selected_digit = 1
command_1 = ""
command_2 = ""
command_3 = ""
refreshActivated = true
hud_help_command = ""
unit.setTimer("helperRefresh",1)
minOnPage = 0
maxOnPage = 0
elementsIdList = core.getElementIdList()
temp_selectedElementsId = {}
temp_elements_for_sorting = {}
temp_elements = {}
temp_refresh_id_list = {}
machineLoaded = false
selected_machine = nil

--init global HUD style
hud_help_command = ''
hud_elements_type_list = ''
hud_machines = ''
hud_machines_rows = {}
controlHud = ''

--construct pos for AR data
constructPos = construct.getWorldPosition()
constructRight = construct.getWorldRight()
constructForward = construct.getWorldForward()
constructUp = construct.getWorldUp()
arhtml = ''

--Boostrap like css for DU by Jericho1060, see full source at https://github.com/Jericho1060/DualUniverse
bootstrap_css_grid = [[<style>.container {width: 100%;padding-right: 15px;padding-left: 15px;margin-right: auto;margin-left: auto;}.row {position:relative;display: flex;flex-wrap: wrap;margin-right: -15px;margin-left: -15px;}.col-1, .col-2, .col-3, .col-4, .col-5, .col-6, .col-7, .col-8, .col-9, .col-10, .col-11, .col-12, .col {position: relative;width: 100%;padding-right: 15px;padding-left: 15px;}.col {flex-basis: 0;flex-grow: 1;max-width: 100%;}.col-auto {flex: 0 0 auto;width: auto;max-width: 100%;}.col-1 {flex: 0 0 8.333333%;max-width: 8.333333%;}.col-2 {flex: 0 0 16.666667%;max-width: 16.666667%;}.col-3 {flex: 0 0 25%;max-width: 25%;}.col-4 {flex: 0 0 33.333333%;max-width: 33.333333%;}.col-5 {flex: 0 0 41.666667%;max-width: 41.666667%;}.col-6 {flex: 0 0 50%;max-width: 50%;}.col-7 {flex: 0 0 58.333333%;max-width: 58.333333%;}.col-8 {flex: 0 0 66.666667%;max-width: 66.666667%;}.col-9 {flex: 0 0 75%;max-width: 75%;}.col-10 {flex: 0 0 83.333333%;max-width: 83.333333%;}.col-11 {flex: 0 0 91.666667%;max-width: 91.666667%;}.col-12 {flex: 0 0 100%;max-width: 100%;}.offset-12 {margin-left: 100%;}.offset-11 {margin-left: 91.66666667%;}.offset-10 {margin-left: 83.33333333%;}.offset-9 {margin-left: 75%;}.offset-8 {margin-left: 66.66666667%;}.offset-7 {margin-left: 58.33333333%;}.offset-6 {margin-left: 50%;}.offset-5 {margin-left: 41.66666667%;}.offset-4 {margin-left: 33.33333333%;}.offset-3 {margin-left: 25%;}.offset-2 {margin-left: 16.66666667%;}.offset-1 {margin-left: 8.33333333%;}.offset-0 {margin-left: 0%;}</style>]]
bootstrap_css_colors = [[<style>.text-white {color: #fff !important;}.text-primary {color: #007bff !important;}.text-secondary {color: #6c757d !important;}.text-success {color: #28a745 !important;}.text-info {color: #17a2b8 !important;}.text-warning {color: #ffc107 !important;}.text-danger {color: #dc3545 !important;}.text-light {color: #f8f9fa !important;}.text-dark {color: #343a40 !important;}.text-body {color: #212529 !important;}.text-muted {color: #6c757d !important;}.text-black-50 {color: rgba(0, 0, 0, 0.5) !important;}.text-white-50 {color: rgba(255, 255, 255, 0.5) !important;}.bg-primary {background-color: #007bff !important;}.bg-secondary {background-color: #6c757d !important;}.bg-success {background-color: #28a745 !important;}.bg-info {background-color: #17a2b8 !important;}.bg-warning {background-color: #ffc107 !important;}.bg-danger {background-color: #dc3545 !important;}.bg-light {background-color: #f8f9fa !important;}.bg-dark {background-color: #343a40 !important;}.bg-white {background-color: #fff !important;}.bg-transparent {background-color: transparent !important;}</style>]]
bootstrap_text_utils = [[<style>.text-left {text-align: left;}.text-right {text-align: right;}.text-center {text-align: center;}.text-justify {text-align: justify;}.text-nowrap {white-space: nowrap;}.text-lowercase {text-transform: lowercase;}.text-uppercase {text-transform: uppercase;}.text-capitalize {text-transform: capitalize;}</style>]]
bootstrap_css = bootstrap_css_grid .. bootstrap_css_colors .. bootstrap_text_utils

local statusList = {"STOPPED","RUNNING","MISSING INGREDIENT","OUTPUT FULL","NO OUTPUT CONTAINER","PENDING","MISSING SCHEMATIC"}
function getIndustryStatusClass(status)
    if status == 1 then
        return "text-info"
    elseif status == 2 then
        return "text-success"
    elseif ((status >= 3) and (status <= 5)) or (status == 7) then
        return "text-danger"
    elseif status == 6 then
        return "text-primary"
    end
    return "" --default value for other status that can be added
end
function getIndustryStatusBgClass(status)
    if status then
        if status == 1 then
            return "bg-info"
        elseif status == 2 then
            return "bg-success"
        elseif ((status >= 3) and (status <= 5)) or (status == 7) then
            return "bg-danger"
        elseif status == 6 then
            return "bg-primary"
        end
    end
    return "" --default value for other status that can be added
end
--[[
    Convert a table in local coordinates to a table in world coordinates by Jericho inspired by Koruzarius
    Source : https://github.com/Jericho1060/DualUniverse/blob/master/Vectors/localToWorldPos.lua
]]--
function ConvertLocalToWorld(a,b,c,d,e)local f={a[1]*c[1],a[1]*c[2],a[1]*c[3]}local g={a[2]*d[1],a[2]*d[2],a[2]*d[3]}local h={a[3]*e[1],a[3]*e[2],a[3]*e[3]}return{f[1]+g[1]+h[1]+b[1],f[2]+g[2]+h[2]+b[2],f[3]+g[3]+h[3]+b[3]}end
--[[
    Concept based on DU-Nested-Coroutines by Jericho
    Source available here: https://github.com/Jericho1060/du-nested-coroutines
]]--

coroutinesTable  = {}
MyCoroutines = {
    function()
        --load all the machines from the core step by step to avoid CPU Load Errors
        if not init then
            local maxForLoop = initIndex + maxAmountOfElementsLoadedByFrame
            if maxForLoop > #elementsIdList then maxForLoop = #elementsIdList end
            system.print("Loading elements from " .. initIndex .. " to " .. maxForLoop .. " on " .. #elementsIdList)

            for i = initIndex, maxForLoop, 1 do
                initIndex = i
                local id = elementsIdList[i]
                elementType = core.getElementDisplayNameById(id):lower()
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
                   (elementType == "transfer unit" and enableTransferMonitoring == true)
                then
                	local formatedType = removeQualityInName(elementType)
                	if
                        (elementType:lower():find("container")
                        and elementName:find(containerMonitoringPrefix:lower()))
                        or (not elementType:lower():find("container"))
                    then
                        table.insert(elementsTypes, formatedType)
                    end
                    if machines_count[formatedType] ~= nil then
                        machines_count[formatedType] = machines_count[formatedType] + 1
                    else
                        machines_count[formatedType] = 1
                    end
                    table.insert(elementsId, id)
                end
            end
            if initIndex >= #elementsIdList then
                elementsTypes = removeDuplicatesInTable(elementsTypes)
                table.sort(elementsTypes, function(a,b) return a:lower() < b:lower() end)
                selected_type = elementsTypes[1]
                init = true
                system.print("All elements loaded")
            end
        end
    end,
    function()
        local count = 0
        if init then
            if selected_type ~= nil and not machineLoaded then
                local count = machines_count[selected_type:lower()]
                local divider = math.ceil(count / 200)
                local maxForLoop = listIndex + math.ceil(maxAmountOfElementsLoadedByFrame / divider)
                if maxForLoop > #elementsId then maxForLoop = #elementsId end
                for i = listIndex, maxForLoop, 1 do
                    listIndex = i
                    local id = elementsId[i]
                    elementType = core.getElementDisplayNameById(id)
                    if selected_type:find(removeQualityInName(elementType)) then
                        if
                            (elementType:lower():find("container")
                            and core.getElementNameById(id):lower():find(containerMonitoringPrefix:lower()))
                            or (not elementType:lower():find("container"))
                        then
                            table.insert(temp_selectedElementsId, id)
                        end
                    end
                    if #temp_selectedElementsId >= count then
                        selectedElementsId = temp_selectedElementsId
                        temp_selectedElementsId = {}
                        maxPage = math.ceil(#selectedElementsId / elementsByPage)
                        listIndex = 1
                        machineLoaded = true
                        if #selectedElementsId ~= count then
                            machineLoaded = false
                        end
                        break
                    end
                    if listIndex >= #elementsId then
                        listIndex = 1
                    end
                end
            end
        end
    end,
    function()
        local year, month, day, hour, minute, second = DUCurrentDateTime()
        local dateStr = string.format("%02d/%02d/%04d %02d:%02d:%02d",day,month,year,hour,minute,second)
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
        coroutine.yield(coroutinesTable[3])
    end,
    function()
        if init then
            hud_elements_type_list = '<div class="hud_list_container hud_container"><div style="text-align:center;border-bottom:1px solid white;">&#x2191; &nbsp;&nbsp; Ctrl+Arrow Up</div>'
            for i, elementType in pairs(elementsTypes) do
                hud_elements_type_list = hud_elements_type_list .. '<div class="elementType'
                if i == selected_index then
                    hud_elements_type_list = hud_elements_type_list .. " selected"
                end
                local count = 0
                if machines_count[elementType:lower()] ~= nil then count = machines_count[elementType:lower()] end
                hud_elements_type_list = hud_elements_type_list .. '"><table style="width:100%;"><tr><th style="text-align:left;border-bottom:none;">'.. elementType .. '</th><td style="text-align:right;border-bottom:none;">' .. tostring(count) .. '</td></tr></table></div>'
            end
            hud_elements_type_list = hud_elements_type_list .. '<div style="margin-top:10px;text-align:center;font-weight:bold;border-top:1px solid white;">&#x2193; &nbsp;&nbsp; Ctrl+Arrow Down</div></div>'
            coroutine.yield(coroutinesTable[4])
        end
    end,
    function()
        for i, element in pairs(elements) do
            if #elements > 0 then
                local statusData = core.getElementIndustryInfoById(element.id)
                local schematicId = statusData.schematicId or 0
                local recipeName = "-"
                if #statusData.currentProducts > 0 then
                    local item = system.getItem(statusData.currentProducts[1].id)
                    if schematicId == 0 then
                        schematicId = item.schematics[1] or 0
                    end
                    if item.locDisplayNameWithSize then
                        recipeName = item.locDisplayNameWithSize
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
                local status = statusList[element.status] or '-'
                local status_class = getIndustryStatusClass(element.status)
                hud_machines_rows[i] = "<tr"
                if selected_machine_index == i then
                    hud_machines_rows[i] = hud_machines_rows[i] .. ' class="selected"'
                end
                local machine_id = "-"
                if element.id then machine_id = element.id end
                local unitsProduced = 0
                if element.unitsProduced then unitsProduced = element.unitsProduced end
                hud_machines_rows[i] = hud_machines_rows[i] .. '><th>' .. machine_id .. '</th><th><span class="' .. status_class .. '">' .. element.name .. '</span><br><small>' .. element.type .. '</small></th><th>' .. recipeName
                if schematicId > 0 then
                    local schematic = system.getItem(schematicId)
                    local schematicsRemaining = statusData.schematicsRemaining
                    local schematic_color = "#fff"
                    if schematicsRemaining == 0 then schematic_color = "text-danger" end
                    hud_machines_rows[i] = hud_machines_rows[i] .. [[<br><small class="]] .. schematic_color .. [[">]] .. schematicsRemaining .. [[ ]] .. schematic.locDisplayNameWithSize .. [[</small>]]
                end
                hud_machines_rows[i] = hud_machines_rows[i] .. '</th><td>' .. unitsProduced .. '</td><th class="' .. status_class .. '">' .. status .. '</th><th>' .. mode .. '</th><td class="' .. status_class .. '">' .. SecondsToClockString(element.remainingTime) .. '</td></tr>'
            else
                break
            end
        end
    end,
    function()
        hud_machines = [[<div class="hud_machines_container hud_container">
            <div style="text-align:center;font-weight:bold;border-bottom:1px solid white;">&#x2191; &nbsp;&nbsp; Arrow Up</div>
            <table class="elements_table" style="width:100%">
                <tr>
                    <th>&#x2190; &nbsp;&nbsp; Arrow Left</th>
                    <th> Page ]] .. page .. [[/]] .. maxPage .. [[ (from ]] .. minOnPage .. [[ to ]] .. maxOnPage .. [[ on ]] .. #selectedElementsId .. [[)</th>
                    <th>Arrow Right &nbsp;&nbsp; &#x2192;</th>
                </tr>
            </table>
            <table class="elements_table" style="width:100%;">
            <tr>
                <th>id</th>
                <th>Machine Name & Type</th>
                <th>Selected Recipe & schematic</th>
                <th>Cycles From Start</th>
                <th>Status</th>
                <th>Mode</th>
                <th>Time Remaining</th>
            </tr>
        ]]
        for i, row in pairs(hud_machines_rows) do
            if row ~= nil then
                hud_machines = hud_machines .. row
            end
        end
        hud_machines = hud_machines .. '</table><table class="elements_table" style="width:100%"><tr><th>&#x2190; &nbsp;&nbsp; Arrow Left</th><th> Page ' .. page .. '/' .. maxPage .. ' (from ' .. minOnPage .. ' to ' .. maxOnPage .. ' on ' .. #selectedElementsId .. ')</th><th>Arrow Right &nbsp;&nbsp; &#x2192;</th></tr></table><div style="text-align:center;font-weight:bold;border-top:1px solid white;">&#x2193; &nbsp;&nbsp; Arrow Down</div></div>'
        coroutine.yield(coroutinesTable[6])
    end,
    function()
        minOnPage = ((page - 1) * elementsByPage) + 1
        maxOnPage = page * elementsByPage
        if maxOnPage > #selectedElementsId then maxOnPage = #selectedElementsId end
        for i,id in pairs(selectedElementsId) do
            elementData = {}
            elementData.id = id
            elementData.name = core.getElementNameById(id)
            table.insert(temp_elements_for_sorting, elementData)
        end
        table.sort(temp_elements_for_sorting, function(a,b) return a.name:lower() < b.name:lower() end)
        for i = minOnPage, maxOnPage, 1 do
            if temp_elements_for_sorting[i] ~= nil then
                elementData = temp_elements_for_sorting[i]
                elementType = core.getElementDisplayNameById(elementData.id)
                elementData.type = elementType
                elementData.name = core.getElementNameById(elementData.id)
                elementData.position = core.getElementPositionById(elementData.id)
                table.insert(temp_refresh_id_list, elementData.id)
                table.insert(temp_elements, elementData)
            else
                temp_refresh_id_list = {}
                temp_elements_for_sorting = {}
                temp_elements = {}
                break
            end
            coroutine.yield(coroutinesTable[7])
        end
        refresh_id_list = temp_refresh_id_list
        temp_refresh_id_list = {}
        elements = temp_elements
        temp_elements_for_sorting = {}
        temp_elements = {}
    end,
    function()
        hud_main_css = [[
            <style>
        	   * {
        		  font-size: 1vh !important;
        		  font-familly: "Play-Bold";
        	   }
                .hud_container {
                    border: 1px solid black;
                    border-radius:10px;
                    background-color: rgba(15,24,29,.75);
                    padding:10px;
                }
                .hud_help_commands {
                    position: absolute;
                    top: ]] .. tostring((10/1080)*100) .. [[vh;
                    left: ]] .. tostring((25/1920)*100) .. [[vw;
                    text-transform: uppercase;
                    font-weight: bold;
                }
                .hud_list_container {
                    position: absolute;
                    top: ]] .. tostring((100/1080)*100) .. [[vh;
                    left: ]] .. tostring((25/1920)*100) .. [[vw;
                    text-transform: uppercase;
                    font-weight: bold;
                }
                .hud_machine_detail {
                    position: absolute;
                    top: ]] .. tostring((250/1080)*100) .. [[vh;
                    right: ]] .. tostring((25/1920)*100) .. [[vw;
                    text-transform: uppercase;
                    font-weight: bold;
                }
                .hud_machines_container {
                    position: absolute;
                    top: ]] .. tostring((100/1080)*100) .. [[vh;
                    left: ]] .. tostring((225/1920)*100) .. [[vw;
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
                .text-success{color:rgb(34,177,76);}
                .text-danger{color:rgb(177,42,42);}
                .text-warning{color:rgb(249,212,123);}
                .text-info{color:#17a2b8;}
                .text-primary{color:#007bff;}
                .text-orangered{color:orangered;}
                .bg-success{background-color:rgb(34,177,76) !important;}
                .bg-danger{background-color:rgb(177,42,42) !important;}
                .bg-warning{background-color:rgb(249,212,123) !important;}
                .bg-info{background-color:#17a2b8 !important;}
                .bg-primary{background-color:#007bff !important;}
                small{font-size:.5em;}
            </style>
        ]]
        if not init then
            hud_elements_type_list = [[
                <div class="hud_list_container hud_container">
                	<table style="width:100%">
                		<tr>
                			<th>LOADING ]] .. math.floor(initIndex*100/#elementsIdList) .. [[% ...</th>
                		</tr>
                	</table>
                </div>
            ]]
        end
        if hud_displayed then
            system.setScreen(hud_main_css .. hud_help_command .. hud_elements_type_list .. hud_machines .. controlHud .. arhtml)
        else
            system.setScreen(hud_main_css .. hud_help_command .. arhtml)
        end
    end,
    function()
        selected_machine = elements[selected_machine_index]
    end,
    function()
        if selected_machine then
            if prevRecipe == nil then prevRecipe=''end
            if prevStatus == nil then prevStatus=1 end
            if prevName == nil then prevName='' end
            if selected_machine.status then prevStatus = selected_machine.status end
            if selected_machine.recipeName then prevRecipe = selected_machine.recipeName end
            if selected_machine.name then prevName = selected_machine.name end
            local screenpos = library.getPointOnScreen(ConvertLocalToWorld(selected_machine.position, constructPos, constructRight, constructForward, constructUp))
            if screenpos[1] > 1 then screenpos[1] = 1 elseif screenpos[1] < 0 then screenpos[1] = 0 end
            if screenpos[2] > .95 then screenpos[2] = .95 elseif screenpos[2] < 0 then screenpos[2] = 0 end
            arhtml = [[<div style="text-align:center;position:absolute;left:]] .. utils.round(screenpos[1]*100) .. [[%;top:]] .. utils.round(screenpos[2]*100) .. [[%;;margin-left:-500px;width:1000px;"><div style="width:fit-content;padding:5px;margin:auto;border:2px solid black;border-radius:10px;background-color:rgba(15,24,29,.75);text-align:center;" class="]] .. getIndustryStatusBgClass(prevStatus) .. [[">]] .. prevName .. [[<br>]] .. prevRecipe .. [[<br><br><span style="font-weight:bold;">]] .. statusList[prevStatus] .. [[</span></div></div>]]
        end
    end,
    function()
        if enableRemoteControl then
            if selected_machine then
                if prevRecipe == nil then prevRecipe=''end
                if prevStatus == nil then prevStatus=99 end
                if prevMaintainProductAmount == nil then prevMaintainProductAmount = 0 end
                if prevBatchesRequested == nil then prevBatchesRequested = 0 end
                if selected_machine.status then prevStatus = selected_machine.status end
                if selected_machine.recipeName then prevRecipe = selected_machine.recipeName end
                if selected_machine.maintainProductAmount then prevMaintainProductAmount = selected_machine.maintainProductAmount end
                if selected_machine.batchesRequested then prevBatchesRequested = selected_machine.batchesRequested end
                controlHud = [[<div class="hud_machine_detail hud_container">
                    <table>
                        <tr>
                            <th colspan="3">]] .. selected_machine.name .. [[</th>
                        </tr>
                        <tr>
                            <th class="]] .. getIndustryStatusClass(prevStatus) .. [[" colspan="3">]] .. statusList[prevStatus] .. [[</th>
                        </tr>
                    ]]
                if prevStatus == 1 then
                    command_1 = "START"
                    command_2 = "BATCH"
                    command_3 = "MAINTAIN"
                    controlHud = controlHud .. [[
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
                        if prevMaintainProductAmount > 0 then
                            value = tostring(math.floor(prevMaintainProductAmount))
                        elseif prevBatchesRequested > 0 and prevBatchesRequested <= 99999999 then
                            value = tostring(math.floor(prevBatchesRequested))
                        end
                        for i = #value, 1, -1 do
                            local c = value:sub(i,i)
                            craft_quantity_digits[9-(#value-(i-1))] = c
                        end
                    end
                    for digit_index,digit in pairs(craft_quantity_digits) do
                        controlHud = controlHud .. digit
                    end
                    controlHud = controlHud .. [[
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
                    controlHud = controlHud .. [[
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
                controlHud = controlHud .. '</table></div>'
            end
        end
    end
}

function initCoroutines()
    for _,f in pairs(MyCoroutines) do
        local co = coroutine.create(f)
        table.insert(coroutinesTable, co)
    end
end

initCoroutines()

runCoroutines = function()
    for i,co in ipairs(coroutinesTable) do
        if coroutine.status(co) == "dead" then
            coroutinesTable[i] = coroutine.create(MyCoroutines[i])
        end
        if coroutine.status(co) == "suspended" then
            assert(coroutine.resume(co))
        end
    end
end

MainCoroutine = coroutine.create(runCoroutines)

--Enable Display of the HUD
system.showScreen(1)
