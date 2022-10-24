--[[
    DU-Nested-Coroutines by Jericho
    Permit to easier avoid CPU Load Errors
    Source available here: https://github.com/Jericho1060/du-nested-coroutines
]]--

if coroutine.status(MainCoroutine) == "dead" then
  MainCoroutine = coroutine.create(runCoroutines)
end
if coroutine.status(MainCoroutine) == "suspended" then
  assert(coroutine.resume(MainCoroutine))
end
