local json = require "json"

local SaveManager = {}
SaveManager.__index = SaveManager

local DEFAULT_FILE = "saves.json"
local SLOT_COUNT = 3

function SaveManager:new(filePath)
    local obj = setmetatable({}, self)
    obj.filePath = filePath or DEFAULT_FILE
    obj.slots = {}
    obj:load()
    return obj
end

function SaveManager:_createEmptySlot(index)
    return {
        slotIndex = index,
        occupied = false,
        savedAt = nil,
        gameData = nil
    }
end

function SaveManager:load()
    local raw = love.filesystem.read(self.filePath)
    if raw then
        local parsed = json.decode(raw)
        if parsed and parsed.slots then
            self.slots = parsed.slots
        end
    end

    -- garante os 3 slots
    for i = 1, SLOT_COUNT do
        if not self.slots[i] then
            self.slots[i] = self:_createEmptySlot(i)
        end
    end
end

function SaveManager:saveToFile()
    local wrapped = { slots = self.slots }
    love.filesystem.write(self.filePath, json.encode(wrapped))
end

function SaveManager:getSlot(index)
    return self.slots[index]
end

function SaveManager:setSlot(index, data)
    if index < 1 or index > SLOT_COUNT then return false end
    local slot = self.slots[index]
    slot.occupied = true
    slot.savedAt = os.date("%Y-%m-%d %H:%M:%S")
    slot.gameData = data
    self:saveToFile()
    return true
end

function SaveManager:clearSlot(index)
    if index < 1 or index > SLOT_COUNT then return false end
    self.slots[index] = self:_createEmptySlot(index)
    self:saveToFile()
    return true
end

function SaveManager:clearAll()
    for i = 1, SLOT_COUNT do
        self.slots[i] = self:_createEmptySlot(i)
    end
    self:saveToFile()
end

return SaveManager
