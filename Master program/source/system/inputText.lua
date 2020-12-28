system.print(text)
if tonumber(text) then
    if #text > 8 then
        system.print("the value should not be higher than 99 999 999.")
    else
        for i = #text, 1, -1 do
            local c = text:sub(i,i)
            craft_quantity_digits[9-(#text-(i-1))] = c
        end
    end
else
    system.print("You must type a Number")
end