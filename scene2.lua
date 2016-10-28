local composer = require( "composer" )
local scene = composer.newScene()
local x = display.contentWidth/2    -- Center x point
local y = display.contentHeight/2   -- Center y point

local physics = require("physics");
display.setStatusBar( display.HiddenStatusBar )
physics.start();

physics.setGravity(0,0);

local Enemy = require ("Enemy");
local soundTable=require("soundTable");


---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
local function showScene3()   -- Victory (2 out of 3) allows the player to go to the next fight.


   local options = {
      effect = "fade",
      time = 300
   }
   composer.removeScene("scene2");
   composer.gotoScene("scene3", options)

end

local function showScene1()   -- Defeat (2 out of 3) prompts the player to return to the main menu.
   
   local options = {
      effect = "fade",
      time = 300
   }
   composer.removeScene("scene2")
   composer.gotoScene("scene1", options)

end



local function play ()
      --each time play function is called a new clock will appear 
      local secondsLeft = 5
      
      clockText:setFillColor( 0.7, 0.7, 1 )

   local function updateTime()

   
   

      -- decrement the number of seconds
      secondsLeft = secondsLeft - 1
      
      -- time is tracked in seconds.  We need to convert it to minutes and seconds
      local seconds = secondsLeft % 60
   
      -- make it a string using string format.  
      local timeDisplay = string.format( "%02d", seconds )
      clockText.text = timeDisplay
   
   end
      local countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )

end

function move ( event )
    if event.phase == "began" then     
      cube.markX = cube.x 
    elseif event.phase == "moved" then    
      local x = (event.x - event.xStart) + cube.markX    
      
      if (x <= 20 + cube.width/2) then
         cube.x = 20+cube.width/2;
      elseif (x >= display.contentWidth-20-cube.width/2) then
         cube.x = display.contentWidth-20-cube.width/2;
      else
         cube.x = x;    
      end

    end
    
end

-- Projectile 
cnt = 0;
function fire (event) 
  --if (cnt < 3) then
    cnt = cnt+1;
   p = display.newCircle (cube.x, cube.y-16, 5);
   p.anchorY = 1;
   p:setFillColor(0,1,0);
   physics.addBody (p, "dynamic", {radius=5} );
   p:applyForce(0, -0.4, p.x, p.y);

   audio.play( soundTable["shootSound"] );

   local function removeProjectile (event)
      if (event.phase=="began") then
          event.target:removeSelf();
         event.target=nil;
         --cnt = cnt - 1;

         if (event.other.tag == "enemy") then

            event.other.pp:hit();
            hitcnt = hitcnt + 1;
            scoreText.text = "Hit: "..hitcnt;
            
         end
      end
    end
    
    p:addEventListener("collision", removeProjectile);
  --end
end


function userDamaged (event) 
   cube.HP = cube.HP - 5;
   HPText.text = "HP: "..cube.HP;
   if (cube.HP > 0) then 
      audio.play( soundTable["hitSound"] );  
   else 
      audio.play( soundTable["explodeSound"] );
      timer.performWithDelay(1000, showScene3);
      --[[transition.cancel( cube.shape );
      cube:removeSelf();
      cube = nil;
      HPText:removeSelf();
      scoreText:removeSelf();

      transition.cancel( sq.shape );
      
      if (sq.timerRef ~= nil) then
         timer.cancel ( sq.timerRef );
      end

      sq.shape:removeSelf();
      sq.shape = nil;
      sq = nil;

      transition.cancel( tr.shape );
      
      if (tr.timerRef ~= nil) then
         timer.cancel ( tr.timerRef );
      end

      if (tr.shape ~= nil) then
         tr.shape:removeSelf();
         tr.shape = nil;
         tr = nil;
      end
      

      controlBar:removeSelf();
      ceiling:removeSelf();]]



   end      
end

function Square:spawn()
  local vertices = { -20,-20, -10,-40, 10,-40, 20,-20, 0,0, }

  self.shape = display.newPolygon (self.xPos, self.yPos, vertices); 

  self.shape.pp = self;
  self.shape.tag = "enemy";
  self.shape:setFillColor (0, 1, 1);
  physics.addBody(self.shape, "kinematic", {shape = vertices}); 
end

function Square:forward ()   
   transition.to(self.shape, {x=self.shape.x+100, y=800, 
   time=self.fT, rotation=self.fR, 
   onComplete= function (obj) self:side() end } );
end

function Square:move () 
   self:forward();
end

function Square:back ()   
   transition.to(self.shape, {x=self.shape.x-400, 
           time=self.bT, rotation=self.sR, 
      onComplete=function (obj) self:forward() end});
end

function Square:forward () 
   transition.to(self.shape, {x=self.shape.x+400, 
           time=self.fT, rotation=self.fR, 
      onComplete= function (obj) self:back() end });
end




------------Triangle

function Triangle:spawn()
 self.shape = display.newPolygon(self.xPos, self.yPos, 
                      {-15,-15,15,-15,0,15});
  
 self.shape.pp = self;
 self.shape.tag = "enemy";
 self.shape:setFillColor ( 1, 0, 1);
 physics.addBody(self.shape, "kinematic", 
           {shape={-15,-15,15,-15,0,15}}); 
end



function Triangle:back ()  
  transition.to(self.shape, {x=self.shape.x-600, 
    y=self.shape.y-self.dist, time=self.bT, rotation=self.bR, 
    onComplete= function (obj) self:forward() end } );
end

function Triangle:side ()  
   transition.to(self.shape, {x=self.shape.x + 400, 
      time=self.sT, rotation=self.sR, 
      onComplete= function (obj) self:back () end }); 
end

function Triangle:forward ()  
  self.dist = math.random (40,70) * 10;
  transition.to(self.shape, {x=self.shape.x+200,  
    y=self.shape.y+self.dist, time=self.fT, rotation=self.fR, 
    onComplete= function (obj) self:side() end } );
end





--------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
   -----------------------------background--------------------------------
   
   bg = display.newImage ("sky.png"); 
   bg.x = display.contentWidth / 2;          -- Centers bg
   bg.y= display.contentHeight / 2;
   sceneGroup:insert(bg);                    -- Adds bg to sceneGroup
   cube = display.newCircle (display.contentCenterX, display.contentHeight-100, 15);
   physics.addBody (cube, "kinematic");
   cube.HP = 5;
   cube:addEventListener("collision", userDamaged);
   sceneGroup:insert(cube);

   controlBar = display.newRect (display.contentCenterX, display.contentHeight-25, display.contentWidth, 70);
   controlBar:setFillColor(1,1,1,0.5);
   controlBar:addEventListener("touch", move);
   sceneGroup:insert(controlBar);

   scoreText = display.newEmbossedText( "Hit: 0", 70, -10, native.systemFont, 40 );
   scoreText:setFillColor( 0,1,0 );
   sceneGroup:insert(scoreText);
   local color = 
   {
      highlight = {0,1,1},   
      shadow = {0,1,1}  
   }
   scoreText:setEmbossColor( color );

   scoreText.hit = 0;
   hitcnt = 0;

   HPText = display.newEmbossedText( "HP: 5", 240, -10, native.systemFont, 40 );
   HPText:setFillColor( 1,0,0 );
   sceneGroup:insert(HPText);

   Square = Enemy:new( {HP=2, fR=720, fT=700, 
              bT=700} );
   sq = Square:new({xPos=100, yPos=60});

   Triangle = Enemy:new( {HP=3, bR=360, fT=500, 
                 bT=300});
   tr = Triangle:new({xPos=150, yPos=200});
   cnt = 0;

   sq:spawn();
   sq:shoot(1000);

   sceneGroup:insert(sq);

   ceiling = display.newRect (display.contentCenterX, display.contentHeight-455, display.contentWidth, 5);
   ceiling:setFillColor (1,1,1,0.5);
   physics.addBody(ceiling, "static");
   
   tr:spawn();
   tr:forward();

   sceneGroup:insert(tr);



   Runtime:addEventListener("tap", fire)
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

