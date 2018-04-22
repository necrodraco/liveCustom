--剛鬼ザ・マスター・オーガ
--Gouki The Master Ogre
--Script by nekrozar
--reused by NecroDraco
function c999999933.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999933.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999933.matfilter,2,4)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999933,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetCost(c999999933.discost)
	e1:SetTarget(c999999933.distg)
	e1:SetOperation(c999999933.disop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--attack limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetCondition(c999999933.atcon)
	e3:SetValue(c999999933.atlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e4:SetCondition(c999999933.atcon)
	c:RegisterEffect(e4)
end
function c999999933.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c999999933.costfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0xfc) and g:IsContains(c) and c:IsAbleToHandAsCost()
end
function c999999933.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler()--:GetLinkedGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c999999933.costfilter,tp,LOCATION_MZONE,0,1,nil,lg)
				and Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil)
		else return false end
	end
	e:SetLabel(0)
	local rt=Duel.GetTargetCount(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local cg=Duel.SelectMatchingCard(tp,c999999933.costfilter,tp,LOCATION_MZONE,0,1,rt,nil,lg)
	local ct=cg:GetCount()
	Duel.SendtoHand(cg,nil,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c999999933.disfilter(c,e)
	return ((c:IsFaceup() and not c:IsDisabled()) or c:IsType(TYPE_TRAPMONSTER)) and c:IsRelateToEffect(e)
end
function c999999933.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c999999933.disfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
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
		tc=g:GetNext()
	end
end
function c999999933.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c999999933.atlimit(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	return not tg:IsContains(c) or c:IsFacedown()
end

function c999999933.matfilter(c)
	return c:IsSetCard(0xfc)
end