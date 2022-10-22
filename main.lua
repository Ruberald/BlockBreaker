function love.load()
	
	window_x = love.graphics.getWidth()
	window_y = love.graphics.getHeight()

	def_bar_x = 20
	def_bar_y = window_y - 50
	bar_x = def_bar_x
	bar_y = def_bar_y
	barspeed_x = 200
	barsize = {80, 20}

	ballradius = 15
	def_ball_x = bar_x + barsize[1]/2
	def_ball_y = bar_y - ballradius
	ball_x = def_ball_x
	ball_y = def_ball_y
	ballspeed_x = 200
	ballspeed_y = -200

	blocks = {}
	noblocks = 10
	blocksize = {80, 40}
	brokenblocks = 0
	setblocks()
	-- local r = (window_x - blocksize[1])/blocksize[1]
	-- math.randomseed( os.time() )
	-- for i=1, noblocks, 1 do
	-- 	local x = math.random(0, r)
	-- 	table.insert(blocks, {x*blocksize[1], math.random(0, 3)*blocksize[2], true})
	-- end
	-- brokenblocks = 0

	lost = false
	won = false
end

function setblocks()
	blocks = {}
	local r = (window_x - blocksize[1])/blocksize[1]
	math.randomseed( os.time() )
	for i=1, noblocks, 1 do
		local x = math.random(0, r)
		table.insert(blocks, {x*blocksize[1], math.random(0, 3)*blocksize[2], true})
	end
	brokenblocks = 0	
end

function love.update(dt)
	
	if bar_x > (window_x-barsize[1]) then
		bar_x = window_x-barsize[1]
	elseif bar_x < 0 then
		bar_x = 0
	else
		if love.keyboard.isDown('d') then
	        bar_x = bar_x + barspeed_x*dt
	    end

	    if love.keyboard.isDown('a') then
	    	bar_x = bar_x - barspeed_x*dt
	    end
	end

	if ball_x > (window_x-ballradius) then
		ball_x = (window_x-ballradius)
		ballspeed_x = -ballspeed_x
	elseif ball_x < 0 then
		ball_x = 0
		ballspeed_x = -ballspeed_x
	elseif ball_y < 0 then
		ball_y = 0
		ballspeed_y = -ballspeed_y
	elseif (ball_x > bar_x 
		and ball_x < (bar_x + barsize[1]) 
		and ball_y > (bar_y - barsize[2])
		and lost == false) then
		ball_y = (bar_y - barsize[2])
		ballspeed_y = -ballspeed_y
	elseif ball_y > window_y + 20 then
		ballspeed_x, ballspeed_y = 0, 0
		lost = true
		if love.keyboard.isDown('return') then
			-- ball_x, ball_x = def_ball_x, def_ball_y
		 --    bar_x, bar_y = def_bar_x, def_bar_y
		 --    ballspeed_x, ballspeed_y = 200, -200
		 --    lost = false
		 	reset()
		end
	else
		ball_x, ball_y = ball_x + ballspeed_x*dt, ball_y + ballspeed_y*dt
	end

	local number = #blocks
	print(number)
	for i=1, number, 1 do
		if (ball_x > blocks[i][1]
		and ball_x < (blocks[i][1]+blocksize[1])
		and ball_y > blocks[i][2]
		and ball_y < (blocks[i][2]+blocksize[2])) then
			table.remove(blocks, i)
			brokenblocks = (brokenblocks+1)
			ballspeed_y = -ballspeed_y
			break
		end
	end

	if brokenblocks == noblocks then 
		ballspeed_x, ballspeed_y = 0, 0
		won = true 
		if love.keyboard.isDown('return') then
			-- ball_x, ball_x = def_ball_x, def_ball_y
		 --    bar_x, bar_y = def_bar_x, def_bar_y
		 --    ballspeed_x, ballspeed_y = 200, -200
		    brokenblocks = 0
		 --    won = false
		 	reset() 
		end
	end
end

function reset()
	bar_x, bar_y = def_bar_x, def_bar_y
    ball_x, ball_y = def_ball_x, def_ball_y
    ballspeed_x, ballspeed_y = 200, -200
    setblocks()
    lost = false
    won = false
end


function love.draw()
	love.graphics.rectangle( "fill", bar_x, bar_y, barsize[1], barsize[2], 3, 3)
	love.graphics.circle("fill", ball_x, ball_y, ballradius)

	for i=1, #blocks, 1 do
		-- if blocks[i][3] == true then
		love.graphics.rectangle( "line", blocks[i][1], blocks[i][2], blocksize[1], blocksize[2])
		-- end
	end

	if lost then
		love.graphics.clear()
		love.graphics.print("You lost, Press enter to start again", window_x/2-160, window_y/2, 0, 1.5, 1.5)
	end

	if won then
		love.graphics.clear()
		love.graphics.print("You Won!, Press enter to start again", window_x/2-160, window_y/2, 0, 1.5, 1.5)
	end
end