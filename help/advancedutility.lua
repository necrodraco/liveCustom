--[[
Add the following Lines to your existing utility.lua in live2017 to add these functions. 
Be inform that you need to set ignore_instant_updates to 0 to disable instant updates which will destroy this
]]
function Duel.IsLair(c)
	return c:IsFaceup() and c:IsCode(59160188) and c:IsHasEffect(59160188)
end

function Duel.lairOnField(tp)
	return Duel.IsExistingMatchingCard(Duel.IsLair,tp,LOCATION_ONFIELD,nil,1,nil)
end

function Auxiliary.GetReleaseGroupCost(tp,use_hand)
	local g=Duel.GetReleaseGroup(tp,use_hand)
	if Duel.lairOnField(tp) then
		local op=1
		if tp==1 then op=0 end
		g:Merge(Duel.GetReleaseGroup(op,use_hand))
	end
	return g:Filter(Card.IsReleasable,ex)
end

function Duel.CheckReleaseGroupCost(tp,f,ct,use_hand,specialchk,ex,...)
	local g = aux.GetReleaseGroupCost(tp,use_hand)
	if f~=nil then g=g:Filter(f,ex,table.unpack({...})) end
	return g:GetCount()>=ct
end

function Duel.SelectReleaseGroupCost(tp,f,minc,maxc,use_hand,specialchk,ex,...)
	local g = aux.GetReleaseGroupCost(tp,use_hand)
	if f~=nil then g=g:Filter(f,ex,table.unpack({...})) end
	local gret=Group.CreateGroup()
	local cancleall=true
	local temp=0
	while temp<maxc and cancleall and 0<g:GetCount() do
		local gtemp
		local lair=Duel.lairOnField(tp)
		if lair then
			gtemp=g:Select(tp,0,1,ex)
			if gtemp:GetFirst():IsControler(tp)==false then
				--LoD is reset for the rest of the turn
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				Duel.Hint(HINT_CARD,0,fc:GetCode())
				fc:RegisterFlagEffect(59160188,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
				g=g:Filter(Card.IsControler,nil,tp)
			end
		else
			if temp>0 then maxc=maxc+1 end
			gtemp=g:FilterSelect(tp,Card.IsControler,0,maxc,ex,tp)
		end
		gret:Merge(gtemp)
		g:Sub(gtemp)
		temp=temp+1
		if minc<=temp and temp<maxc and lair then
			cancleall=Duel.SelectYesNo(tp,aux.Stringid(999999983,1))
		end
	end
	return gret
end

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