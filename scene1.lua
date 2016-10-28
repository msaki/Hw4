local composer = require( "composer" )
local scene = composer.newScene()
local x = display.contentWidth/2    -- Center x point
local y = display.contentHeight/2   -- Center y point
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here

local function showScene2()

   local options = {
      effect = "fade",
      time = 300
   }
   composer.removeScene("scene1")
   composer.gotoScene("scene2", options)

end
 
---------------------------------------------------------------------------------
 
-- Title Scene/Main Screen

-- "scene:create()"
function scene:create( event )
 
  local sceneGroup = self.view
 

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   		local bg = display.newImage("sky.png")
        bg.x = x;
        bg.y = y;
      title = display.newText("Harambe Simulator", 160, 100, native.systemFont, 24)
      title:setFillColor(235, 235, 235)
      nametitle = display.newText("Jared Hornbuckle", 160, 130, native.systemFont, 24)
      nametitle:setFillColor(235, 235, 235)
      nametitle2 = display.newText("Michael Saki", 160, 160, native.systemFont, 24)
      nametitle2:setFillColor(235, 235, 235)
      startblock = display.newRect(160, 200, 100, 30)
      start = display.newText("Play", 160, 200, native.systemFont, 16)
      startblock:setFillColor (0.2, 0.7, 0.6)
      start:setFillColor (0, 0, 0)
      start:addEventListener("tap", showScene2);
      sceneGroup:insert(bg);
      sceneGroup:insert(title);
    	sceneGroup:insert(nametitle);
    	sceneGroup:insert(nametitle2);
      sceneGroup:insert(startblock);
    	sceneGroup:insert(start);

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