local year, month, day, hour, minute, second = epochTime()
local dateStr = year .. "/" .. month .. "/" .. day .. " " .. hour .. ":" .. minute .. ":" .. second
if dateFormat:lower() == "fr" then
    dateStr = day .. "/" .. month .. "/" .. year .. " " .. hour .. ":" .. minute .. ":" .. second
end

hud_help_command = [[<div class="hud_help_commands hud_container">
    <table>
        <tr>
            <th colspan="2">
                ]] .. dateStr .. [[
            </th>
        </tr>
        <tr>
            <td>Show/Hide HUD</td>
            <th style="text-align:right;">Alt+7</th>
        </tr>
    </table>
</div>]]