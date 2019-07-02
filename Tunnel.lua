local tArgs = { ... }
if #tArgs ~= 3 then
	print( "Usage: excavate <width>, <height>, <depth>" )
	return
end

width = tonumber(tArgs[1])
height = tonumber(tArgs[2])
depth = tonumber(tArgs[3])

-- Turtle Starting point
yDir = 1
xDir = 1
zDir = 1

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
	while not turtle.detect() do
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
end

local function turnRight()
	turtle.turnRight()
end

-- Digging Jobs --
local function dig_oneByone() 
	digMoveForward()
end

local function dig_oneBytwo() 
	turnRight()
	digForward()
	turnLeft()
	digMoveForward()
end

local function dig_oneBythree()
	if xDir == 1 then
		turnRight()
		digMoveForward()
		digForward()
		turnLeft()
		digMoveForward()
		xDir = xDir + 1
	else
		turnRight()
		digForward()
		turnLeft()
		turnLeft()
		digForward()
		turnRight()
		digMoveForward()
	end
end

local function dig_twoByone()
	digUp()
	digMoveForward()
end

local function dig_twoBytwo()
	if yDir == 1 then
		turnRight()
		digForward()
		digMoveUp()
		digForward()
		turnLeft()
		digMoveForward()
		yDir = yDir + 1
	else
		turnRight()
		digForward()
		digMoveDown()
		digForward()
		turnLeft()
		digMoveForward()
		yDir = yDir - 1
	end
end

local function dig_twoBythree()
	if yDir == 1 and xDir == 1 then
		digUp()
		turnRight()
		digMoveForward()
		digUp()
		digMoveForward()
		digUp()
		turnLeft()
		digMoveForward()
		xDir = xDir + 2
	elseif yDir == 3 and xDir == 3 then
		digUp()
		turnLeft()
		digMoveForward()
		digUp()
		digMoveForward()
		digUp()
		turnRight()
		digMoveForward()
		xDir = xDir - 2
	end
end

local function dig_threeByone()
	if yDir == 1 then
		digMoveUp()
		digUp()
		digMoveForward()
		yDir = yDir + 1
	else
		digUp()
		digDown()
		digMoveForward()
	end
end

local function dig_threeBytwo()
	if yDir == 1 and xDir == 1 then
		digMoveUp()
		digUp()
		turnRight()
		digMoveForward()
		digUp()
		digDown()
		turnLeft()
		digMoveForward()
		yDir = yDir + 1
		xDir = xDir + 1
	elseif yDir == 2 and xDir == 2 then
		digUp()
		digDown()
		turnLeft()
		digMoveForward()
		digUp()
		digDown()
		turnRight()
		digMoveForward()
		xDir = xDir - 1
	else
		digUp()
		digDown()
		turnRight()
		digMoveForward()
		digUp()
		digDown()
		turnLeft()
		digMoveForward()
		xDir = xDir + 1
	end
end

if turtle.getFuelLevel() < 1 then
	print( "Out of Fuel" )
	return
end

print( "Tunnelling..." )

-- Will eventually need a 3D recursive sorting algorithm to break
-- down arbitrary tunnelling sizes into these small digging jobs.
-- Since the jobs are sorted, the pathing algorithm from one job 
-- to the next should be fairly straighforward.

-- For testing digging jobs
for n=1,depth do
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
end

