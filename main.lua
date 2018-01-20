-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Stephen Callaghan <stephen.callaghan@gamesparks.com>
-- Edited: 2018/01/20
-- Created: 2018/01/18
-----------------------------------------------------------------------------------------
local composer = require( "composer" )

-- Include GS
local gsIn = require( "plugin.gamesparks" )
local gsData = require( "plugin.gamesparks.GSData" )
local gsUtils = require( "plugin.gamesparks.GSUtils" )
local gsRequest = require( "plugin.gamesparks.GSRequest" )
local gsResponse = require( "plugin.gamesparks.GSResponse" )

-- Initialize GameSparks
gs = createGS()
gs.setLogger( print )
gs.setApiKey( "" )
gs.setApiSecret( "" )
gs.setApiCredential( "device" )
gs.setAvailabilityCallback(function ( isAvailable )
    print( "GS: Availability: " .. tostring(isAvailable) .. "\n" )
    if isAvailable and not gs.isAuthenticated() then
        composer.gotoScene( "auth" )
    elseif isAvailable and gs.isAuthenticated() then
        composer.gotoScene( "match" )
    end
end)
gs.connect()