--[[
Add the following Lines to your existing utility.lua in live2017 to add these functions. 

Or add dofile("expansions/help/advancedutility.lua") a line before pcall(dofile,"init.lua")

Be inform that you need to set ignore_instant_updates to 1 to disable instant updates which will destroy this
]]

function loadutility(file)
	local f1 = loadfile("expansions/help/"..file..".lua")
	local f2 = loadfile("script/"..file..".lua")
	if(f1==nil and f2==nil) then
		Debug.Message("Cannot Load "..file)
	elseif(f1==nil) then
		f2()
		--Debug.Message("Load script "..file)
	else
		f1()
		--Debug.Message("Load helper "..file)
	end
end

loadutility("lair")
loadutility("flink")

--check for Spirit Elimination
function Auxiliary.SpElimFilter(c,mustbefaceup,includemzone)
	--includemzone - contains MZONE in original requirement
	--NOTE: Should only check LOCATION_MZONE+LOCATION_GRAVE
	if c:IsType(TYPE_MONSTER) then
		if mustbefaceup and c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
		if includemzone then return c:IsLocation(LOCATION_MZONE) or not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) end
		if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
			return c:IsLocation(LOCATION_MZONE)
		else
			return c:IsLocation(LOCATION_GRAVE)
		end
	else
		return includemzone or c:IsLocation(LOCATION_GRAVE)
	end
end