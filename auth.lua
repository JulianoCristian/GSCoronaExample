-----------------------------------------------------------------------------------------
--
-- auth.lua
--
-- Stephen Callaghan <stephen.callaghan@gamesparks.com>
-- Edited: 2018/01/19
-- Created: 2018/01/18
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

---------
-- Authentication Player
-- OnFail - Display Error
-- OnSuccess - Go to Match Scene
---------
local function authenticate( username, password )
    local authRequest = gs.getRequestBuilder().createAuthenticationRequest()
    authRequest:setUserName( username )
    authRequest:setPassword( password )
    authRequest:send( function ( authResponse )
        if not authResponse:hasErrors() then -- Success
            print ( "Authentication Successful" )
            composer.gotoScene( "match" )
        else
            print ( "Authentication Failed, attempting registration" )
            local regRequest = gs.getRequestBuilder().createRegistrationRequest()
            reqRequest:setUserName( username )
            reqRequest:setPassword( password )
            reqRequest:setDisplayName( username )
            reqRequest:send( function (regResponse)
                if not regResponse:hasErrors() then -- Success
                    composer.gotoScene( "match" )
                else
                    print ( "Registration failed" )
                end
            end)
        end
    end)
end

-- create()
function scene:create( event )
	local sceneGroup = self.view

    -- Username Txt Setup
    local usernameLbl = display.newText( sceneGroup, "Username: ", 100, 150, native.systemFont, 16 )
    local usernameTxt = native.newTextField( 300, 150, 180, 30 )

    -- Password Txt Setup
    local passwordLbl = display.newText( sceneGroup, "Password: ", 100, 200, native.systemFont, 16)
    local passwordTxt = native.newTextField( 300, 200, 180, 30 )

    -- Auth Btn Setup
    local authBtn = widget.newButton
    {
        width = 154,
        height = 40,
        label = "Authenticate",
        onRelease = function ()
            authenticate( usernameTxt.text, usernameTxt.text )
        end
    }
    authBtn.x = display.contentCenterX
    authBtn.y = display.contentHeight - 125

    sceneGroup:insert( authBtn )
end

scene:addEventListener( "create", scene )
return scene