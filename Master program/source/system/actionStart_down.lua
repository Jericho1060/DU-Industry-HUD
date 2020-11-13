if Ctrl_pressed == true and Alt_pressed == false then
    if selected_index < #elementsTypes then
        selected_index = selected_index + 1
        selected_machine_index = 1
        page = 1
        Storage.clear()
        craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
        selectedElementsId = {}
    end
elseif Alt_pressed == true and Ctrl_pressed == false then
    local digit_index = #craft_quantity_digits - craft_selected_digit + 1
    local value = tonumber(craft_quantity_digits[digit_index]) - 1
    if value < 0 then value = 9 end
    craft_quantity_digits[digit_index] = tostring(value)
else
    if selected_machine_index < #elements then
        selected_machine_index = selected_machine_index + 1
        craft_quantity_digits = {"0","0","0","0","0","0","0","0"}
    end
end