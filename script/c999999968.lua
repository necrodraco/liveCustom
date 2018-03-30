--悪魔嬢リリス
--Lilith, Lady of Lament
--Scripted by Eerie Code
--reused by necrodraco
function c999999968.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1000)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999999968.atkcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,999999968)
	e2:SetCost(c999999968.thcost)
	e2:SetTarget(c999999968.thtg)
	e2:SetOperation(c999999968.thop)
	c:RegisterEffect(e2)
end
function c999999968.atkcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c999999968.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c999999968.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c999999968.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c999999968.thfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c999999968.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c999999968.thfilter,tp,LOCATION_DECK,0,3,nil) end
end
function c999999968.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999999968.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local tg=sg:Select(1-tp,1,1,nil)
		Duel.SSet(tp,tg:GetFirst())
	end
end
function c999999968.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)-- and c:IsAttackAbove(1500)
		--and Duel.IsExistingMatchingCard(c29876529.dfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,c)
end