if Ctrl_pressed == true then
    if selected_index < #elementsTypes then
        selected_index = selected_index + 1
        selected_machine_index = 1
        page = 1
        Storage.clear()
        craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
        selectedElementsId = {}
    end
else
    if selected_machine_index < #elements then
        selected_machine_index = selected_machine_index + 1
        craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
    end
end