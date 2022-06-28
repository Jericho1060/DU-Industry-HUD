if recipeListIndex == nil then recipeListIndex = 1 end
local maxForLoop = recipeListIndex + maxAmountOfRecipeLoadedBySecond
if maxForLoop > #recipeToLoad then maxForLoop = #recipeToLoad end
for i = recipeListIndex, maxForLoop, 1 do
    recipeListIndex = i
    if (loadedRecipes[recipeToLoad[i]] == nil) and (tonumber(recipeToLoad[i]) > 0) then
        local recipe = system.getSchematic(recipeToLoad[i])
        if (recipe.products) then
            if #recipe.products > 0 then
                local item = system.getItem(recipe.products[1].id)
                recipeName = item.locDisplayNameWithSize
            end
        end
        loadedRecipes[recipeToLoad[i]] = recipeName
    end
end
if recipeListIndex >= #recipeToLoad then
    recipeToLoad = {}
    recipeListIndex = 1
end
