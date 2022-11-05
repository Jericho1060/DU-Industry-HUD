version = "v4.1.2"
--[[
    DU Industry HUD By Jericho
]]
local log_split = "================================================="
--printing version in lua chat
system.print(log_split)local a=""local b=math.ceil((50-#version-2)/2)for c=1,b,1 do a=a..'='end;a=a.." "..version.." "for c=1,b,1 do a=a..'='end;system.print(a)system.print(log_split)
--[[
    Lua parameters
]]
fontSize = 12 --export: the fonct size
showRecipeData = true --export: display the recipe ingredients in the machine detail

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
maxAmountOfElementsLoadedByFrame = 500 --export: if cpu load errors at start, lower that value
machinesRefreshedByFrame = 100 --how many machines are refreshed by frame
machineDetailDisplayDistance = 0 --export: the distance in meters to display the machine details
displayType = 0 --export: the default display type: 0=ALL, 1=Table, 2=Augmented Reality
displayMode = 0 --export: the default display type: 0=ALL, 1=Industry Only, 2=Storage Only, 3=None
sortingType = 1 --export: the default sorting of elements in table: 1=Element Name, 2=Item in containers or product of industries, 3=Element ID


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

--Storage options
containerProficiencyLvl = 5 --export: Talent level for Container Proficiency
containerOptimizationLvl = 0 --export: Talent level for Container Optimization
storages_prefix_list = 's1,s2,s3,s4,s5,s6,s7,s8,s9' --export: the list of the prefixes used for the storage monitoring, comma separated values

--split a string on a delimiter By jericho
function strSplit(a,b)result={}for c in(a..b):gmatch("(.-)"..b)do table.insert(result,c)end;return result end
--formatting numbers by adding a space between thousands by Jericho
function format_number(a)local b=a;while true do b,k=string.gsub(b,"^(-?%d+)(%d%d%d)",'%1 %2')if k==0 then break end end;return b end
--Utility functions By jericho, see full source at https://github.com/Jericho1060/DualUniverse
function removeDuplicatesInTable(a)local b={}local c={}for d,e in ipairs(a)do if not b[e]then c[#c+1]=e;b[e]=true end end;return c end;function strSplit(a,b)result={}for c in(a..b):gmatch("(.-)"..b)do table.insert(result,c)end;return result end;function SecondsToClockString(a)local a=tonumber(a)if a==nil or a<=0 then return"-"else days=string.format("%2.f",math.floor(a/(3600*24)))hours=string.format("%2.f",math.floor(a/3600-days*24))mins=string.format("%2.f",math.floor(a/60-hours*60-days*24*60))secs=string.format("%2.f",math.floor(a-hours*3600-days*24*60*60-mins*60))str=""if tonumber(days)>0 then str=str..days.."d "end;if tonumber(hours)>0 then str=str..hours.."h "end;if tonumber(mins)>0 then str=str..mins.."m "end;if tonumber(secs)>0 then str=str..secs.."s"end;return str end end;function removeQualityInName(a)if not a then return''end;return a:lower():gsub('basic ',''):gsub('uncommon ',''):gsub('advanced ',''):gsub('rare ',''):gsub('exotic ','')end;function has_value(a,b)for c,d in ipairs(a)do if d==b then return true end end;return false end
--return RGB colors calculated from a gradient between two colors
function getRGBGradient(a,b,c,d,e,f,g,h,i,j)a=-1*math.cos(a*math.pi)/2+0.5;local k=0;local l=0;local m=0;if a>=.5 then a=(a-0.5)*2;k=e-a*(e-h)l=f-a*(f-i)m=g-a*(g-j)else a=a*2;k=b-a*(b-e)l=c-a*(c-f)m=d-a*(d-g)end;return k,l,m end
--time script to get client date and time by Jericho, see full source at https://github.com/Jericho1060/DualUniverse
function DUCurrentDateTime(a)local b=system.getUtcTime()if not a then b=b+system.getUtcOffset()end;local c=24*60*60;local d=365*c;local e=d+c;local f=4*d+c;local g=4;local h=1970;local i={-1,30,58,89,119,150,180,211,242,272,303,333,364}local j={}for k=1,2 do j[k]=i[k]end;for k=3,13 do j[k]=i[k]+1 end;local l,m,n,o,p,q,r,s;local t=i;s=b;l=math.floor(s/f)s=s-l*f;l=l*4+h;if s>=d then l=l+1;s=s-d;if s>=d then l=l+1;s=s-d;if s>=e then l=l+1;s=s-e else t=j end end end;m=math.floor(s/c)s=s-m*c;local n=1;while t[n]<m do n=n+1 end;n=n-1;local o=m-t[n]p=(math.floor(b/c)+g)%7;if p==0 then p=7 end;q=math.floor(s/3600)s=s-q*3600;r=math.floor(s/60)function round(u,v)if v then return utils.round(u/v)*v end;return u>=0 and math.floor(u+0.5)or math.ceil(u-0.5)end;s=round(s-r*60)local w={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"}local x={"Mon","Tue","Wed","Thu","Fri","Sat","Sun"}local y={"January","February","March","April","May","June","July","August","September","October","November","December"}local z={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}return l,n,o,q,r,s,p,w[p],x[p],y[n],z[n],m+1 end

--databank hub library By Jericho, see full source at https://github.com/Jericho1060/DualUniverse
bankhub={}function bankhub:new(banks)o={}setmetatable(o,self)self.__index=self;o.banks=banks or{}function o.clear()return o:_clear()end;function o.getNbKeys()return o:_getNbKeys()end;function o.getKeys()return o:_getKeys()end;function o.hasKey(a)return o:_hasKey(a)end;function o.getStringValue(a)return o:_getStringValue(a)end;function o.getIntValue(a)return o:_getIntValue(a)end;function o.getFloatValue(a)return o:_getFloatValue(a)end;return o end;function bankhub:add(b)table.insert(self.banks,b)self.banks_size=#self.banks end;function bankhub:_clear()for c,d in pairs(self.banks)do d.clear()end end;function bankhub:_getNbKeys()local e=0;for c,d in pairs(self.banks)do e=e+d.getNbKeys()end;return e end;function bankhub:_getKeys()local e={}for c,d in pairs(self.banks)do local f=json.decode(d.getKeys())for c,g in pairs(f)do table.insert(e,g)end end;return json.encode(e)end;function bankhub:_hasKey(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return 1 end end;return 0 end;function bankhub:_getStringValue(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return d.getStringValue(a)end end;return nil end;function bankhub:_getIntValue(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return banks.getIntValue(a)end end;return nil end;function bankhub:_getFloatValue(a)for c,d in pairs(self.banks)do if d.hasKey(a)==1 then return banks.getFloatValue(a)end end;return nil end
--time script to get client date and time by Jericho, see full source at https://github.com/Jericho1060/DualUniverse
function DUCurrentDateTime(a)local b=system.getUtcTime()if not a then b=b+system.getUtcOffset()end;local c=24*60*60;local d=365*c;local e=d+c;local f=4*d+c;local g=4;local h=1970;local i={-1,30,58,89,119,150,180,211,242,272,303,333,364}local j={}for k=1,2 do j[k]=i[k]end;for k=3,13 do j[k]=i[k]+1 end;local l,m,n,o,p,q,r,s;local t=i;s=b;l=math.floor(s/f)s=s-l*f;l=l*4+h;if s>=d then l=l+1;s=s-d;if s>=d then l=l+1;s=s-d;if s>=e then l=l+1;s=s-e else t=j end end end;m=math.floor(s/c)s=s-m*c;local n=1;while t[n]<m do n=n+1 end;n=n-1;local o=m-t[n]p=(math.floor(b/c)+g)%7;if p==0 then p=7 end;q=math.floor(s/3600)s=s-q*3600;r=math.floor(s/60)function round(u,v)if v then return utils.round(u/v)*v end;return u>=0 and math.floor(u+0.5)or math.ceil(u-0.5)end;s=round(s-r*60)local w={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"}local x={"Mon","Tue","Wed","Thu","Fri","Sat","Sun"}local y={"January","February","March","April","May","June","July","August","September","October","November","December"}local z={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}return l,n,o,q,r,s,p,w[p],x[p],y[n],z[n],m+1 end

statusList = {"STOPPED","RUNNING","MISSING INGREDIENT","OUTPUT FULL","NO OUTPUT CONTAINER","PENDING","MISSING SCHEMATIC","SERVER ERROR", "STOP REQUESTED"}
function getIndustryStatusClass(status)
    if status == 1 then
        return "text-info"
    elseif status == 2 then
        return "text-success"
    elseif ((status >= 3) and (status <= 5)) or (status == 7) then
        return "text-danger"
    elseif status == 6 then
        return "text-primary"
    elseif status >= 8 and status <= 9 then
        return "text-warning"
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
        elseif status >= 8 and status <= 9 then
            return "bg-warning"
        end
    end
    return "" --default value for other status that can be added
end
function getIndustryStatusBorderClass(status)
    if status then
        if status == 1 then
            return "border-info"
        elseif status == 2 then
            return "border-success"
        elseif ((status >= 3) and (status <= 5)) or (status == 7) then
            return "border-danger"
        elseif status == 6 then
            return "border-primary"
        elseif status >= 8 and status <= 9 then
            return "border-warning"
        end
    end
    return "" --default value for other status that can be added
end
function ConvertLocalToWorld(a,b,c,d,e)local f={a[1]*c[1],a[1]*c[2],a[1]*c[3]}local g={a[2]*d[1],a[2]*d[2],a[2]*d[3]}local h={a[3]*e[1],a[3]*e[2],a[3]*e[3]}return{f[1]+g[1]+h[1]+b[1],f[2]+g[2]+h[2]+b[2],f[3]+g[3]+h[3]+b[3]}end


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

bootstrap_css_colors = [[<style>.text-white {color: #fff !important;}.text-primary {color: #007bff !important;}.text-secondary {color: #6c757d !important;}.text-success {color: #28a745 !important;}.text-info {color: #17a2b8 !important;}.text-warning {color: #ffc107 !important;}.text-danger {color: #dc3545 !important;}.text-light {color: #f8f9fa !important;}.text-dark {color: #343a40 !important;}.text-body {color: #212529 !important;}.text-muted {color: #6c757d !important;}.text-black-50 {color: rgba(0, 0, 0, 0.5) !important;}.text-white-50 {color: rgba(255, 255, 255, 0.5) !important;}.bg-primary {background-color: #007bff !important;}.bg-secondary {background-color: #6c757d !important;}.bg-success {background-color: #28a745 !important;}.bg-info {background-color: #17a2b8 !important;}.bg-warning {background-color: #ffc107 !important;}.bg-danger {background-color: #dc3545 !important;}.bg-light {background-color: #f8f9fa !important;}.bg-dark {background-color: #343a40 !important;}.bg-white {background-color: #fff !important;}.bg-transparent {background-color: transparent !important;}.border-primary {border-color: #007bff !important;}.border-secondary {border-color: #6c757d !important;}.border-success {border-color: #28a745 !important;}.border-info {border-color: #17a2b8 !important;}.border-warning {border-color: #ffc107 !important;}.border-danger {border-color: #dc3545 !important;}.border-light {border-color: #f8f9fa !important;}.border-dark {border-color: #343a40 !important;}.border-white {border-color: #fff !important;}
</style>]]
base_css = [[<style>.ib{position:absolute;opacity:.75;transform: translate(-50%, -50%);}.tier0{font-weight:bold;padding:5px;margin-right:5px;color:black;background-color:#fff;}.tier1{font-weight:bold;padding:5px;margin-right:5px;color:black;background-color:#fff;}.tier2{font-weight:bold;padding:5px;margin-right:5px;color:white;background-color:green;}.tier3{font-weight:bold;padding:5px;margin-right:5px;color:white;background-color:blue;}.tier4{font-weight:bold;padding:5px;margin-right:5px;color:white;background-color:purple;}.tier5{font-weight:bold;padding:5px;margin-right:5px;color:white;background-color:orange;}hr{border-top:1px solid #343a40;border-collapse:collapse;}.hr-light{border-top:1px solid #f8f9fa;}.hud_container{z-index:1000;font-size:]] .. fontSize .. [[px;border: 1px solid black;border-radius:5px;background-color: rgba(15,24,29,.85);padding:10px;}.hud_time{position: absolute;bottom: ]] .. tostring((100/1080)*100) .. [[vh;right: ]] .. tostring((10/1920)*100) .. [[vw;text-transform: uppercase;font-weight: bold;}.hud_machine_types_container{position: absolute;top: ]] .. tostring((80/1080)*100) .. [[vh;left: ]] .. tostring((10/1920)*100) .. [[vw;text-transform: uppercase;font-weight: bold;}.hud_machine_status_container{position: absolute;top: ]] .. tostring((10/1080)*100) .. [[vh;left: ]] .. tostring((10/1920)*100) .. [[vw;text-transform: uppercase;font-weight: bold;}.hud_table_container{position: absolute;top:]] .. tostring((80/1080)*100) .. [[vh;left:]] .. tostring((225/1920)*100) .. [[vw;}.hud_table_container td,.hud_table_container th, .hud_machine_control th{border-bottom:1px solid #f8f9fa;}small{font-size:.75em;}.hud_table_container td.row_selected,.hud_table_container th.row_selected{border:2px solid green;}.hud_machine_control{position: absolute;top: ]] .. tostring((300/1080)*100) .. [[vh;right: ]] .. tostring((10/1920)*100) .. [[vw;text-transform: uppercase;font-weight: bold;}</style>]]


databanks = {}
core = nil
emitter = nil
industries_id = {}
storages_id = {}
industries = {}
storages = {}
elementsTypes = {}
storagesTypes = {}
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

--construct pos for AR data
constructPos = construct.getWorldPosition()
constructRight = construct.getWorldRight()
constructForward = construct.getWorldForward()
constructUp = construct.getWorldUp()

--script variables
storage_prefix = strSplit(storages_prefix_list, ',')
displayTypes = {"ALL", "Table", "Augmented Reality"}
displayModes = {"ALL", "Industry", "Storage", "None"}
sortingTypes = {"Element Name", "Item", "Element ID"}
init = false
initIndex = 1
elementsIdList = {}
machines_count = {}
storages_count = {}
machines_positions = {}
storages_positions = {}
system.showScreen(true)
statusFilter = 0
statusFilterType = 0
maxFilterType = 0
maxOnPage=1
html_filters = ""
html_filters_types = ""
html_filter_storage = ""
html_machines = ""
html_storage = ""
html_time = ""
html_ar_selected = ""
html_control = ""
html_credits = [[<div class="hud_container" style="position:absolute;left:5px;bottom:5px;font-size:10px;padding:5px;">]] .. version .. [[ - Powered By jericho1060</div>]]

--pagination var
page = 1
maxPage = 1
selectedRow = 1
selected_machine=nil
selected_container=nil

--control machine var
command_1 = ""
command_2 = ""
command_3 = ""
craft_quantity_digits = {"0","0","0","0","0","0","0","0"}

--keyPressed
ctrlPressed = false


--[[
    DU INDUSTRY HUD By Jericho
]]
hud = {}
hud.coroutines = {}
hud.coroutines.init = function()
    if not init then
        elementsTypes = {}
        industries_id = {}
        industries = {}

        storagesTypes = {}
        storages_id = {}
        storages = {}

        elementsIdList = core.getElementIdList()

        for index,id in ipairs(elementsIdList) do
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
                (elementType == "transfer unit" and enableTransferMonitoring == true) or
                elementType:lower():find("container")
                then
                local formatedType = removeQualityInName(elementType)
                local pos = core.getElementPositionById(id)
                if elementType:lower():find("container") then
                    if storages_count[formatedType] ~= nil then
                        storages_count[formatedType] = storages_count[formatedType] + 1
                    else
                        storages_count[formatedType] = 1
                    end
                    table.insert(storages_id, id)
                    storages_positions['i'..id] = pos
                    table.insert(storagesTypes, formatedType)
                else
                    pos[3] = pos[3] + 1
                    if machines_count[formatedType] ~= nil then
                        machines_count[formatedType] = machines_count[formatedType] + 1
                    else
                        machines_count[formatedType] = 1
                    end
                    table.insert(industries_id, id)
                    machines_positions['i'..id] = pos
                    table.insert(elementsTypes, formatedType)
                end
            end

            if index % maxAmountOfElementsLoadedByFrame == 0 then
                coroutine.yield(self.init)
            end
        end
        elementsTypes = removeDuplicatesInTable(elementsTypes)
        table.sort(elementsTypes, function(a,b) return a:lower() < b:lower() end)
        selected_type = elementsTypes[1]
        init = true
        system.print("All elements loaded")
        system.print(#storages_id .. " storage elements found")
        system.print(#industries_id .. " industries found")
    end
end
hud.coroutines.loadIndustries = function()
    if init and (displayMode == 0 or displayMode == 1) then
        for index,id in ipairs(industries_id) do
            local pos = machines_positions['i'..id]
            local data = core.getElementIndustryInfoById(id)
            if industries["i"..tostring(id)] == nil then industries["i"..tostring(id)] = {} end
            local mode = ""
            local tableMode = ""
            local maintainOrBatchQuantity = 0
            if data.maintainProductAmount > 0 then
                mode = "<div><strong>Mode:</strong> Maintain " .. math.floor(data.currentProductAmount) .."/" .. math.floor(data.maintainProductAmount) .. "</div>"
                tableMode = "Maintain " .. math.floor(data.currentProductAmount) .."/" .. math.floor(data.maintainProductAmount)
                maintainOrBatchQuantity=math.floor(data.maintainProductAmount)
            elseif data.batchesRequested > 0 and data.batchesRequested <= 99999999 then
                local current = data.batchesRequested - data.batchesRemaining
                if data.batchesRemaining < 0 then current = 0 end
                mode = "<div><strong>Mode:</strong> Produce " .. math.floor(current) .. "/" .. math.floor(data.batchesRequested) .. "</div>"
                tableMode = "Produce " .. math.floor(current) .. "/" .. math.floor(data.batchesRequested)
                maintainOrBatchQuantity=math.floor(data.batchesRequested)
            end
            local production = {locDisplayNameWithSize="No recipe selected", tier=0}
            local schematicName = ""
            local tableSchematicName = ""
            local state = data.state
            local time=""
            local tableTime=""
            local recipe=""
            local industryType = core.getElementDisplayNameById(id)
            if #data.currentProducts > 0 then
                local item_id = data.currentProducts[1].id
                production = system.getItem(item_id)
                if id ~= "947806142" and id ~= "1010524904" and not industryType:lower():find("transfer") then
                    if showRecipeData then
                        local rdata = system.getRecipes(item_id)
                        if #rdata > 0 then
                            local r = nil
                            for _,recipe in pairs(rdata) do
                                if recipe.products[1].id == item_id then
                                    r = recipe
                                    break
                                end
                            end
                            if r then
                                recipe = "<div><strong>Recipe:</strong>"
                                for _,v in pairs(r.ingredients) do
                                    local item = system.getItem(v.id)
                                    recipe = recipe .. "<br>&nbsp;&nbsp;&nbsp;&nbsp;- " .. v.quantity .. " x " .. item.locDisplayNameWithSize
                                end
                                recipe = recipe .. "</div>"
                            end
                        end
                    end
                    local schematicId = production.schematics[1] or 0
                    if schematicId > 0 then
                        local sch = system.getItem(schematicId)
                        schematicName = "<div><strong>Schematic:</strong> " .. data.schematicsRemaining .. " " .. sch.locDisplayNameWithSize .. "</div>"
                        tableSchematicName = sch.locDisplayNameWithSize
                    end
                end
                if data.remainingTime == 0 and data.state == 2 then
                    state = 8
                end
                if data.stopRequested and data.state ~= 1 then
                    state = 9
                end
                if data.remainingTime > 0 then
                    time = "<div><strong>Time:</strong> " .. SecondsToClockString(data.remainingTime) .. "</div>"
                    tableTime = SecondsToClockString(data.remainingTime)
                end
            end
            local productionName = '<div><strong>Product</strong>: ' .. production.locDisplayNameWithSize .. '</div>'
            local productId = ''
            if production.id then
                productId = "<div><strong>Main Product ID:</strong> " .. production.id .. "</div>"
            end
            local elementName = core.getElementNameById(id)
            industries["i"..tostring(id)] = {
                id=id,
                screenPos=library.getPointOnScreen(ConvertLocalToWorld(pos, constructPos, constructRight, constructForward, constructUp)),
                name="<div><strong>Industry Name:</strong> [" .. id .. "] " .. elementName .. "</div>",
                tableName=elementName,
                type="<div><strong>Industry Type:</strong> " .. industryType .. "</div>",
                tableType=industryType,
                typeFilter=removeQualityInName(industryType),
                state=state,
                production=production,
                productId=productId,
                productionName=productionName,
                mode=mode,
                tableMode=tableMode,
                remainingTime=time,
                tableTime=tableTime,
                schematic=schematicName,
                maintainOrBatchQuantity=maintainOrBatchQuantity,
                tableSchematic=tableSchematicName,
                recipe=recipe,
                stopRequested=data.stopRequested
            }
            if index % machinesRefreshedByFrame == 0 then
                coroutine.yield(self.loadIndustries)
            end
        end
    end
end
hud.coroutines.loadStorage = function()
    for index,id in ipairs(storages_id) do
        local pos = storages_positions['i'..id]
        local elementType = core.getElementDisplayNameById(id)
        local base_name = core.getElementNameById(id)
        local splitted = strSplit(base_name,'_')
        local item_id = nil
        local prefix = nil
        if #splitted > 1 then
            prefix = splitted[1]
            item_id = splitted[2]
        end
        local container = {
            id = id,
            type=elementType,
            name = "[" .. id .. "] " .. base_name,
            tableName = base_name,
            prefix = prefix,
            item_id = item_id,
            monitor = false,
            screenPos=library.getPointOnScreen(ConvertLocalToWorld(pos, constructPos, constructRight, constructForward, constructUp)),
        }
        if item_id and prefix then
            for _,sprefix in ipairs(storage_prefix) do
                if prefix:lower() == sprefix:lower() then
                    container.monitor = true
                    container.item = system.getItem(item_id)
                    break
                end
            end
        end
        local container_size = "XS"
        local container_empty_mass = 0
        local container_volume = 0
        local contentQuantity = 0
        local percent_fill = 0
        if not elementType:lower():find("hub") then
            local containerMaxHP = core.getElementMaxHitPointsById(id)
            if containerMaxHP > 68000 then
                container_size = "XXL"
                container_empty_mass = 88410
                container_volume = 512000 * (containerProficiencyLvl * 0.1) + 512000
            elseif containerMaxHP > 33000 then
                container_size = "XL"
                container_empty_mass = 44210
                container_volume = 256000 * (containerProficiencyLvl * 0.1) + 256000
            elseif containerMaxHP > 17000 then
                container_size = "L"
                container_empty_mass = 14842.7
                container_volume = 128000 * (containerProficiencyLvl * 0.1) + 128000
            elseif containerMaxHP > 7900 then
                container_size = "M"
                container_empty_mass = 7421.35
                container_volume = 64000 * (containerProficiencyLvl * 0.1) + 64000
            elseif containerMaxHP > 900 then
                container_size = "S"
                container_empty_mass = 1281.31
                container_volume = 8000 * (containerProficiencyLvl * 0.1) + 8000
            else
                container_size = "XS"
                container_empty_mass = 229.09
                container_volume = 1000 * (containerProficiencyLvl * 0.1) + 1000
            end
        else
            if splitted[3] then
                container_size = splitted[3]
            end
            if splitted[4] then
                container_amount = splitted[4]
            end
            local volume = 0
            container_volume_list = {xxl=512000, xl=256000, l=128000, m=64000, s=8000, xs=1000}
            container_size = container_size:lower()
            if container_volume_list[container_size] then
                volume = container_volume_list[container_size]
            end
            container_volume = (volume * containerProficiencyLvl * 0.1 + volume)
            container_empty_mass = 55.8
        end
        local totalMass = core.getElementMassById(id)
        local contentMassKg = totalMass - container_empty_mass
        container.totalMass = totalMass
        container.emptyMass = container_empty_mass
        container.contentMass = contentMassKg
        container.maxVolume = container_volume
        container.size = container_size
        if container.item == nil or container.item.name == "InvalidItem" then
            container.percent = 0
            container.quantity = 0
        else
            container.quantity = contentMassKg / (container.item.unitMass - (container.item.unitMass * (containerOptimizationLvl * 0.05)))
            container.percent = utils.round((container.item.unitVolume * container.quantity) * 100 / container_volume)
        end
        storages['i'..id] = container
        if index % machinesRefreshedByFrame == 0 then
            coroutine.yield(self.loadStorage)
        end
    end
end
hud.coroutines.renderHelper = function()
    local year, month, day, hour, minute, second = DUCurrentDateTime()
    html_time = [[<div class="hud_time hud_container"><div style="text-align:center;">]] .. string.format("%02d/%02d/%04d %02d:%02d:%02d",day,month,year,hour,minute,second) .. [[</div><div style="text-align:right;"><hr class="hr-light"><style>.dm]] .. displayMode .. [[{border: 1px solid #28a745 !important;}.dp]] .. displayType .. [[{border: 1px solid #28a745 !important;}.sortType]] .. sortingType .. [[{border: 1px solid #28a745 !important;}</style><div>]]
    for i,v in ipairs(sortingTypes) do
        html_time = html_time .. '<span class="sortType' .. i ..'" style="margin:5px;">' .. v .. '</span>'
        if i < #sortingTypes then html_time = html_time .. "|" end
    end
    html_time = html_time .. ' - Sorting Type - Alt + 6</div><div>'
    for i,v in ipairs(displayTypes) do
        html_time = html_time .. '<span class="dp' .. (i-1) .. '" style="margin:5px;">' .. v .. '</span>'
        if i < #displayTypes then html_time = html_time .. "|" end
    end
    html_time = html_time .. ' - Display Type - Alt + 7</div><div>'
    for i,v in ipairs(displayModes) do
        html_time = html_time .. '<span class="dm' .. (i-1) .. '" style="margin:5px;">' .. v .. '</span>'
        if i < #displayModes then html_time = html_time .. "|" end
    end
    html_time = html_time .. ' - Display Mode - Alt + 8</div>'
    html_time = html_time .. '<div>Reload HUD - Alt + 9</div>'
    html_time = html_time .. '</div></div>'
end
hud.coroutines.renderIndustries = function()
    local html = ""
    local html_table = ""
    local lastMachine = 0
    local firstMachine = 0
    local totalPage = 1
    local selectedMachine = nil
    if displayMode == 0 or displayMode == 1 then
        local selectedIndustries = {}
        for k,industry in pairs(industries) do
            if (statusFilter == 0 or industry.state == statusFilter) and (statusFilterType == 0 or (statusFilterType <= #elementsTypes and industry.typeFilter:lower() == elementsTypes[statusFilterType])) then
                if displayType == 0 then
                    table.insert(selectedIndustries, industry)
                elseif displayType == 1 then
                    table.insert(selectedIndustries, industry)
                elseif displayType == 2 then
                    if industry.screenPos[1] > 0 and industry.screenPos[1] < 1 and industry.screenPos[2] > 0 and industry.screenPos[2] < 1 then
                        table.insert(selectedIndustries, industry)
                    end
                end
            end
        end
        if (displayType == 0 or displayType == 1) and statusFilterType <= #elementsTypes then
            totalPage = math.ceil(#selectedIndustries/elementsByPage)
            firstMachine = (page - 1) * elementsByPage + 1
            lastMachine = page * elementsByPage
            if lastMachine > #selectedIndustries then
                lastMachine = #selectedIndustries
            end
            html_table = html_table .. '<div class="hud_container hud_table_container"><div style="text-align:center;border-bottom:1px solid white;">&#x2191; &nbsp;&nbsp; Arrow Up</div><table style="width:100%"><tr><th>&#x2190; &nbsp;&nbsp; Arrow Left</th><th> Page ' .. page .. '/' .. totalPage .. ' (from ' .. firstMachine .. ' to ' .. lastMachine .. ' on ' .. #selectedIndustries .. ')</th><th>Arrow Right &nbsp;&nbsp; &#x2192;</th></tr></table><table><tr><th>id</th><th>Machine Name & Type</th><th>Selected Recipe & schematic</th><th>Status</th><th>Mode</th><th>Time Remaining</th></tr>'
        end
        local count = 1
        if sortingType == 1 then
            table.sort(selectedIndustries, function(a,b) return a.tableName < b.tableName end)
        elseif sortingType == 2 then
            table.sort(selectedIndustries, function(a,b) return a.production.locDisplayNameWithSize < b.production.locDisplayNameWithSize end)
        elseif sortingType == 3 then
            table.sort(selectedIndustries, function(a,b) return a.id < b.id end)
        end
        for k,industry in pairs(selectedIndustries) do
            if (displayType == 0 or displayType == 2) and industry.screenPos[1] > 0 and industry.screenPos[1] < 1 and industry.screenPos[2] > 0 and industry.screenPos[2] < 1 then
                local showDetail = false
                if industry.screenPos[3] <= machineDetailDisplayDistance then
                    showDetail = true
                elseif industry.screenPos[1] < 0.55 and industry.screenPos[1] > 0.45 and industry.screenPos[2] < 0.55 and industry.screenPos[2] > 0.45 then
                    showDetail = true
                end
                local font_size = fontSize * ((200-industry.screenPos[3])/200)
                local zindex = utils.round(1000 - industry.screenPos[3])
                html = html .. [[<div class="ib" style="left:]] .. utils.round(industry.screenPos[1]*100) .. [[%;top:]] .. utils.round(industry.screenPos[2]*100) .. [[%;font-size:]] .. font_size .. [[px;z-index:]]..zindex..[[;"><div class="]] .. getIndustryStatusBgClass(industry.state) .. [[" style="padding:2px;text-transform:capitalize;"><span class="tier]] .. industry.production.tier .. [[">T]] .. industry.production.tier .. [[</span><strong>]] .. industry.production.locDisplayNameWithSize .. [[</strong></div>]]
                if showDetail then
                    html = html .. [[<div class="bg-light text-dark" style="margin-top:2px;padding:2px;"><div class="]] .. getIndustryStatusClass(industry.state) .. [["><strong>]] .. statusList[industry.state] .. [[</strong></div><div>]] .. industry.productId .. industry.name .. industry.type .. industry.mode .. industry.schematic .. industry.remainingTime .. industry.recipe ..[[</div></div>]]
                end
                html = html .. [[</div>]]
            end
            if (displayType == 0 or displayType == 1) then
                local selectedClass = ""
                if selectedRow == (count + 1 - firstMachine)then
                    selectedClass = "row_selected"
                    selectedMachine = industry
                end
                if count >= firstMachine and count <= lastMachine then
                    html_table = html_table .. '<tr><th class="' .. selectedClass .. '">' .. industry.id .. '</th><th class="' .. selectedClass .. '"><span class="' .. getIndustryStatusClass(industry.state) .. '">' .. industry.tableName .. '</span><br><small>' .. industry.tableType .. '</small></th><th class="' .. selectedClass .. '">' .. industry.production.locDisplayNameWithSize .. '<br><small>' .. industry.tableSchematic .. '</small></th><th class="' .. selectedClass .. '"><span class="' .. getIndustryStatusClass(industry.state) .. '">' .. statusList[industry.state] .. '</span></th><th class="' .. selectedClass .. '">' .. industry.tableMode .. '</th><th class="' .. selectedClass .. '">' .. industry.tableTime .. '</th></tr>'
                end
            end
            count = count + 1
        end
        if (displayType == 0 or displayType == 1) and statusFilterType <= #elementsTypes then
            html_table = html_table .. '</table><table style="width:100%"><tr><th>&#x2190; &nbsp;&nbsp; Arrow Left</th><th> Page ' .. page .. '/' .. totalPage .. ' (from ' .. firstMachine .. ' to ' .. lastMachine .. ' on ' .. #selectedIndustries .. ')</th><th>Arrow Right &nbsp;&nbsp; &#x2192;</th></tr></table><div style="text-align:center;border-bottom:1px solid white;">&#x2193; &nbsp;&nbsp; Arrow Down</div></div>'
            maxPage = totalPage
            maxOnPage = lastMachine-firstMachine+1
        end
    end
    html_machines = html .. html_table
    selected_machine = selectedMachine
end
hud.coroutines.renderStorage = function()
    local html = ""
    local html_table = ""
    local lastStorage = 0
    local firstStorage = 0
    local totalPage = 1
    local selectedStorage = nil
    if displayMode == 0 or displayMode == 2 then
        local selectedStorages = {}
        for k,storage in pairs(storages) do
            if statusFilterType >= maxFilterType and storage.monitor then
                if displayType == 0 then
                    table.insert(selectedStorages, storage)
                elseif displayType == 1 then
                    table.insert(selectedStorages, storage)
                end
            end
        end
        if (displayType == 0 or displayType == 2) then
            for k,storage in pairs(storages) do
                if storage.screenPos[1] > 0 and storage.screenPos[1] < 1 and storage.screenPos[2] > 0 and storage.screenPos[2] < 1 then
                    local showDetail = false
                    if storage.screenPos[3] <= machineDetailDisplayDistance then
                        showDetail = true
                    elseif storage.screenPos[1] < 0.55 and storage.screenPos[1] > 0.45 and storage.screenPos[2] < 0.55 and storage.screenPos[2] > 0.45 then
                        showDetail = true
                    end
                    local font_size = fontSize * ((200-storage.screenPos[3])/200)
                    local zindex = utils.round(1000 - storage.screenPos[3])
                    local displayName = storage.name
                    local tierBox = ''
                    local itemBox = ''
                    local fillGauge = ''
                    if storage.item ~= nil and storage.item.name ~= "InvalidItem" then
                        displayName = format_number(utils.round(storage.quantity*100)/100) .. " " .. storage.item.locDisplayNameWithSize .. " (" .. storage.percent .. "%)"
                        tierBox = '<span class="tier' .. storage.item.tier .. '">T' .. storage.item.tier .. '</span>'
                        local i = storage.item
                        local gaugePercent = storage.percent
                        if storage.percent > 100 then
                            gaugePercent = 100
                        end
                        local r,g,b = getRGBGradient(gaugePercent/100,177,42,42,249,212,123,34,177,76)
                        r = utils.round(r)
                        g = utils.round(g)
                        b = utils.round(b)
                        itemBox = [[<hr><div><strong>Item ID:</strong> ]] .. i.id .. [[</div><div><strong>Item Name:</strong> ]] .. i.locDisplayNameWithSize .. [[</div><div><strong>Item Unit Mass:</strong> ]] .. i.unitMass .. [[ kg</div><div><strong>Item Unit Volume:</strong> ]] .. i.unitVolume .. [[ m<sup>3</sup></div>]]
                        fillGauge = '<div style="position:absolute;bottom:0;left:0px;width:' .. gaugePercent .. '%;background-color:rgb(' .. r .. ',' .. g ..',' .. b .. ');height:3px;z-index:' .. (zindex+1) .. ';"></div>'
                    end
                    html = html .. [[<div class="ib" style="left:]] .. utils.round(storage.screenPos[1]*100) .. [[%;top:]] .. utils.round(storage.screenPos[2]*100) .. [[%;font-size:]] .. font_size .. [[px;z-index:]]..zindex..[[;"><div class="bg-light text-dark" style="padding:2px;padding-bottom:5px;text-transform:capitalize;position:relative;">]] .. tierBox .. [[<strong>]] .. displayName .. [[</strong>]] .. fillGauge .. [[</div>]]
                    if showDetail then
                        html = html .. [[<div class="bg-light text-dark" style="margin-top:2px;padding:2px;"><div><strong>Container Type:</strong> ]] .. storage.type .. " " .. storage.size .. [[</div>]] .. itemBox .. [[</div></div>]]
                    end
                    html = html .. [[</div>]]
                end
            end
        end
        if (displayType == 0 or displayType == 1) and statusFilterType >= maxFilterType then
            totalPage = math.ceil(#selectedStorages/elementsByPage)
            firstStorage = (page - 1) * elementsByPage + 1
            lastStorage = page * elementsByPage
            if lastStorage > #selectedStorages then
                lastStorage = #selectedStorages
            end
            html_table = html_table .. '<div class="hud_container hud_table_container"><div style="text-align:center;border-bottom:1px solid white;">&#x2191; &nbsp;&nbsp; Arrow Up</div><table style="width:100%"><tr><th>&#x2190; &nbsp;&nbsp; Arrow Left</th><th> Page ' .. page .. '/' .. totalPage .. ' (from ' .. firstStorage .. ' to ' .. lastStorage .. ' on ' .. #selectedStorages .. ')</th><th>Arrow Right &nbsp;&nbsp; &#x2192;</th></tr></table><table><tr><th>id</th><th>Storage Name & Type</th><th>Item Name</th><th>Quantity</th><th style="width:100px;">Percent fill</th></tr>'
            local count = 1
            if sortingType == 1 then
                table.sort(selectedStorages, function(a,b) return a.tableName < b.tableName end)
            elseif sortingType == 2 then
                table.sort(selectedStorages, function(a,b) return a.item.locDisplayNameWithSize < b.item.locDisplayNameWithSize end)
            elseif sortingType == 3 then
                table.sort(selectedStorages, function(a,b) return a.id < b.id end)
            end
            for k,storage in pairs(selectedStorages) do
                if count >= firstStorage and count <= lastStorage then
                    local selectedClass = ""
                    if selectedRow == (count + 1 - firstStorage)then
                        selectedClass = "row_selected"
                        selectedStorage = storage
                    end
                    local item_name = ""
                    if storage.item ~= nil and storage.item.name ~= "InvalidItem" then
                        item_name = storage.item.locDisplayNameWithSize
                    end
                    local gaugePercent = storage.percent
                    if storage.percent > 100 then
                        gaugePercent = 100
                    end
                    local r,g,b = getRGBGradient(gaugePercent/100,177,42,42,249,212,123,34,177,76)
                    r = utils.round(r)
                    g = utils.round(g)
                    b = utils.round(b)
                    html_table = html_table .. '<tr><th class="' .. selectedClass .. '">' .. storage.id .. '</th><th class="' .. selectedClass .. '">' .. storage.tableName .. '<br><small>' .. storage.type .. ' ' .. storage.size .. '</small></th><th class="' .. selectedClass .. '">' .. item_name .. '</th><th class="' .. selectedClass .. '">' .. format_number(utils.round(storage.quantity*100)/100) .. '</th><th class="' .. selectedClass .. '">' .. storage.percent .. '%<br><div style="border:1px solid black;position:relative;height:5px;"><div style="position:absolute;left:0;top:0;width:' .. gaugePercent .. '%;background-color:rgb(' .. r .. ',' .. g ..',' .. b .. ');height:5px;"></div></div></th></tr>'
                end
                count = count + 1
            end
            html_table = html_table .. '</table><table style="width:100%"><tr><th>&#x2190; &nbsp;&nbsp; Arrow Left</th><th> Page ' .. page .. '/' .. totalPage .. ' (from ' .. firstStorage .. ' to ' .. lastStorage .. ' on ' .. #selectedStorages .. ')</th><th>Arrow Right &nbsp;&nbsp; &#x2192;</th></tr></table><div style="text-align:center;border-bottom:1px solid white;">&#x2193; &nbsp;&nbsp; Arrow Down</div></div>'
            maxPage = totalPage
            maxOnPage = lastStorage-firstStorage+1
        end
    end
    html_storage = html .. html_table
    selected_storage = selectedStorage
end
hud.coroutines.renderFilterStatus = function()
    html_filters = "<style>"
    html_filters = html_filters .. ".bg{margin:5px;padding:2px;}.bg" .. (statusFilter+1) .. "{border: 1px solid #28a745 !important;}"
    html_filters = html_filters .. "</style>"
    html_filters = html_filters .. [[<div class="hud_container hud_machine_status_container"><div><span class="bg bg1" >ALL</span>|]]
    for i,status in ipairs(statusList) do
        html_filters = html_filters .. [[<span class="bg bg]] .. (i+1) .. [[ ]] .. getIndustryStatusClass(i) .. [[">]] .. statusList[i] .. [[</span>]]
        if i < #statusList then html_filters = html_filters .. '|' end
    end
    html_filters = html_filters .. '</div>'
    html_filters = html_filters .. [[<hr class="hr-light"><table style="width:100%;"><tr><td style="padding-left:5px;">&#x2190; &nbsp;&nbsp; Ctrl+Arrow Left</td><td style="text-align:right;padding-right:5px;">Ctrl+Arrow Right &nbsp;&nbsp; &#x2192;</td></tr></table></div>]]
end
hud.coroutines.renderFilterType = function()
    maxFilterType = #elementsTypes
    if displayMode == 0 then
        maxFilterType = #elementsTypes + 1
    elseif displayMode == 2 then
        maxFilterType = 0
    end
    html_filters_types = "<style>"
    html_filters_types = html_filters_types .. ".bgt" .. (statusFilterType+1) .. "{border: 2px solid #28a745 !important;}"
    html_filters_types = html_filters_types .. "</style>"
    html_filters_types = html_filters_types .. '<div class="hud_container hud_machine_types_container" style="text-align:center;"><div>&#x2191; &nbsp;&nbsp; Ctrl+Arrow Up</div><hr class="hr-light">'
    if displayMode == 0 or displayMode == 1 then
        html_filters_types = html_filters_types .. '<div class="bgt1" style="margin:5px;">ALL Industries (' .. #industries_id .. ')</div>'
        for i,v in ipairs(elementsTypes) do
            html_filters_types = html_filters_types .. '<div class="bgt' .. (i+1) .. '" style="margin:5px;">' .. v .. ' (' .. machines_count[v] .. ')</div>'
        end
    end
    if displayMode == 0 or displayMode == 2 then
        local bgtclass = 'bgt' .. (#elementsTypes + 2)
        if displayMode == 2 then
            bgtclass = 'bgt1'
        end
        html_filters_types = html_filters_types .. '<div class="' .. bgtclass .. '" style="margin:5px;">Storage (' .. #storages_id .. ')</div>'
    end
    html_filters_types = html_filters_types .. '<hr class="hr-light"><div>&#x2193; &nbsp;&nbsp; Ctrl+Arrow Down</div></div>'
end
hud.coroutines.renderSelectedAR = function()
    local html = ""
    if displayType == 0 or displayType == 1 then
        if selected_machine then
            local industry = selected_machine
            html = html .. [[<div class="ib ]] .. getIndustryStatusBorderClass(industry.state) .. [[" style="border:5px solid white;left:]] .. utils.round(industry.screenPos[1]*100) .. [[%;top:]] .. utils.round(industry.screenPos[2]*100) .. [[%;font-size:]] .. fontSize .. [[px;z-index:1000;"><div class="]] .. getIndustryStatusBgClass(industry.state) .. [[" style="padding:2px;text-transform:capitalize;"><span class="tier]] .. industry.production.tier .. [[">T]] .. industry.production.tier .. [[</span><strong>]] .. industry.production.locDisplayNameWithSize .. [[</strong></div><div class="bg-light text-dark" style="margin-top:2px;padding:2px;"><div class="]] .. getIndustryStatusClass(industry.state) .. [["><strong>]] .. statusList[industry.state] .. [[</strong></div><div>]] .. industry.productId .. industry.name .. industry.type .. industry.mode .. industry.schematic .. industry.remainingTime .. industry.recipe ..[[</div></div></div>]]
        elseif selected_storage then
            local storage = selected_storage
            local displayName = storage.name
            local tierBox = ''
            local itemBox = ''
            local fillGauge = ''
            local gaugePercent = storage.percent
            if storage.percent > 100 then
                gaugePercent = 100
            end
            local r,g,b = getRGBGradient(gaugePercent/100,177,42,42,249,212,123,34,177,76)
            r = utils.round(r)
            g = utils.round(g)
            b = utils.round(b)
            if storage.item ~= nil and storage.item.name ~= "InvalidItem" then
                displayName = format_number(utils.round(storage.quantity*100)/100) .. " " .. storage.item.locDisplayNameWithSize .. " (" .. storage.percent .. "%)"
                tierBox = '<span class="tier' .. storage.item.tier .. '">T' .. storage.item.tier .. '</span>'
                local i = storage.item

                itemBox = [[<hr><div><strong>Item ID:</strong> ]] .. i.id .. [[</div><div><strong>Item Name:</strong> ]] .. i.locDisplayNameWithSize .. [[</div><div><strong>Item Unit Mass:</strong> ]] .. i.unitMass .. [[ kg</div><div><strong>Item Unit Volume:</strong> ]] .. i.unitVolume .. [[ m<sup>3</sup></div>]]
                fillGauge = '<div style="position:absolute;bottom:0;left:0px;width:' .. gaugePercent .. '%;background-color:rgb(' .. r .. ',' .. g ..',' .. b .. ');height:3px;z-index:1000;"></div>'
            end
            html = html .. [[<div class="ib" style="border: 5px solid rgb(]] .. r .. [[,]] .. g ..[[,]] .. b .. [[);left:]] .. utils.round(storage.screenPos[1]*100) .. [[%;top:]] .. utils.round(storage.screenPos[2]*100) .. [[%;font-size:]] .. fontSize .. [[px;z-index:1000;"><div class="bg-light text-dark" style="padding:2px;padding-bottom:5px;text-transform:capitalize;position:relative;">]] .. tierBox .. [[<strong>]] .. displayName .. [[</strong>]] .. fillGauge .. [[</div><div class="bg-light text-dark" style="margin-top:2px;padding:2px;"><div><strong>Container Type:</strong> ]] .. storage.type .. " " .. storage.size .. [[</div>]] .. itemBox .. [[</div></div>]]
            html = html .. [[</div>]]
        end
    end
    html_ar_selected = html
end
hud.coroutines.renderControlSelectedIndustry = function()
    local html = ""
    if #databanks > 0 and emitter ~= nil and selected_machine ~= nil and (displayType == 0 or displayType == 1) then
        local industry = selected_machine
        html = '<div class="hud_container hud_machine_control" style="text-align:center;"><div class="' .. getIndustryStatusClass(industry.state) .. '">' .. industry.tableName .. '<br><small>' .. statusList[industry.state] .. '</small></div><hr class="hr-light"><div>' .. industry.production.locDisplayNameWithSize .. '</div>'
        if industry.state == 1 or industry.state == (#statusList - 1) then
            command_1 = "START"
            command_2 = "BATCH"
            command_3 = "MAINTAIN"
            html = html .. '<table style="width:100%;"><tr><th style="text-align:left;width:100px;">START</th><th style="width:100px;"></th><th style="text-align:right;width:100px;">Alt+1</th></tr><tr><th style="text-align:left;">START BATCH</th><th rowspan="2">Quantity:<br>'
            local has_quantity = false
            for k,v in pairs(craft_quantity_digits) do
                if tonumber(v) == nil then v = 0 end
                if tonumber(v) > 0 then
                    has_quantity = true
                end
            end
            if not has_quantity then
                local value = tostring(math.floor(industry.maintainOrBatchQuantity))
                for i = #value, 1, -1 do
                    local c = value:sub(i,i)
                    craft_quantity_digits[9-(#value-(i-1))] = c
                end
            end
            for digit_index,digit in pairs(craft_quantity_digits) do
                html = html .. digit
            end
            html = html .. '</th><th style="text-align:right;">ALT+2</th></tr><tr><th style="text-align:left;">MAINTAIN</th><th style="text-align:right;">ALT+3</th></tr></table>'
        elseif industry.state < #statusList then
            command_1 = "STOP"
            command_2 = "SOFT_STOP"
            command_3 = "HARD_STOP"
            html = html .. [[<table><tr><th style="text-align:left;width:250px;">STOP</th><th style="text-align:right;width:50px;">ALT+1</th></tr><tr><th style="text-align:left;">FINISH AND STOP</th><th style="text-align:right;">ALT+2</th></tr><tr><th style="text-align:left;">STOP AND ALLOW MATERIAL LOSS</th><th style="text-align:right;">ALT+3</th></tr></table>]]
        else
            html = html .. '<div>Pending stop, please wait</div>'
        end
        html = html .. '</div>'
    end
    html_control = html
end
hud.coroutines.renderHud = function()
    local html = bootstrap_css_colors .. base_css .. html_ar_selected
    if displayMode ~= 3 then
        html = html .. html_filters_types
        if displayMode == 0 or displayMode == 1 then
            html = html .. html_machines .. html_filters .. html_control
        end
        if displayMode == 0 or displayMode == 2 then
            html = html .. html_storage
        end
    end
    html = html .. html_time .. html_credits
    system.setScreen(html)
end
hud.actions = {}
hud.actions.start = {}
hud.actions.stop = {}
hud.actions.start.brake = function() ctrlPressed = true end
hud.actions.stop.brake = function() ctrlPressed = false end
hud.actions.start.down = function()
    if ctrlPressed and displayMode < 3 then
        statusFilterType = statusFilterType + 1
        if statusFilterType > maxFilterType then statusFilterType = 0 end
        onFilterChange()
    elseif displayMode < 3 then
        selectedRow = selectedRow + 1
        if selectedRow > maxOnPage then selectedRow = 1 end
        onRowChange()
    end
end
hud.actions.start.up = function()
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
end
hud.actions.start.option1 = function()
    if #databanks > 0 and emitter ~= nil and selected_machine ~= nil and (displayType == 0 or displayType == 1) then
        --Send Command 1
        for _,db in pairs(databanks) do
            db.setStringValue(selected_machine.id, command_1)
        end
        emitter.send(channels[selected_machine.typeFilter:lower()], "")
    end
end
hud.actions.start.option2 = function()
    if #databanks > 0 and emitter ~= nil and selected_machine ~= nil and (displayType == 0 or displayType == 1) then
        --Send Command 2
        for _,db in pairs(databanks) do
            if command_2:find("MAINTAIN") or command_2:find("BATCH") then
                craft_quantity = ""
                for _,digit in pairs(craft_quantity_digits) do
                    craft_quantity = craft_quantity .. digit
                end
                command_2 = command_2 .. "_" .. craft_quantity
            end
            db.setStringValue(selected_machine.id, command_2)
            if command_2:find("MAINTAIN") then command_2 = "MAINTAIN" end
            if command_2:find("BATCH") then command_2 = "BATCH" end
        end
        emitter.send(channels[selected_machine.typeFilter:lower()], "")
    end
end
hud.actions.start.option3 = function()
    if #databanks > 0 and emitter ~= nil and selected_machine ~= nil and (displayType == 0 or displayType == 1) then
        --Send Command 3
        for _,db in pairs(databanks) do
            if command_3:find("MAINTAIN") or command_3:find("BATCH") then
                craft_quantity = ""
                for _,digit in pairs(craft_quantity_digits) do
                    craft_quantity = craft_quantity .. digit
                end
                command_3 = command_3 .. "_" .. craft_quantity
            end
            db.setStringValue(selected_machine.id, command_3)
            if command_3:find("MAINTAIN") then command_3 = "MAINTAIN" end
            if command_3:find("BATCH") then command_3 = "BATCH" end
        end
        emitter.send(channels[selected_machine.typeFilter:lower()], "")
    end
end
hud.actions.start.option6 = function()
    sortingType = sortingType + 1
    if sortingType < 0 then sortingType = #sortingTypes end
    if sortingType > (#sortingTypes) then sortingType = 1 end
end
hud.actions.start.option7 = function()
    displayType = displayType + 1
    if displayType < 0 then displayType = (#displayTypes-1) end
    if displayType > (#displayTypes-1) then displayType = 0 end
end
hud.actions.start.option8 = function()
    displayMode = displayMode + 1
    if displayMode < 0 then displayMode = (#displayModes-1) end
    if displayMode > (#displayModes-1) then displayMode = 0 end
end
hud.actions.start.option9 = function()
    init = false
end
hud.actions.start.strafeleft = function()
    if ctrlPressed and (displayMode == 0 or displayMode == 1) then
        statusFilter = statusFilter - 1
        if statusFilter < 0 then statusFilter = #statusList end
        onFilterChange()
    elseif (displayType == 0 or displayType == 1) then
        page = page - 1
        if page < 1 then page = maxPage end
        onTablePageChange()
    end
end
hud.actions.start.straferight = function()
    if ctrlPressed and (displayMode == 0 or displayMode == 1) then
        statusFilter = statusFilter + 1
        if statusFilter > #statusList then statusFilter = 0 end
        onFilterChange()
    elseif (displayType == 0 or displayType == 1) then
        page = page + 1
        if page > maxPage then page = 1 end
        onTablePageChange()
    end
end

--[[
    DU-Nested-Coroutines by Jericho
    Permit to easier avoid CPU Load Errors
    Source available here: https://github.com/Jericho1060/du-nested-coroutines
]]--

coroutinesTable  = {}

function initCoroutines()
    for k,f in pairs(hud.coroutines) do
        coroutinesTable[k] = coroutine.create(f)
    end
end

initCoroutines()

for k,f in pairs(coroutinesTable) do system.print(k) end

runCoroutines = function()
    for k,co in pairs(coroutinesTable) do
        if coroutine.status(co) == "dead" then
            coroutinesTable[k] = coroutine.create(hud.coroutines[k])
        end
        if coroutine.status(co) == "suspended" then
            assert(coroutine.resume(co))
        end
    end
end

MainCoroutine = coroutine.create(runCoroutines)

unit.hideWidget()

function onTablePageChange()
    selectedRow = 1
    onRowChange()
end

function onFilterChange()
    onTablePageChange()
    page = 1
end

function onRowChange()
    craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
end
