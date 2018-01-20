-----------------------------------------------------------------------------------------
--
-- realtime.lua
--
-- Stephen Callaghan <stephen.callaghan@gamesparks.com>
-- Edited: 2018/01/20
-- Created: 2018/01/20
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local gameSession = require( "GameSession" )
local scene = composer.newScene()

local pingBtn
local mySession = nil

local function setupRealTimeSession( matchMessage )
    mySession = gameSession.new(
        matchMessage:getAccessToken(),
        matchMessage:getHost(),
        matchMessage:getPort())
end

local function sendPing()
end

-- create()
function scene:create( event )
    local sceneGroup = self.view

    -- Send Pint Btn Setup
    pingBtn = widget.newButton
    {
        width = 154,
        height = 40,
        label = "Send Ping",
        onRelease = sendPing,
        x = display.contentCenterX,
        y = display.contentHeight - 125
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