--マギアス・パラディオン
--Magias Palladion
--reused by necrodraco
function c999999887.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999887.matfilter,1,1)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c999999887.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c999999887.atklimit)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999887,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,999999887)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c999999887.thcon)
	e3:SetTarget(c999999887.thtg)
	e3:SetOperation(c999999887.thop)
	c:RegisterEffect(e3)
end
function c999999887.matfilter(c)
	return c:IsFusionSetCard(0x116) and not c:IsCode(999999887)
end
function c999999887.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function c999999887.filter(c)
	return c:IsFaceup() and not c:IsCode(999999887)
end
function c999999887.atkval(e,c)
	local tp = e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c999999887.filter,tp,LOCATION_MZONE,nil,nil,tp) 
	return g:GetSum(Card.GetBaseAttack)
end
function c999999887.atklimit(e,c)
	return e:GetHandler() ~= c
end
function c999999887.thcfilter(c,tp,lg)
	return c:IsControler(tp) and c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c999999887.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(c999999887.filter,tp,LOCATION_MZONE,nil,nil,tp)
	return eg:IsExists(c999999887.thcfilter,1,nil,tp,lg)
end
function c999999887.thfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x116) and c:IsAbleToHand()
end
function c999999887.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999887.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999887.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c999999887.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end

