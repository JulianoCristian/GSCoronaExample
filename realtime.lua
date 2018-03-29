-----------------------------------------------------------------------------------------
--
-- realtime.lua
--
-- Stephen Callaghan <stephen.callaghan@gamesparks.com>
-- Edited: 2018/03/29
-- Created: 2018/01/20
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local gsIn = require( "plugin.gamesparks" )
local gsrt = gsIn.getRealTimeServices()
local composer = require( "composer" )
local gameSession = require( "GameSession" )
local scene = composer.newScene()

local pingBtn
local leaveBtn
local mySession = nil

local function setupRealTimeSession( matchMessage )
    mySession = gameSession.new(
        matchMessage:getAccessToken(),
        matchMessage:getHost(),
        matchMessage:getPort())

    mySession.onPacketCB = function( packet )
        print("Received Packet" .. packet.opCode )
        if packet.opCode == 998 then
            sendPong()
        end
    end    
end

local function sendPing()
    local data = gs.getRTData().new()
    data:setLong(1, 1000000)
    mySession.session:sendRTData(998, gsrt.deliveryIntent.RELIABLE, data, {})
end

local function sendPong()
    local data = gs.getRTData().new()
    data:setInt(1, 1)
    mySession.session:sendRTData(999, gsrt.deliveryIntent.RELIABLE, data, {})
end

local function leaveSession()
    mySession.session:stop()
    composer.gotoScene( "match" )
end

-- create()
function scene:create( event )
    local sceneGroup = self.view

    -- Send Ping Btn Setup
    pingBtn = widget.newButton
    {
        width = 154,
        height = 40,
        label = "Send Ping",
        onRelease = sendPing,
        x = display.contentCenterX,
        y = display.contentHeight - 105
    }

    -- Leave Btn Setup
    leaveBtn = widget.newButton
    {
        width = 154,
        height = 40,
        label = "Leave Session",
        onRelease = leaveSession,
        x = display.contentCenterX,
        y = display.contentHeight - 135
    }
    sceneGroup:insert( pingBtn )
    setupRealTimeSession(composer.getVariable( "matchMessage" ))
end

scene:addEventListener( "create", scene )
Runtime:addEventListener( "enterFrame", function ()
    if not mySession then return end
    mySession.session:update() -- RT requires update
end)
return scene