local me = component.proxy( component.list( 'robot' )() )
assert( me, 'This rom is made for robot only' )
local modem = component.proxy( component.list( 'modem' )() )
assert( modem, 'No modem found' )
assert( modem.isOpen( 8080 ) or modem.open( 8080 ), 'Cannot listen to port 8080' )
local on = true

local function registRobot( from, ... )
    modem.send( from, 8080, 'regrobot', me.name() )
end

local function doMove( _, side, step )
    local realstep = tonumber( step ) or 1
    for i=1, realstep do
        me.move( side )
    end
end

local function shutdown( ... )
    on = false
end

local cmdmap = {
    [ 'whoisthat' ] = registRobot,
    [ 'move' ] = doMove,
    [ 'shutdown' ] = shutdown
}

while on do
    local msg, _, from, port, _, cmd, arg1, arg2 = computer.pullSignal( 5 )
    if msg == 'modem_message' and port == 8080 and cmdmap[ cmd ] then
        computer.beep()
        cmdmap[ cmd ]( from, arg1, arg2 )
    end
end

