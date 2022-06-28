local year, month, day, hour, minute, second = DUCurrentDateTime()
local dateStr = string.format("%02d/%02d/%04d %02d:%02d:%02d",day,month,year,hour,minute,second)
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