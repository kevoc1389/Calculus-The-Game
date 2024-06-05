local bump = require 'bump'

local Final_Background = love.graphics.newImage('CalculusTheGameBackground.png')
local Final_Character = love.graphics.newImage('lilMan.png')
local Final_Character_Reversed = love.graphics.newImage('lilManReversed.png')
local Final_Question_1 = love.graphics.newImage('Question1.png')
local Final_Question_2 = love.graphics.newImage('Question2.png')
local Final_Question_3 = love.graphics.newImage('Question3.png')
local Final_Question_4 = love.graphics.newImage('Question4.png')
local Final_Question_5 = love.graphics.newImage('Question5.png')
local Final_Question_6 = love.graphics.newImage('Question6.png')
local Final_Question_7 = love.graphics.newImage('Question7.png')
local Final_Question_8 = love.graphics.newImage('Question8.png')
local Final_RiemannClue = love.graphics.newImage('RiemannClue.jpg')
local chairOfShame = love.graphics.newImage('chairofshame.jpg')
local GameStart = love.graphics.newImage('GameStart.png')
local GameEnd = love.graphics.newImage('GameEnd.png')
local team1389 = love.graphics.newImage('team1389.png')
local shouldLoadWorld = false
local worldLoaded = false
local showBorders = false

local isMovingLeft = false
local shouldDrawSpeechBox = false
local playerInteract = false
local doorKey = false
local safeKey = false
local unlockedTADesk = false
local loadSafeLock = false
local loadTADeskLock = false
local viewingQuestions = false
local questionNumber = 1
local loadRiemann = false
local gameOver = false
local load1389 = false
local loadChairOfShame = false

--Password is 8050, found with Q1 2016 part B. Picture of Bernard Riemann as a clue
local safeComboLock = {0, 0, 0, 0}
local safeComboLockSelectedSlot = 1
local isAtSafe = false

--password is 1389, idk how to make that evident
local TADeskComboLock = {0, 0, 0, 0}
local TADeskComboLockSelectedSlot = 1
local isAtTADesk = false

local speechBoxLocation = 0
local time_per_letter = .01
local time_passed = 0
local current_letter = 0
local displayMessage = ""
local doorLockedMessage = "\nThe door is locked. Maybe Ms.Holloway has hidden a key somewhere..."
local lockedTADeskMessage = "\nThe TA desk has a drawer, but it is locked with a combination lock. Thankfully, our TA is forgetful, \nso he probably wrote the code down somewhere...\n(press r to view lock and t to enter guess)"
local unlockedTADeskMessage = "\nThe TA desk opens with a click. You find a few papers with calculus questions on them.\nYou can tab through these questions by using the left or right arrow key."
local lockedSafeMessage = "\nThere is a small safe on this desk. It is locked with a 4 digit combination lock. You can press 'r' \nto view the combination lock. Press 't' to enter your guess."
local unlockedSafeMessage = "\nThe safe opens with a click, revealing a key inside of the safe. Maybe this key would work for the room's door?" 
local riemannMessage = "\nYou see a picture of a man with a fantastic beard attached to the chalk board."
local team1389Message = "\nYou see a picture of our school's robotics team's logo. Can you remember our team's number? Maybe it's important..."
local chairOfShameMessage = "\nYou see the CHAIR OF SHAME that belongs to those who cheat on exams."


local TAQuestionMessage1 = "\nYou find a note with a calculus problem. It asks you to evaluate the integral from 0 to 1 of the function 3x^2-2x+1. \nYou notice a small number 1 in the corner."
local TAQuestionMessage2 = "\nYou find a note with a calculus problem. It asks you to find the derivative of the function 2x^3-6x^2+5x-1 at x=1. \nYou notice a small number 2 in the corner."
local TAQuestionMessage3 = "\nYou find a note with a calculus problem. It asks you to determine the critical points of the function x^4-8x^3+18x^2-12x. \nYou notice a small number 3 in the corner."
local TAQuestionMessage4 = "\nYou find a note with a calculus problem. It is: We want to fence in a rectangular field. If we look at the field from above, \nthe cost of the vertical sides is $10/ft, the cost of the bottom is $2/ft, and the cost of the top is $7/ft. \nIf we have $700, determine the dimensions of the field that will maximize the enclosed area.. \nYou notice a small number 4 in the corner."

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
  if showBorders then
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
    --purple thing - Fridge?
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

--function for player movement, don't touch as it works perfectly
--Todo: add walking animation (if time permits)
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
  love.graphics.setColor(255,255,255,1)
  if isMovingLeft == true then
    love.graphics.draw(Final_Character_Reversed, player.x-5, player.y-15)
  elseif isMovingLeft == false then
    love.graphics.draw(Final_Character, player.x-5, player.y-15)
  end
  love.graphics.setColor(255,255,255,1)
end

local function drawSpeechBox()
    love.graphics.rectangle('fill', 0, 600-96, 800, 96)
   love.graphics.setColor(0,0,0,255)
   local chars1 = displayMessage:sub(1, current_letter)
   love.graphics.print(chars1, 50, 600-96, 0, 1, 1, 0, 0, 0, 0)
   love.graphics.setColor(255,255,255,1)
end

local function speechUpdate(dt)
    --Room Door
    if player.x > 135 and player.x < 215 and player.y > 105 and player.y < 120 and playerInteract then 
      if doorKey then
        gameOver = true
      end
      displayMessage = doorLockedMessage
      shouldDrawSpeechBox = true
      --TA desk
    elseif player.x > 670 and player.x < 715 and player.y > 120 and player.y < 150 and playerInteract then
      isAtTADesk = true
      if unlockedTADesk then
        displayMessage = unlockedTADeskMessage
      elseif loadTADeskLock then
        displayMessage = "TA Desk Combination Lock: \nSlot 1's value: " .. TADeskComboLock[1] .. ". \nSlot 2's value: " .. TADeskComboLock[2] .. ". \nSlot 3's value: " .. TADeskComboLock[3] .. ". \nSlot 4's value: " .. TADeskComboLock[4] .. ".\nSlot you are currently changing: ".. TADeskComboLockSelectedSlot
      else
       displayMessage = lockedTADeskMessage
      end
      shouldDrawSpeechBox = true
      --Safe Box with Room Key
    elseif player.x > 650 and player.x < 715 and player.y > 280 and player.y < 335 and playerInteract then
      isAtSafe = true
      if doorKey then
        displayMessage = unlockedSafeMessage
      elseif loadSafeLock then
        displayMessage = "Safe Combination Lock: \nSlot 1's value: " .. safeComboLock[1] .. ". \nSlot 2's value: " .. safeComboLock[2] .. ". \nSlot 3's value: " .. safeComboLock[3] .. ". \nSlot 4's value: " .. safeComboLock[4] .. ".\nSlot you are currently changing: ".. safeComboLockSelectedSlot
      else
        displayMessage = lockedSafeMessage
      end
      shouldDrawSpeechBox = true
    elseif player.x > 235 and player.x < 360 and player.y > 135 and player.y < 175 and playerInteract then
      loadRiemann = true
      displayMessage = riemannMessage
      shouldDrawSpeechBox = true
    elseif player.x > 570 and player.x < 645 and player.y > 135 and player.y < 200 and playerInteract then
      load1389 = true
      displayMessage = team1389Message
      shouldDrawSpeechBox = true
    elseif player.x > 80 and player.x < 130 and player.y > 115 and player.y < 175 and playerInteract then
      loadChairOfShame = true
      displayMessage = chairOfShameMessage
      shouldDrawSpeechBox = true
    else
      playerInteract = false
      shouldDrawSpeechBox = false
      isAtSafe = false
      isAtTADesk = false
      loadRiemann = false
      load1389 = false
      loadChairOfShame = false
      time_passed = 0
      current_letter = 0
    end
  time_passed = time_passed + dt
    if time_passed >= time_per_letter then
      time_passed = 0
      current_letter = current_letter + 1
    end
end

local function checkSafeCode()
  if safeComboLock[1] == 8 and safeComboLock[2] == 0 and safeComboLock[3] == 5 and safeComboLock[4] == 0 then
    doorKey = true
    time_passed = 0
    current_letter = 0
  end
end


local function checkTADeskCode()
  if TADeskComboLock[1] == 1 and TADeskComboLock[2] == 3 and TADeskComboLock[3] == 8 and TADeskComboLock[4] == 9 then
    unlockedTADesk = true
    time_passed = 0
    current_letter = 0
  end
end

local function loadQuestions()
  if questionNumber == 1 then
    love.graphics.draw(Final_Question_1, 200, 200)
  elseif questionNumber == 2 then
    love.graphics.draw(Final_Question_2, 200, 200)
  elseif questionNumber == 3 then
    love.graphics.draw(Final_Question_3, 200, 200)
  elseif questionNumber == 4 then
    love.graphics.draw(Final_Question_4, 200, 200)
  elseif questionNumber == 5 then
    love.graphics.draw(Final_Question_5, 200, 200)
  elseif questionNumber == 6 then
    love.graphics.draw(Final_Question_6, 200, 200)
  elseif questionNumber == 7 then
    love.graphics.draw(Final_Question_7, 200, 200)
  elseif questionNumber == 8 then
    love.graphics.draw(Final_Question_8, 200, 200)
  end
end

local function drawRiemann() 
  love.graphics.draw(Final_RiemannClue, 400, 100)
end

local function draw1389()
  love.graphics.draw(team1389, 200, 100)
end

local function drawChairOfShame()
  love.graphics.draw(chairOfShame, 400, 100)
end

local function drawPlayer()
  drawBoxPlayer(player)
end 

function love.update(dt)
  updatePlayer(dt)
  speechUpdate(dt)
end

function love.draw()
  if shouldLoadWorld and gameOver == false then
    love.graphics.draw(Final_Background)
    drawPlayer()
     if showBorders then
      drawBlocks()
      end
    if isAtTADesk and unlockedTADesk then
      loadQuestions()
      end
    if shouldDrawSpeechBox and worldLoaded then
      drawSpeechBox()
      end
    if loadRiemann then
      drawRiemann()
      end
    if load1389 then
      draw1389()
      end
    if loadChairOfShame then
      drawChairOfShame()
    end
  elseif gameOver then
    love.graphics.draw(GameEnd)
  else 
    love.graphics.draw(GameStart)
  end
end

function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  --change
  if k=="space" then  
    shouldLoadWorld = true
    drawWorld()
  end
  if k=="c" then
    showBorders = false
  end
  if k=="v" then
    showBorders = true
  end
  if k=="e" then 
    playerInteract = true
  end
  if k=="down" then
    if isAtSafe then
      if 1 + safeComboLockSelectedSlot > 4 then
        safeComboLockSelectedSlot = 1
      else 
        safeComboLockSelectedSlot = 1 + safeComboLockSelectedSlot
      end 
    
    elseif isAtTADesk then
      if 1 + TADeskComboLockSelectedSlot > 4 then
        TADeskComboLockSelectedSlot = 1
      else 
        TADeskComboLockSelectedSlot = 1 + TADeskComboLockSelectedSlot
      end 
    end
  end
  if k=="up" then
    if isAtSafe then
      if safeComboLockSelectedSlot - 1 < 1 then
        safeComboLockSelectedSlot = 4
      else 
        safeComboLockSelectedSlot = safeComboLockSelectedSlot - 1
      end
    elseif isAtTADesk then
      if TADeskComboLockSelectedSlot - 1 < 1 then
        TADeskComboLockSelectedSlot = 4
      else 
        TADeskComboLockSelectedSlot = TADeskComboLockSelectedSlot - 1
      end 
    end
  end
  if k=="left" then
    if isAtTADesk and unlockedTADesk then
      if questionNumber - 1 < 1 then
        questionNumber = 8
      else
        questionNumber = questionNumber - 1
      end
    elseif isAtSafe then
      if safeComboLock[safeComboLockSelectedSlot] < 1 then
        safeComboLock[safeComboLockSelectedSlot] = 9
      else 
        safeComboLock[safeComboLockSelectedSlot] = safeComboLock[safeComboLockSelectedSlot] - 1
      end
    elseif isAtTADesk then
      if TADeskComboLock[TADeskComboLockSelectedSlot] < 1 then
        TADeskComboLock[TADeskComboLockSelectedSlot] = 9
      else 
        TADeskComboLock[TADeskComboLockSelectedSlot] = TADeskComboLock[TADeskComboLockSelectedSlot] - 1
      end
    end
  end
  if k=="right" then
    if isAtTADesk and unlockedTADesk then
      if questionNumber + 1 > 8 then
        questionNumber = 1
      else
        questionNumber = questionNumber + 1
      end
    elseif isAtSafe then
      if safeComboLock[safeComboLockSelectedSlot] > 8 then
        safeComboLock[safeComboLockSelectedSlot] = 0
      else 
        safeComboLock[safeComboLockSelectedSlot] = safeComboLock[safeComboLockSelectedSlot] + 1
      end
    elseif isAtTADesk then
      if TADeskComboLock[TADeskComboLockSelectedSlot] > 8 then
        TADeskComboLock[TADeskComboLockSelectedSlot] = 0
      else 
        TADeskComboLock[TADeskComboLockSelectedSlot] = TADeskComboLock[TADeskComboLockSelectedSlot] + 1
      end
    end
  end
  if k == "r" then 
    if isAtSafe then
      time_passed = 0
      current_letter = 0
      loadSafeLock = true
    elseif isAtTADesk then
      time_passed = 0
      current_letter = 0
      loadTADeskLock = true
    end
  end
  if k == "t" then
    if isAtSafe then
      checkSafeCode()
    elseif isAtTADesk then
      checkTADeskCode()
    end
  end
end