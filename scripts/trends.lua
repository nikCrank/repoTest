--[[
Copyright 2013, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

local startx = 0
local starty = 150
local amplitude = 60
local freq = 30
local incx = 0
local incy = 0
local max_idx = 560 --[280
local cur_w_idx = 1
local wrapped = 0 
local cur_rad = 0
local x = {}
local y = {}

function change_freq(mapargs)
	freq = freq + mapargs.frequency
	amplitude = amplitude + mapargs.amplitude
	if (freq  < 1) then
		freq = 1
	end
	if (amplitude  < 0) then
		amplitude = 0
	end		
end

function draw_trend(mapargs)
	local points
	local v = {}
	local iter
	local points = ""
	local radinc
	local theta
	
	-- Use a circular buffer to keep points in a sin wave, adjusting position in screen
	-- and then change points into a polygon string  
	if cur_w_idx > max_idx then
		cur_w_idx = 1
		wrapped = 1
	end		
	
	--frequency calcuated as increments need to reach 2 pi.
	radinc = 6.283185/freq
	
	if cur_rad > 6.283185 then
		cur_rad = cur_rad - 6.283185
	end
	
	-- get sin value at current pos, magnify to match amplitude
	tmp = math.sin(cur_rad)	
	tmp = tmp * amplitude			
	y[cur_w_idx] = math.floor(tmp) + incy + starty
	
	iter = cur_w_idx
	
	points = {}
	
	while (iter > 0) do
		newstr = string.format("%d:%d", max_idx - (cur_w_idx-iter) - 1, y[iter])
		table.insert(points, newstr)
		iter = iter -1
	end
	
	-- Gone around once so now fill in the old point data
	if (wrapped == 1) then
		iter = max_idx		
		
		while (iter > cur_w_idx) do		
			newstr = string.format("%d:%d", iter - cur_w_idx - 1, y[iter])
			table.insert(points, newstr)
			iter = iter -1
		end
	else
		-- extend to start of trend window for a flat line 
		if (cur_w_idx < max_idx) then 
			newstr = string.format(" %d:%d",startx,starty)		
			table.insert(points, newstr)
		end
	end

	cur_w_idx = cur_w_idx + 1

	cur_rad = cur_rad + radinc
	
	v["trendpoly_1"] = table.concat(points, " ")
	
	gre.set_data(v)
end