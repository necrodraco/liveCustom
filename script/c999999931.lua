--トロイメア・ゴブリン
--Troymare Goblin
--Script by nekrozar
--reused by NecroDraco
function c999999931.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999931.matfilter,2,2,c999999931.lcheck)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999931,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999999931.sumcon)
	e1:SetCost(c999999931.sumcost)
	e1:SetTarget(c999999931.sumtg)
	e1:SetOperation(c999999931.sumop)
	c:RegisterEffect(e1)
	--[[cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c999999931.tgtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)]]
end
function c999999931.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c999999931.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp  and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c999999931.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,999999931)==0 and  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c999999931.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
	--if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetLabel(1)
	--else
		--e:SetLabel(0)
	--end
	local cat=0
	if e:GetLabel()==1 then cat=cat+CATEGORY_DRAW end
	e:SetCategory(cat)
end
function c999999931.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(999999931,1)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if Duel.GetFlagEffect(tp,999999931)~=0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999931,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetLabelObject(c)
	e1:SetCondition(c999999931.sumcon2)
	e1:SetValue(c999999931.sumval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,999999931,RESET_PHASE+PHASE_END,0,1)
end
function c999999931.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsLocation(LOCATION_MZONE)
end
function c999999931.sumval(e,c)
	local c=e:GetLabelObject()
	local sumzone=e--c:GetLinkedZone()
	local relzone=-bit.lshift(1,c:GetSequence())
	return 0,sumzone,relzone
end
--[[function c999999931.tgtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end]]

function c999999931.matfilter(c)
	return c:IsType(TYPE_MONSTER)
end
