if recipeListIndex == nil then recipeListIndex = 1 end
local maxForLoop = recipeListIndex + maxAmountOfRecipeLoadedBySecond
if maxForLoop > #recipeToLoad then maxForLoop = #recipeToLoad end
--system.print("recipeUpdate " .. recipeListIndex .. "/" .. maxForLoop)
for i = recipeListIndex, maxForLoop, 1 do
    recipeListIndex = i
    if (loadedRecipes[recipeToLoad[i]] == nil) and (tonumber(recipeToLoad[i]) > 0) then
        --system.print(recipeToLoad[i])
        local recipe = json.decode(core.getSchematicInfo(recipeToLoad[i]))
        if (recipe.products) then
            if #recipe.products > 0 then
                recipeName = recipe.products[1].name
            end
        end
        loadedRecipes[recipeToLoad[i]] = recipeName
    end
end
if recipeListIndex >= #recipeToLoad then
    recipeToLoad = {}
    recipeListIndex = 1
end
--system.print(json.encode(loadedRecipes))