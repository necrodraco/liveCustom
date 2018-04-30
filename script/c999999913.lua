--アロマセラフィ－ジャスミン
--Aromaseraphy Jasmine
--Scripted by Eerie Code
--reused by NecroDraco
function c999999913.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999913.matfilter,2,2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c999999913.indcon)
	e1:SetTarget(c999999913.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4709881,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,999999913)
	e2:SetCost(c999999913.spcost)
	e2:SetTarget(c999999913.sptg)
	e2:SetOperation(c999999913.spop1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c999999913.thcon)
	e3:SetTarget(c999999913.thtg)
	e3:SetOperation(c999999913.thop)
	c:RegisterEffect(e3)
end
function c999999913.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c999999913.indtg(e,c)
	return e:GetHandler()==c or (c:IsRace(RACE_PLANT))
end
function c999999913.cfilter(c)
	return true--g:IsContains(c)
end
function c999999913.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler()--:GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c999999913.cfilter,1,lg) end
	local g=Duel.SelectReleaseGroup(tp,c999999913.cfilter,1,1,lg)
	Duel.Release(g,REASON_COST)
end
function c999999913.spfilter1(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c999999913.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c999999913.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c999999913.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999999913.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c999999913.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c999999913.thfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function c999999913.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999913.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999913.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c999999913.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_PLANT,scard,sumtype,tp)
end