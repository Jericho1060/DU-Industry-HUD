local content = schematicContainer.getContent()
for _,s in pairs(content) do
    schematicStorage["s" .. s.id] = s.quantity
end