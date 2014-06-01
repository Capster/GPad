function math.RoundToNearest(num, point)
	num = math.Round(num)
	local possible = {min=0, max=0}
	for i=1, point do
		if math.IsDivisible(num+i, point) then
			possible.max = num+i
		end
		if math.IsDivisible(num-i, point) then
			possible.min = num-i
		end
	end
	
	if possible.max - num <= num - possible.min then
		return possible.max
	else
		return possible.min
	end
	
end

function math.IsDivisible(divisor, dividend)
	return math.fmod(divisor, dividend) == 0
end