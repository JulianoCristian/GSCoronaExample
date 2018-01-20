-----------------------------------------------------------------------------------------
--
-- match.lua
--
-- Stephen Callaghan <stephen.callaghan@gamesparks.com>
-- Edited: 2018/01/19
-- Created: 2018/01/18
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

local launchBtn

---------
-- Send Matchmaking Request
-- OnFail - Display Error
---------
local function sendMatchmakingRequest( skill, matchShortCode )
    local matchRequest = gs.getRequestBuilder().createMatchmakingRequest()
    matchRequest:setSkill( skill )
    matchRequest:setMatchShortCode( matchShortCode )
    matchRequest:send( function ( matchResponse )
        if matchResponse:hasErrors() then
            print( "Matchmaking Error: " )
        end
    end)
end

---------
-- On Match Found Message Received
-- Capture Real Time Details, Display Join Button
---------
local function onMatchFoundReceived( matchMessage )
    -- Set into composer memory
    composer.setVariable( "matchMessage", matchMessage )
    launchBtn:setEnabled( true )
    print( "Match Found" )
end

---------
-- On Match Not Found Message Received
---------
local function onMatchNotFoundReceived( matchNotFoundMessage )
    print( "Match not found" )
    launchBtn:setEnabled( false )
end

-- create()
function scene:create( event )
    local sceneGroup = self.view

    -- Skill Txt Setup
    display.newText( sceneGroup, "Skill: ", 100, 150, native.systemFont, 16 )
    local skillTxt = native.newTextField( 300, 150, 180, 30 )
    sceneGroup:insert( skillTxt )

    -- Match Short Code Txt Setup
    display.newText( sceneGroup, "Match Shortcode: ", 100, 200, native.systemFont, 16 )
    local matchShortCodeTxt = native.newTextField( 300, 200, 180, 30 )
    sceneGroup:insert( matchShortCodeTxt )

    -- Match Making Btn Setup
    local matchBtn = widget.newButton
    {
        width = 154,
        height = 40,
        label = "Find Match",
        x = display.contentCenterX,
        y = display.contentHeight - 125,
        onRelease = function ()
            sendMatchmakingRequest( skillTxt.text, matchShortCodeTxt.text )
        end
    }
    sceneGroup:insert( matchBtn )

    launchBtn = widget.newButton
    {
        width = 154,
        height = 40,
        label = "Launch Match",
        x = display.contentCenterX,
        y = display.contentHeight - 165,
        onRelease = function ()
            composer.gotoScene( "realtime" )
        end
    }
    sceneGroup:insert( launchBtn )
    launchBtn:setEnabled( false )
end

local listener = gs.getMessageHandler()
listener.setMatchFoundMessageHandler( onMatchFoundReceived )
listener.setMatchNotFoundMessageHandler( onMatchNotFoundReceived )
scene:addEventListener( "create", scene )
return scene