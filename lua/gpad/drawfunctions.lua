local rect, mod, setcolor = surface.DrawRect, math.mod, surface.SetDrawColor
local DrawPoly, SetTexture = surface.DrawPoly, surface.SetTexture

function surface.DrawVSDotHorizontal(x, y, len, color)
	setcolor(color or color_white)
		for i = 0, (len / 4 - 1) do
			local k = i * 4
			rect(x + k, y - 2, 1, 1)
			rect(x + k + 2, y, 1, 1)
			rect(x + k, y + 2, 1, 1)
		end
end
