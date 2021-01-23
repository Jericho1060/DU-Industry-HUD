--[[
	receivers channels for each type of machine
]]

local version = "RC 2.0.0 - update 3"

system.print("==================================================")
local print_version_str = ""
local print_version_number = math.ceil((50-#version-2)/2)
for i=1, print_version_number, 1 do print_version_str = print_version_str .. '=' end
print_version_str = print_version_str .. " " .. version .. " "
for i=1, print_version_number, 1 do print_version_str = print_version_str .. '=' end
system.print(print_version_str)
system.print("==================================================")

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

container_proficiency_lvl = 0 ---export: Talent level for Container Proficiency
container_fill_red_level = 10 ---export: The percent fill below gauge will be red
container_fill_yellow_level = 50 ---export: The percent fill below gauge will be yellow

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
enableContainerMonitoring = false ---export: enable or disable the containers and hubs monitoring
enableRemoteControl = true --export: enable the HUD to control machines (start/stop/batch/maintain)
containerMonitoringPrefix = "MONIT_" ---export: the prefix used to enable container monitoring
elementsByPage = 20 --export: maximum amount of elements displayed on a single page
dateFormat = "en" --export: the country code to format the date
maxAmountOfElementsLoadedBySecond = 2000 --export: if cpu load errors at start, lower that value
maxAmountOfRecipeLoadedBySecond = 10 --export: if cpu load errors on page load, lower that value

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

if emitter == nil then
    enableRemoteControl = false
    system.print("Connect an Emitter to enable machine control from industry")
end
if #databanks == 0 then
    enableRemoteControl = false
    system.print("No Databank linked")
end
Storage = bankhub:new(databanks)

elementsId = {}
elements = {}
elementsTypes = {}
machines_count = {}
machines_count.total = 0
coreOffset = 16
initIndex = 1
listIndex = 1
elementsIdList = {}
if core ~= nil and Storage then
    elementsIdList = core.getElementIdList()
    unit.setTimer("init",1)
end

elementsTypes = removeDuplicatesInTable(elementsTypes)

system.showScreen(1)
channel_index = 1
selected_index = 1
selected_machine_index = 1
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
markers = {}
refreshActivated = true
hud_help_command = ""
unit.setTimer("helperRefresh",1)
minOnPage = 0
maxOnPage = 0
recipeToLoad = {}
loadedRecipes = {}

unit.setTimer("recipeUpdate", 1)