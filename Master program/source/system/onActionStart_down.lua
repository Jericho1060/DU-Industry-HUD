if Ctrl_pressed == true then
    if selected_index < #elementsTypes then
        selected_index = selected_index + 1
        reloadMachinesOnTypeChange()
    else
        selected_index = 1
        reloadMachinesOnTypeChange()
    end
else
    if selected_machine_index < #elements then
        selected_machine_index = selected_machine_index + 1
    else
        selected_machine_index = 1
    end
    craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
end
