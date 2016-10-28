local composer = require( "composer" )
local scene = composer.newScene()
local x = display.contentWidth/2    -- Center x point
local y = display.contentHeight/2   -- Center y point

 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 

local function showScene1()   -- Defeat (2 out of 3) prompts the player to return to the main menu.

   local options = {
      effect = "fade",
      time = 300
   }
   composer.removeScene("scene3")
   composer.gotoScene("scene1", options)

end


---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view

   local bg = display.newImage ("sky.png";   -- Adds bg2
   bg.x = display.contentWidth / 2;          -- Centers bg
   bg.y= display.contentHeight / 2;
   loseText = display.newEmbossedText( "Game Over", 240, -10, native.systemFont, 40 );
   loseText:setFillColor( 1,1,1 );
   sceneGroup:insert(bg);                    -- Adds bg to sceneGroup
   sceneGroup:insert(loseText);


   ---------- ALEX KIDD ---------------------------------
   
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
      -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene