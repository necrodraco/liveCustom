--暴走召喚師アレイスター
--Aleister the Meltdown Invoker
--reused by NecroDraco
function c999999912.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999912.matfilter,2,2,c999999912.spcheck)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(86120751)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999912,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c999999912.thcon)
	e2:SetTarget(c999999912.thtg)
	e2:SetOperation(c999999912.thop)
	c:RegisterEffect(e2)	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999912,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c999999912.thcon2)
	e3:SetTarget(c999999912.thtg2)
	e3:SetOperation(c999999912.thop2)
	c:RegisterEffect(e3)
end
function c999999912.spcheck(g,lc,tp)
	return g:GetClassCount(Card.GetRace,lc,SUMMON_TYPE_FUSION,tp)>1 and g:GetClassCount(Card.GetAttribute,lc,SUMMON_TYPE_FUSION,tp)>1
end
function c999999912.thcfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c999999912.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c999999912.thcfilter,1,nil,tp)
end
function c999999912.thfilter(c)
	return (c:IsCode(74063034) or c:IsCode(458748)) and c:IsAbleToHand()
end
function c999999912.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
 		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c999999912.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999912.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        	local g=Duel.SelectMatchingCard(tp,c999999912.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c999999912.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT))	and c:IsPreviousPosition(POS_FACEUP)
end
function c999999912.thfilter2(c)
	return c:IsCode(47457347) and c:IsAbleToHand()
end
function c999999912.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999912.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999912.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999912.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999999912.matfilter(c)
	return c:IsType(TYPE_MONSTER)
end