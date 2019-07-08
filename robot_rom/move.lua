local event = require( 'event' )
local sides = require( 'sides' )
--local modem = require( 'modem' )
local component = require( 'component' )
local modem = component.proxy( component.list()() )
assert( modem, 'No modem found' )
local on = true

local function moveRobot( side )
    modem.broadcast( 8080, 'move', side, 1 )
end

local function turnRobot( side )
    modem.broadcast( 8080, 'turn', side )
end

local function moveForward()
    moveRobot( sides.front )
end

local function moveBack()
    moveRobot( sides.back )
end

local function turnLeft()
    turnRobot( sides.left )
end

local function turnRight()
    turnRobot( sides.right )
end

local function moveUp()
    moveRobot( sides.up )
end

local function moveDown()
    moveRobot( sides.down )
end

local function QuitCtrl()
    on = false
end

local keymap = {
    [ 101 ] = moveForward,
    [ 100 ] = moveBack,
    [ 115 ] = turnLeft,
    [ 102 ] = turnRight,
    [ 119 ] = moveUp,
    [ 114 ] = moveDown,
    [ 13 ] = QuitCtrl,
    [ 8 ] = QuitCtrl,
}
print( 'listening keyboard...' )
print( 'press enter or backspace to exit' )
while on do
    local _, _, vk = event.pull( 5, 'key_down' )
    if keymap[ vk ] then
        keymap[ vk ]()
    end
end

