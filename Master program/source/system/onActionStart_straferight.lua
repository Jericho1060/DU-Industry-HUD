if page < maxPage then
    page = page + 1
    selected_machine_index = 1
    Storage.clear()
    hud_machines_rows = {}
    elements = {}
    temp_elements_for_sorting = {}
    temp_elements = {}
    temp_refresh_id_list = {}
end
