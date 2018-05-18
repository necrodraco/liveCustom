--アークロード・パラディオン
--Arch-lord Palladion
--Scripted by Eerie Code
--reused by necrodraco
function c999999889.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,3,c999999889.lcheck,1)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c999999889.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c999999889.atklimit)
	c:RegisterEffect(e2)
	--negate effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999889,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c999999889.discost)
	e3:SetTarget(c999999889.distg)
	e3:SetOperation(c999999889.disop)
	c:RegisterEffect(e3)
end
function c999999889.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function c999999889.filter(c)
	return c:IsFaceup() and not c:IsCode(999999889)
end
function c999999889.atkval(e,c)
	local tp = e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c999999889.filter,tp,LOCATION_MZONE,nil,nil,tp)
	return g:GetSum(Card.GetBaseAttack)
end
function c999999889.atklimit(e,c)
	return e:GetHandler() ~= c
end
function c999999889.disfilter(c,e)
	return aux.disfilter1(c) and c:IsCanBeEffectTarget(e)
end
function c999999889.cfilter(c,tg,lg)
	return (c:IsSetCard(0xfe) or c:IsSetCard(0x116)) and lg:IsContains(c)
end
function c999999889.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c999999889.disfilter,tp,0,LOCATION_ONFIELD,nil,e)
	local tp = e:GetHandlerPlayer()
	local lg=Duel.GetMatchingGroup(c999999889.filter,tp,LOCATION_MZONE,nil,nil,tp)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c999999889.cfilter,1,false,aux.ReleaseCheckTarget,nil,tg,lg) end
	local g=Duel.SelectReleaseGroupCost(tp,c999999889.cfilter,1,1,false,aux.ReleaseCheckTarget,nil,tg,lg)
	Duel.Release(g,REASON_COST)
end
function c999999889.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c999999889.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end

