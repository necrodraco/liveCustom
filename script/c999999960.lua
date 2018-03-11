--剣闘獣ドラガシス
--Gladiator Beast Dragacius
--Scripted by Eerie Code
--reused by NecroDraco
function c999999960.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999960.matfilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999960.spcon)
	e7:SetOperation(c999999960.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c999999960.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c999999960.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c999999960.aclimit)
	e2:SetCondition(c999999960.actcon)
	c:RegisterEffect(e2)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(999999960,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,999999960)
	e6:SetCondition(c999999960.spcon)
	e6:SetCost(c999999960.spcost)
	e6:SetTarget(c999999960.sptg)
	e6:SetOperation(c999999960.spop)
	c:RegisterEffect(e6)
end
function c999999960.indtg(e,c)
	return c:IsSetCard(0x19) and Duel.GetAttacker()==c
end
function c999999960.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c999999960.actcon(e)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc:IsSetCard(0x19)
end
function c999999960.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c999999960.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c999999960.spfilter(c,e,tp)
	return c:IsSetCard(0x19) and c:IsCanBeSpecialSummoned(e,125,tp,false,false)
end
function c999999960.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		local g=Duel.GetMatchingGroup(c999999960.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c999999960.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c999999960.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=2 and g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:Select(tp,1,1,nil)
		local tc1=sg1:GetFirst()
		g:Remove(Card.IsCode,nil,tc1:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,1,1,nil)
		local tc2=sg2:GetFirst()
		sg1:Merge(sg2)
		Duel.SpecialSummonStep(tc1,125,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,125,tp,tp,false,false,POS_FACEUP)
		tc1:RegisterFlagEffect(tc1:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
		tc2:RegisterFlagEffect(tc2:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
		Duel.SpecialSummonComplete()
	end
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999960.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x19)
end
function c999999960.spfilter(c,fc)
	return c999999960.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999960.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999999960.spfilter,2,nil,c)
end
function c999999960.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999960.spfilter,2,2,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function c999999960.target(e,c)
	return c:GetCode() == 999999960
end