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

---------
-- Send Matchmaking Request
-- OnFail - Display Error
---------
local function sendMatchmakingRequest( skill, matchShortCode )
    local matchRequest = gs.getRequestBuilder().createMatchmakingRequest()
    matchRequest:setSkill( skill )
    matchRequest:setMatchShortCode( matchShortCode )
    matchRequest:send(function (matchResponse)
        if matchResponse:hasErrors() then
            print( "Matchmaking Error: " )
        end
    end)
end

-- create()
function scene:create( event )
	local sceneGroup = self.view

    -- Skill Txt Setup
    display.newText( sceneGroup, "Skill: ", 100, 150, native.systemFont, 16 )
    local skillTxt = native.newTextField( 300, 150, 180, 30 )

    -- Match Short Code Txt Setup
    display.newText( sceneGroup, "Match Shortcode: ", 100, 200, native.systemFont, 16)
    local matchShortCodeTxt = native.newTextField( 300, 200, 180, 30 )

    -- Match Making Btn Setup
    local matchBtn = widget.newButton
    {
        width = 154,
        height = 40,
        label = "Find Match",
        onRelease = function ()
            sendMatchmakingRequest( skillTxt.text, matchShortCodeTxt.text )
        end
    }
    matchBtn.x = display.contentCenterX
    matchBtn.y = display.contentHeight - 125

    sceneGroup:insert( matchBtn )
end

scene:addEventListener( "create", scene )
return scene