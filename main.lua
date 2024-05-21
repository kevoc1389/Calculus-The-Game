local bump = require 'bump'

local Final_Background = love.graphics.newImage('CalculusTheGameBackground.png')
local Final_Character = love.graphics.newImage('lilMan.png')
local Final_Character_Reversed = love.graphics.newImage('lilManReversed.png')
local shouldLoadWorld = false 
local worldLoaded = false 

local isMovingLeft = false

local world = bump.newWorld()



function love.load()
   love.graphics.setBackgroundColor( 255, 255, 255 )
end

local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,0.001)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

local blocks = {}

local function addBlock(x,y,w,h)
  local block = {x=x,y=y,w=w,h=h}
  blocks[#blocks+1] = block
  world:add(block, x,y,w,h)
end
--must be above drawWorld
local player = { x=180,y=120,w=20,h=30, speed = 300 }

local function drawWorld()
  if worldLoaded == false then
    world:add(player, player.x, player.y, player.w, player.h)
    --world borders
    addBlock(80,  60, 675, 1)
    addBlock(80,  60,  1, 470)
    addBlock(725, 60,  1, 470)
    addBlock(80,  530, 675, 1)

    --painful part
    addBlock(215, 50, 510, 90)
    addBlock(75, 75, 55, 60)
    addBlock(130, 60, 85, 50)
    addBlock(70, 135, 30, 25)
    worldLoaded = true
    shouldDrawWorld = true
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
  	love.graphics.draw(Final_Character_Reversed, player.x-10, player.y-15)
  elseif isMovingLeft == false then
  	love.graphics.draw(Final_Character, player.x-10, player.y-15)
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
end

function love.keypressed(k)
	if k=="escape" then love.event.quit() end
	--change
	if k=="return" then 
		shouldLoadWorld = true
		drawWorld()
	end
end