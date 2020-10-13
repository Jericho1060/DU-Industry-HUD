if Alt_pressed == true then
    if craft_selected_digit > 1 then
        craft_selected_digit = craft_selected_digit - 1
    end
else
    if page < maxPage then
        page = page + 1
        selected_machine_index = 1
        Storage.clear()
    end
end