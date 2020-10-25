--[[
	receivers channels for each type of machine
]]

channel_for_refiner = "receiver_refiner" --export: receiver channel for updating refiners
channel_for_assembly = "receiver_assembly" --export: receiver channel for updating assembly lines
channel_for_smelter = "receiver_smelters" --export: receiver channel for updating smelters
channel_for_chemical = "receiver_chemical" --export: receiver channel for updating chemical indutries
channel_for_electronics = "receiver_electronics" --export: receiver channel for updating  electronic industries
channel_for_glass = "receiver_glass" --export: receiver channel for updating  glass furnace
channel_for_honeycomb = "receiver_honeycomb_recycler" --export: receiver channel for updating honeycomb refiniries
channel_for_recycler = "receiver_honeycomb_recycler" --export: receiver channel for updating recylers
channel_for_metalwork = "receiver_metalworks" --export: receiver channel for updating metalworks
channel_for_3d_printer = "receiver_3dprinters" --export: receiver channel for updating 3d printers
channel_for_transfer = "receiver_transfert" --export: receiver channel for updating tranfer units
container_proficiency_lvl = 0 --export: Talent level for Container Proficiency
container_fill_red_level = 10 --export: The percent fill below gauge will be red
container_fill_yellow_level = 50 --export: The percent fill below gauge will be yellow
enableTransferMonitoring = true --export: enable or diable the transfer units monitoring
enableContainerMonitoring = true --export: enable or diable the containers and hubs monitoring
refreshSpeed = 1 --export: the refresh speed of data in seconds
elementsByPage = 20 --export: maximum amount of elements displayed on a single page
dateFormat = "en" --export: the country code to format the date

--[[
	DO NOT CHANGE THE FOLLOWING
]]

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

databanks = {}
core = nil
emitter = nil
for slot_name, slot in pairs(unit) do
    if
        type(slot) == "table"
        and type(slot.export) == "table"
        and slot.getElementClass
    then
        if slot.getElementClass():lower() == 'databankunit' then
            table.insert(databanks, slot)
        end
        if slot.getElementClass():lower():find("coreunit") then
            core = slot
        end
        if slot.getElementClass():lower() == 'emitterunit' then
            emitter = slot
        end
    end
end
Storage = bankhub:new(databanks)

elementsId = {}
elements = {}
elementsTypes = {}
machines_count = {}
machines_count.total = 0
coreOffset = 16
if core ~= nil and Storage then
	elementsIdList = core.getElementIdList()
     for _,id in pairs(elementsIdList) do
        elementType = core.getElementTypeById(id):lower()
        if elementType == "assembly line" or
           elementType == "glass furnace" or
           elementType == "3d printer" or
           elementType == "smelter" or
           elementType == "recycler" or
           elementType:find("refiner") or
           elementType:find("industry") or
           elementType == "transfer unit" or
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
end

elementsTypes = removeDuplicatesInTable(elementsTypes)

system.showScreen(1)
unit.setTimer("refreshData", refreshSpeed)
channel_index = 1
selected_index = 1
selected_machine_index = 1
hud_displayed = true
page = 1
maxPage = 1
selectedElementsId = {}
Ctrl_pressed = false
Alt_pressed = false
craft_quantity = ""
craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
refresh_id_list = {}
craft_selected_digit = 1
command_1 = ""
command_2 = ""
command_3 = ""
markers = {}
refreshActivated = true