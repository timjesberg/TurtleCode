local tArgs = { ... }
if #tArgs ~= 3 then
	print( "Usage: excavate <height>, <width>, <depth>" )
	return
end

height = tonumber(tArgs[1])
width = tonumber(tArgs[2])
depth = tonumber(tArgs[3])



-- Turtle Starting point
yDir = 1
xDir = 1
zDir = 0
facing = "forward"
ascending = "true"
digLevelNumber = 0 -- How far up/down did you move for the next digging level

if width < 1  or height < 1 or depth < 1 then
	print( "All parameters must be positive" )
	return
end

-- Determine if turtle is full
local function collect()	
	local bFull = true
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount == 0 then
			bFull = false
		end
	end
	
	if bFull then
		print( "No empty slots left." )
		return false
	end
	return true
end

-- Return and drop off supplies
local function returnSupplies()
	print("Return supplies called")
end

-- Try to dig and move forward
local function digMoveForward()
	while not turtle.forward() do
		if turtle.detect() then
			if turtle.dig() then
				if not collect() then
					returnSupplies()
				end
			else
				print("Couldn't dig/move forward")
				return false
			end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep(0.5)
		end
	end

	return true
end

-- Try to dig forward
local function digForward()
	while turtle.detect() do
		if turtle.detect() then
			if turtle.dig() then
				if not collect() then
					returnSupplies()
				end
			else
				print("Couldn't dig/move forward")
				return false
			end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep(0.5)
		end
		
		sleep(0.5)
	end

	return true
end

-- Try to dig and move down
local function digMoveDown()
	while not turtle.down() do
		if turtle.detectDown() then
			if turtle.digDown() then
				if not collect() then
					returnSupplies()
				end
			else
				print("Couldn't dig/move forward")
				return false
			end
		elseif turtle.attackDown() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep(0.5)
		end
	end

	return true
end

-- Try to dig down
local function digDown()
	while turtle.detectDown() do
		if turtle.detectDown() then
			if turtle.digDown() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attackDown() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep(0.5)
		end
		
		sleep(0.5)
	end

	return true
end

-- Try to dig and move up
local function digMoveUp()
	while not turtle.up() do
		if turtle.detectUp() then
			if turtle.digUp() then
				if not collect() then
					returnSupplies()
				end
			else
				print("Couldn't dig/move forward")
				return false
			end
		elseif turtle.attackUp() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep(0.5)
		end
	end

	return true
end

-- Try to dig up
local function digUp()
	while turtle.detectUp() do
		if turtle.detectUp() then
			if turtle.digUp() then
				if not collect() then
					returnSupplies()
				end
			else
				print("digUp returned false")
				return false
			end
		elseif turtle.attackUp() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
		
	sleep( 0.5 )
	end

	return true
end

local function turnLeft()
	turtle.turnLeft()
	if facing == "right" then
		facing = "forward"
	elseif facing == "forward" then
		facing = "left"
	elseif facing == "left" then
		facing = "backward"
	else
		facing = "right"
	end
end

local function turnRight()
	turtle.turnRight()
	if facing == "right" then
		facing = "backward"
	elseif facing == "backward" then
		facing = "left"
	elseif facing == "left" then
		facing = "forward"
	else
		facing = "right"
	end
end

-- Digging Jobs --
local function dig_oneByone() 
	digMoveForward()
end

local function dig_oneBytwo() 
	digMoveForward()
	turnRight()
	digForward()
	turnLeft()
end

local function dig_oneBythree()
	if xDir == 1 then
		digMoveForward()
		turnRight()
		digMoveForward()
		digForward()
		turnLeft()
		xDir = xDir + 1
	else
		digMoveForward()
		turnRight()
		digForward()
		turnLeft()
		turnLeft()
		digForward()
		turnRight()
	end
end

local function dig_twoByone()
	digMoveForward()
	digUp()
end

local function dig_twoBytwo()
	if yDir == 1 then
		digMoveForward()
		turnRight()
		digForward()
		digMoveUp()
		digForward()
		turnLeft()
		yDir = yDir + 1
	else
		digMoveForward()
		turnRight()
		digForward()
		digMoveDown()
		digForward()
		turnLeft()
		yDir = yDir - 1
	end
end

local function dig_twoBythree()
	if xDir == 1 then
		digMoveForward()
		digUp()
		turnRight()
		digMoveForward()
		digUp()
		digMoveForward()
		digUp()
		turnLeft()
		xDir = xDir + 2
	elseif xDir == 3 then
		digMoveForward()
		digUp()
		turnLeft()
		digMoveForward()
		digUp()
		digMoveForward()
		digUp()
		turnRight()
		xDir = xDir - 2
	end
end

local function dig_threeByone()
	if yDir == 1 then
		digMoveForward()
		digMoveUp()
		digUp()
		yDir = yDir + 1
	else
		digMoveForward()
		digUp()
		digDown()
	end
end

local function dig_threeBytwo()
	if yDir == 1 and xDir == 1 then
		digMoveForward()
		digMoveUp()
		digUp()
		turnRight()
		digMoveForward()
		digUp()
		digDown()
		turnLeft()
		yDir = yDir + 1
		xDir = xDir + 1
	elseif yDir == 2 and xDir == 2 then
		digMoveForward()
		digUp()
		digDown()
		turnLeft()
		digMoveForward()
		digUp()
		digDown()
		turnRight()
		xDir = xDir - 1
	else
		digMoveForward()
		digUp()
		digDown()
		turnRight()
		digMoveForward()
		digUp()
		digDown()
		turnLeft()
		xDir = xDir + 1
	end
end

local function faceForward()
	if facing == "left" then
		turnRight()
	elseif facing == "right" then
		turnLeft()
	elseif facing == "backward" then
		turnRight()
		turnRight()
	end
end

local function faceBackward()
	if facing == "left" then
		turnLeft()
	elseif facing == "right" then
		turnRight()
	elseif facing == "forward" then
		turnRight()
		turnRight()
	end
end

local function faceLeft()
	if facing == "forward" then
		turnLeft()
	elseif facing == "backward" then
		turnRight()
	elseif facing == "right" then
		turnRight()
		turnRight()
	end
end

local function faceRight()
	if facing == "forward" then
		turnRight()
	elseif facing == "backward" then
		turnLeft()
	elseif facing == "left" then
		turnRight()
		turnRight()
	end
end

local function moveDownXDir() 
	print("move down xDir")
	faceLeft()
	for n=xDir,1,-1 do 
		if turtle.forward() then
			xDir = xDir - 1
		else
			break
		end
	end
end

local function moveUpXDir()
	print("move up xDir")
	faceRight()
	for n=1,width do 
		if turtle.forward() then
			xDir = xDir + 1
		else
			break
		end
	end
end

local function moveDownYDir()
	print("move down yDir")
	for n=yDir,2,-1 do
		if turtle.down() then 
			yDir = yDir - 1
		else
			break
		end
	end
end

local function moveUpYDir()
	print("move up yDir")
	for n=yDir,height-1 do
		if turtle.up() then
			yDir = yDir + 1
		else
			break
		end
	end
end

local function moveDownZDir()
	print("move down zDir")
	faceBackward()
	for n=zDir,1,-1 do 
		if turtle.forward() then 
			zDir = zDir - 1
		else
			break
		end
	end
end

local function moveUpZDir()
	print("move up zDir")
	faceForward()
	for n=1,depth do
		if turtle.forward() then
			zDir = zDir + 1
		else
			break
		end
	end
end

local function moveToAStartPoint()
	print("Move to a start point")
	moveUpZDir()

	-- if the turtle is not at either end of xDir then we need to move to an end
	if not (xDir == 1 or xDir == width) then
		-- Figure out which end the turtle is closer too
		if xDir - 1 < width - xDir then
			-- turtle is closer to the left end
			moveDownXDir()
			faceRight()
		else
			--turtle is closer to the right end
			moveUpXDir()
			faceLeft()
		end
	end
	
	-- If turtle is not at 2 or height - 1 then we need to move towards top or bottom
	if height > 2 then
		if not (yDir == 2 or yDir == height - 1) then
			-- Figure out which end the turtle is closer too
			if yDir - 2 < height - 1 - yDir then
				-- turtle is closer to the bottom
				if yDir == 1 then
					turtle.up()
					if xDir == 1 then
						faceRight()
					elseif xDir == width then
						faceLeft()
					end
				else
					moveDownYDir()
					if xDir == 1 then
						faceRight()
					elseif xDir == width then
						faceLeft()
					end
				end
			else
				-- turtle is closer to the top
				if yDir == height then
					turtle.down()
					if xDir == 1 then
						faceRight()
					elseif xDir == width then
						faceLeft()
					end
				else
					moveUpYDir()
					if xDir == 1 then
						faceRight()
					elseif xDir == width then
						faceLeft()
					end
				end
			end
		end
	end
end

local function moveUpToNextDiggingLevel()
	print("Move up to next digging level")
	digLevelNumber = 0
	for n=1,3 do
		if yDir < height - 1 then
			turtle.up()
			yDir = yDir + 1
			digLevelNumber = digLevelNumber + 1
		else
			break
		end
	end	
end

local function moveDownToNextDiggingLevel()
	print("Move down to next digging level")
	digLevelNumber = 0
	for n=1,3 do
		if yDir > 2 then
			turtle.down()
			yDir = yDir - 1
			digLevelNumber = digLevelNumber + 1
		else
			break
		end
	end	
end

if turtle.getFuelLevel() < 1 then
	print( "Out of Fuel" )
	return
end

print( "Tunnelling..." )

for n=1,depth do
	if height * width <= 6 then
		if height == 1 then
			if width == 1 then
				dig_oneByone()
			elseif width == 2 then
				dig_oneBytwo()
			elseif width == 3 then
				dig_oneBythree()
			end
		elseif height == 2 then
			if width == 1 then
				dig_twoByone()
			elseif width == 2 then
				dig_twoBytwo()
			elseif width == 3 then
				dig_twoBythree()
			end
		elseif height == 3 then
			if width == 1 then
				dig_threeByone()
			elseif width == 2 then
				dig_threeBytwo()
			end
		end	
	else
		print("Entering new tunnelling algorithm")
		moveToAStartPoint()
		print("Initial forward move")
		if facing == "right" then 
			turnLeft()
			digMoveForward()
			turnRight()
		elseif facing == "left" then
			turnRight()
			digMoveForward()
			turnLeft()
		elseif facing == "forward" then
			digMoveForward()
		end
		print(facing)
		if (height == 1) or (yDir == height) then 
			print("First if")
			for n=1,width do
				digMoveForward()
				xDir = xDir + 1
			end
		elseif (height == 2) or (digLevelNumber == 2 or digLevelNumber == 1) then
			print("Second if")
			for n=1,width do
				dig_oneBytwo()
				xDir = xDir + 1
			end
		elseif (height >= 3) or (digLevelNumber == 3) then 
			print("Third if")
			digUp()
			digDown()
			if ascending == "true" then
				print("ascending")
				while yDir <= height - 1 and zDir < depth do
					print("ascending while")
					if facing == "right" then 
						for n=1,width do
							digMoveForward()
							digUp()
							digDown()
							xDir = xDir + 1
						end
						turnLeft()
						turnLeft()
						moveUpToNextDiggingLevel()
					elseif facing == "left" then
						for n=width,1,-1 do
							digMoveForward()
							digUp()
							digDown()
							xDir = xDir - 1
						end
						turnRight()
						turnRight()
						moveUpToNextDiggingLevel()
					end
				end
				ascending = "false"
			else --descending
				print("descending")
				while yDir >= 2 and zDir < depth do
					print("descending while")
					if facing == "right" then 
						for n=1,width do
							digMoveForward()
							digUp()
							digDown()
							xDir = xDir + 1
						end
						turnLeft()
						turnLeft()
						moveDownToNextDiggingLevel()
					elseif facing == "left" then
						for n=width,1,-1 do
							digMoveForward()
							digUp()
							digDown()
							xDir = xDir - 1
						end
						turnRight()
						turnRight()
						moveDownToNextDiggingLevel()
					end
				end
				ascending = "true"
			end
		end
	end
	zDir = zDir + 1
end