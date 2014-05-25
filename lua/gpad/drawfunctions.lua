local rect, mod, setcolor = surface.DrawRect, math.mod, surface.SetDrawColor
local cos, sin, rad, DrawPoly, SetTexture = math.cos, math.sin, math.rad, surface.DrawPoly, surface.SetTexture

function surface.DrawVSDotHorizontal(x, y, len, color)
	setcolor(color or color_white)
		for i = 0, len do
			local add = mod(i, 4) ~= 0 and 1 or 0
		
			rect(x + i + add, y - 2, 1, 1)
			rect(x + i + add + 2, y, 1, 1)
			rect(x + i + add, y + 2, 1, 1)
		end
end