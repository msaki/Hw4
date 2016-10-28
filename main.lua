--[[local widget = require('widget')
local composer = require('composer')

local function showScene1() -- Brings up the main menu.

   local options = {
      effect = "fade",
      time = 300
   }
   composer.gotoScene("scene1", options)

end]]
local physics = require("physics");
display.setStatusBar( display.HiddenStatusBar )
physics.start();

physics.setGravity(0,0);

local Enemy = require ("Enemy");
local soundTable=require("soundTable");

--showScene1();

local xcent = display.contentWidth/2    -- Center x point
local ycent = display.contentHeight/2   -- Center y point

display.setStatusBar( display.HiddenStatusBar )

function makegame()
  ---- Main Player
  cube = display.newCircle (display.contentCenterX, display.contentHeight-100, 15);
  physics.addBody (cube, "kinematic");
  cube.HP = 5;
  cube:addEventListener("collision", userDamaged);

  controlBar = display.newRect (display.contentCenterX, display.contentHeight-25, display.contentWidth, 70);
  controlBar:setFillColor(1,1,1,0.5);
  controlBar:addEventListener("touch", move);
  Runtime:addEventListener("tap", fire)

  scoreText = display.newEmbossedText( "Hit: 0", 70, -10, native.systemFont, 40 );
  scoreText:setFillColor( 0,1,0 );

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

  sq = Square:new({xPos=100, yPos=200});
  sq:spawn();
  sq:shoot(1000);

  ceiling = display.newRect (display.contentCenterX, display.contentHeight-455, display.contentWidth, 5);
  ceiling:setFillColor (1,1,1,0.5);
  physics.addBody(ceiling, "static");
  
  tr = Triangle:new({xPos=150, yPos=200});
  tr:spawn();
  tr:forward();

  Runtime:addEventListener("tap", fire)

  title:removeSelf();
  nametitle2:removeSelf();
  nametitle:removeSelf();
  startblock:removeSelf();
  start:removeSelf();
end

function beginning() -- Generates the title screen.
   bg = display.newImage ("sky.png"); 
   bg.x = display.contentWidth / 2;          -- Centers bg
   bg.y= display.contentHeight / 2;
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
   start:addEventListener("tap", makegame);
end

beginning();
 -- Generates the title screen.

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
      transition.cancel( cube.shape );
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
      ceiling:removeSelf();

   end      
end

Square = Enemy:new( {HP=2, fR=720, fT=700, bT=700} );

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
Triangle = Enemy:new( {HP=3, bR=360, fT=500, bT=300} );

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




-----------






