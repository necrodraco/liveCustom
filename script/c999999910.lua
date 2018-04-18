--オルターガイスト・ヘクスティア
--Altergeist Hextia
--Scripted by Eerie Code
--reused by NecroDraco
function c999999910.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999910.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkSummonRule(c,c999999910.matfilter,2,2)
	Auxiliary.AddFakeLinkATKReq(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c999999910.atkval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999910,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c999999910.discon)
	e2:SetCost(c999999910.discost)
	e2:SetTarget(c999999910.distg)
	e2:SetOperation(c999999910.disop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999910,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,999999910)
	e3:SetCondition(c999999910.thcon)
	e3:SetTarget(c999999910.thtg)
	e3:SetOperation(c999999910.thop)
	c:RegisterEffect(e3)
end
function c999999910.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x103) and c:GetBaseAttack()>=0
end
function c999999910.atkval(e,c,tp)
	local lg=Duel.GetMatchingGroup(c999999910.spfilter,tp,LOCATION_MZONE,nil,c,tp):Filter(c999999910.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c999999910.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c999999910.cfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0x103) 
		and g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c999999910.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Duel.GetMatchingGroup(c999999910.spfilter,tp,LOCATION_MZONE,nil,c,tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c999999910.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c999999910.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c999999910.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c999999910.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c999999910.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999999910.thfilter(c)
	return c:IsSetCard(0x103) and c:IsAbleToHand()
end
function c999999910.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999910.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999910.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999910.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c999999910.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x103)
end