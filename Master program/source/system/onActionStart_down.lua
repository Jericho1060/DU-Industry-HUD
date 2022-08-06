if Ctrl_pressed == true then
    if selected_index < #elementsTypes then
        selected_index = selected_index + 1
        selected_type = elementsTypes[selected_index]
        selected_machine_index = 1
        page = 1
        Storage.clear()
        craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
        selectedElementsId = {}
        hud_machines_rows = {}
        elements = {}
        selectedElementsId = {}
        temp_selectedElementsId = {}
        temp_elements_for_sorting = {}
        temp_elements = {}
        temp_refresh_id_list = {}
        machineLoaded = false
    end
else
    if selected_machine_index < #elements then
        selected_machine_index = selected_machine_index + 1
        craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
    end
end
