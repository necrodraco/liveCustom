--天球の聖刻印
--Hieratic Seal of the Celestial Spheres
--Scripted by Eerie Code
--reused by NecroDraco
function c999999973.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999973.matfilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999973.spcon)
	e7:SetOperation(c999999973.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c999999973.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999973,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c999999973.thcon)
	e1:SetCost(c999999973.thcost)
	e1:SetTarget(c999999973.thtg)
	e1:SetOperation(c999999973.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999973,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,999999973)
	e2:SetTarget(c999999973.sptg)
	e2:SetOperation(c999999973.spop)
	c:RegisterEffect(e2)
end
function c999999973.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c999999973.thcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c999999973.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c999999973.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c999999973.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999973.thcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c999999973.thcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c999999973.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function c999999973.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999973.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c999999973.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999999973.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999999973.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c999999973.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999999973.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end

--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999973.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_DRAGON,scard,sumtype,tp)
end
function c999999973.spfilter(c,fc)
	return c999999973.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999973.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999999973.spfilter,2,nil,c)
end
function c999999973.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999973.spfilter,2,2,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function c999999973.target(e,c)
	return c:GetCode() == 999999973
end