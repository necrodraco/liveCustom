--Wrapper-Functions to make the lair of darkness card workable under Android and 1.033.D

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
	local g = Auxiliary.GetReleaseGroupCost(tp,use_hand)
	if f~=nil then g=g:Filter(f,ex,table.unpack({...})) end
	return g:GetCount()>=ct
end

function Duel.SelectReleaseGroupCost(tp,f,minc,maxc,use_hand,specialchk,ex,...)
	local g = Auxiliary.GetReleaseGroupCost(tp,use_hand)
	if f~=nil then g=g:Filter(f,ex,table.unpack({...})) end
	local gret=Group.CreateGroup()
	local cancleall=true
	local temp=0
	while temp<maxc and cancleall and 0<g:GetCount() do
		local gtemp
		local lair=Duel.lairOnField(tp)
		if lair then
			gtemp=g:Select(tp,1,1,ex)
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