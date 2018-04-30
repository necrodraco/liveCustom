--トリックスター・デビルフィニウム
--Trickstar Delfiendium
--reused by NecroDraco
function c999999938.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999938.matfilter,2,3)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c999999938.thcon)
	e1:SetTarget(c999999938.thtg)
	e1:SetOperation(c999999938.thop)
	c:RegisterEffect(e1)
end
function c999999938.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb)
end
function c999999938.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsExists(c999999938.lkfilter,1,nil)
end
function c999999938.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb) and c:IsAbleToHand()
end
function c999999938.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c999999938.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999938.filter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_FUSION)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_FUSION)
	local g=Duel.SelectTarget(tp,c999999938.filter,tp,LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c999999938.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			e1:SetValue(ct*1000)
			c:RegisterEffect(e1)
		end
	end
end

function c999999938.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0xfb)
end