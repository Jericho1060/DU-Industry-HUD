--[[
	Databank HUB
	Inspired by the original BankRaid Script written by ilodev
	Modified to act like a databank hub by Jericho (read and clear only)
]]
bankhub = {}

function bankhub:new(banks)
  o = {}
  setmetatable(o, self);
  self.__index = self;
  o.banks = banks or {}

  -- databank shortcuts to allow in-game syntax.
  function o.clear()                    return o:_clear() end
  function o.getNbKeys()                return o:_getNbKeys() end
  function o.getKeys()                  return o:_getKeys() end
  function o.hasKey(key)                return o:_hasKey(key) end
  function o.getStringValue(key)        return o:_getStringValue(key) end
  function o.getIntValue(key)           return o:_getIntValue(key) end
  function o.getFloatValue(key)         return o:_getFloatValue(key) end

  return o
end
--- Adds another databank to the raid.
--- @param object The databank unit to add.
function bankhub:add(element)
  table.insert( self.banks, element)
  self.banks_size = #self.banks
end
--- Clears the databank array
function bankhub:_clear()
  for _,bank in pairs(self.banks) do bank.clear() end
end
--- Returns the number of keys in the entire databank table
--- @return integer number of total keys
function bankhub:_getNbKeys()
  local res = 0
  for _,bank in pairs(self.banks) do res = res + bank.getNbKeys() end
  return res
end

--- Returns all the keys in the databank array
--- @return string json encoded string of keys
function bankhub:_getKeys()
    local res = {}
    for _,bank in pairs(self.banks) do
        local keys = json.decode(bank.getKeys())
        for _,k in pairs(keys) do table.insert(res, k) end
    end
    return json.encode(res)
end

--- Checks if a key exists in the databank array
--- @param string key
--- @return boolean returns 1 if the array holds this key.
function bankhub:_hasKey(key)
    for _,bank in pairs(self.banks) do
        if (bank.hasKey(key) == 1) then return 1 end
    end
    return 0
end

--- Returns the value of the key if existing
--- @param string key
--- @return string returns value or nil
function bankhub:_getStringValue(key)
  for _,bank in pairs(self.banks) do
    if (bank.hasKey(key) == 1) then
      return bank.getStringValue(key)
    end
  end
  return nil
end

--- Returns the integer value of the key if existing
--- @param string key
--- @return number returns value or nil
function bankhub:_getIntValue(key)
  for _,bank in pairs(self.banks) do
    if (bank.hasKey(key) == 1) then
      return banks.getIntValue(key)
    end
  end
  return nil
end

--- Returns the float value of the key if existing
--- @param string key
--- @return number returns value or nil
function bankhub:_getFloatValue(key)
  for _,bank in pairs(self.banks) do
    if (bank.hasKey(key) == 1) then
      return banks.getFloatValue(key)
    end
  end
  return nil
end