local bump = require 'bump'

local Final_Background = love.graphics.newImage('CalculusTheGameBackground.png')
local Final_Character = love.graphics.newImage('lilMan.png')
local Final_Character_Reversed = love.graphics.newImage('lilManReversed.png')
local shouldLoadWorld = false 
local worldLoaded = false 
local showBorders = false

local isMovingLeft = false

local world = bump.newWorld()



function love.load()
   love.graphics.setBackgroundColor( 255, 255, 255 )
end

local blocks = {}

local function addBlock(x,y,w,h)
  local block = {x=x,y=y,w=w,h=h}
  blocks[#blocks+1] = block
  world:add(block, x,y,w,h)
end

local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,0.001)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  if showBorders == true then
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end
  love.graphics.setColor(100,100,100,1)
end

--must be above drawWorld
local player = { x=180,y=120,w=20,h=30, speed = 200}

local function drawWorld()
  if worldLoaded == false then
    world:add(player, player.x, player.y, player.w, player.h)
    --world borders
    addBlock(80,  60, 675, 1)
    addBlock(80,  60,  1, 470)
    addBlock(725, 60,  1, 470)
    addBlock(80,  530, 675, 1)

    --painful part
    --Chalk board
    addBlock(215, 50, 430, 90)
    --purple thing
    addBlock(75, 75, 55, 55)
    --door
    addBlock(130, 60, 85, 50)
    --chair of shame
    addBlock(70, 135, 30, 25)
    --main desk 1
    addBlock(75, 180, 145, 40)
    --desk 1 top chair?
    addBlock(125, 160, 50, 20)
    --desk 1 left chair
    addBlock(80, 220, 50, 35)
    --desk 1 right chair
    addBlock(155, 220, 65, 35)
    --pile of boxes on right side of map
    addBlock(75, 260, 30, 50)
    --tiny box on right side
    addBlock(100, 300, 20, 10)
    --desk 2 main
    addBlock(75, 335, 145, 40)
    --desk 2 top thing left
    addBlock(80, 315, 50, 15)
    --desk 2 top thing right and chair combo bc it works
    addBlock(150, 320, 65, 90)
    --desk 2 left chair
    addBlock(75, 315, 55, 100)
    --bottom left desk left blue thing
    addBlock(75, 425, 45, 35)
    --bottom left desk right blue thing
    addBlock(160, 440,50, 20)
    --bottom left desk
    addBlock(75, 460, 175, 70)
    --desk 3 main
    addBlock(270, 300, 150, 40)
    --desk 3 top left thing
    addBlock(280, 275, 40, 25)
    --desk 3 top right chair
    addBlock(360, 275, 40, 25)
    --desk 3 bottom left chair
    addBlock(270, 340, 65, 35)
    --desk 3 bottom right chair
    addBlock(360, 340, 60, 35)
    --bottom middle desk left blue thing
    addBlock(315, 440, 50, 20)
    --bottom middle desk middle blue thing
    addBlock(400, 420, 45,40)
    --bottom middle desk right blue thing
    addBlock(485, 445, 30, 15)
    --bottom middle desk thing main
    addBlock(295, 460, 235, 70)
    --bottom right desk thing main
    addBlock(570, 460, 150, 70)
    --bottom right desk middle blue thing
    addBlock(615, 445, 45, 15)
    --bottom right desk right blue thing big part
    addBlock(695, 420, 25, 40)
    --bottom right desk right blue thing litte part
    addBlock(685, 445, 10, 15)
    --desk 4 main desk
    addBlock(585, 180, 135, 40)
    --desk 4 left chair
    addBlock(585, 220, 45, 40)
    --desk 4 right chair
    addBlock(665, 220, 55, 35)
    --desk 4 printer?
    addBlock(670, 165, 50, 15)
    --right middle wall thing
    addBlock(695, 255, 25, 40)
    --the thing in the top right corner that will be deemed the TA desk
    addBlock(645, 95, 70, 40)
    --desk 5 main
    addBlock(580, 330, 140, 50)
    --desk 5 right chair
    addBlock(580, 380, 60, 30)
    --desk 5 left chair
    addBlock(665, 380, 55, 30)
    --desk 5 top right thing
    addBlock(675, 320, 45, 15)



    worldLoaded = true
    shouldDrawWorld = true
  end
end

local function drawBlocks()
  for _,block in ipairs(blocks) do
    drawBox(block, 1,0,0)
  end
end

local function updatePlayer(dt)
  local speed = player.speed

  if worldLoaded then
    local dx, dy = 0, 0
    if love.keyboard.isDown('d') then
    	isMovingLeft = false
      dx = speed * dt
    elseif love.keyboard.isDown('a') then
    	isMovingLeft = true
      dx = -speed * dt
    end
    if love.keyboard.isDown('s') then
      dy = speed * dt
    elseif love.keyboard.isDown('w') then
      dy = -speed * dt
    end

    if dx ~= 0 or dy ~= 0 then
      player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    end
  end
end

local function drawBoxPlayer(box)
  love.graphics.setColor(100,100,100,1)
  if isMovingLeft == true then
  	love.graphics.draw(Final_Character_Reversed, player.x-5, player.y-15)
  elseif isMovingLeft == false then
  	love.graphics.draw(Final_Character, player.x-5, player.y-15)
  end
  love.graphics.setColor(100,100,100,1)
end

local function drawPlayer()
  drawBoxPlayer(player)
end	

function love.update(dt)
	updatePlayer(dt)
end

function love.draw()
	if shouldLoadWorld then
		love.graphics.draw(Final_Background)
		drawPlayer()
	end
	if showBorders then
		drawBlocks()
	end
end

function love.keypressed(k)
	if k=="escape" then love.event.quit() end
	--change
	if k=="return" then 
		shouldLoadWorld = true
		drawWorld()
	end
	if k=="c" then
  	showBorders = false
  end
  if k=="v" then
  	showBorders = true
  end
end