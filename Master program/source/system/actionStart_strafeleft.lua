if Alt_pressed == true then
    if craft_selected_digit < #craft_quantity_digits then
        craft_selected_digit = craft_selected_digit + 1
    end
else
    if page > 1 then
        page = page - 1
        selected_machine_index = 1
        Storage.clear()
    end
end