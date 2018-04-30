--Revendread Evolution
--Scripted by Eerie Code
--reused by Necrodraco
--高等儀式術
function c999999894.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,999999894+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c999999894.target)
	e1:SetOperation(c999999894.activate)
	c:RegisterEffect(e1)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
end
function c999999894.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(c999999894.exfilter0,tp,LOCATION_DECK,0,nil)
		mg:Merge(sg)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c999999894.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c999999894.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c999999894.exfilter0,tp,LOCATION_DECK,0,nil)
	local sg=Duel.GetRitualMaterial(tp)
	mg:Merge(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c999999894.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	mg:Sub(tg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(rc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCondition(c999999894.descon)
		e1:SetOperation(c999999894.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c999999894.filter(c,e,tp,m)
	if not c:IsSetCard(0x106) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	local sg=Group.CreateGroup()
	return mg:IsExists(c999999894.checkRecursive,1,nil,c,tp,sg,mg)
end
function c999999894.exfilter0(c)
	return c:IsSetCard(0x106) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c999999894.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel() and e:GetLabelObject():GetFlagEffect(999999894)~=0
end
function c999999894.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c999999894.checkRecursive(c,rc,tp,sg,mg)
	sg:AddCard(c)
	local res=sg:GetSum(Card.GetRitualLevel,rc)<=rc:GetLevel() 
		and (c999999894.checkGoal(tp,sg,rc) or mg:IsExists(c999999894.checkRecursive,1,sg,rc,tp,sg,mg))
	sg:RemoveCard(c)
	return res
end
function c999999894.checkGoal(tp,sg,rc)
	return sg:GetSum(Card.GetRitualLevel,rc)==rc:GetLevel() --sg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),1,rc:GetLevel(),rc)
		and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		--and aux.ReleaseCheckMMZ(sg,tp)
end