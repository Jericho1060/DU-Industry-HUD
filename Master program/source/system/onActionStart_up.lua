if Ctrl_pressed == true then
    if selected_index > 1 then
        selected_index = selected_index - 1
        reloadMachinesOnTypeChange()
    else
        selected_index = #elementsTypes
        reloadMachinesOnTypeChange()
    end
else
    if selected_machine_index > 1 then
        selected_machine_index = selected_machine_index - 1
    else
        selected_machine_index = #elements
    end
    craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
end
