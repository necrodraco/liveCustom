--星杯神楽イヴ
--reused by NecroDraco
function c999999945.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999945.matfilter,2,2,c999999945.spcheck)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c999999945.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c999999945.reptg)
	e4:SetValue(c999999945.repval)
	e4:SetOperation(c999999945.repop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999945,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c999999945.spcon2)
	e5:SetTarget(c999999945.sptg2)
	e5:SetOperation(c999999945.spop2)
	c:RegisterEffect(e5)
end
function c999999945.spcheck(g,lc,tp)
	return g:GetClassCount(Card.GetRace,lc,SUMMON_TYPE_FUSION,tp)>1 and g:GetClassCount(Card.GetAttribute,lc,SUMMON_TYPE_FUSION,tp)>1
end
function c999999945.incon(e)
	return true --e:GetHandler():IsLinkState()
end
function c999999945.repfilter(c,tp,hc)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_REPLACE) 
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and hc:IsContains(c)
end
function c999999945.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and eg:IsExists(c999999945.repfilter,1,nil,tp,e:GetHandler()) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c999999945.repval(e,c)
	return c999999945.repfilter(c,e:GetHandlerPlayer(),e:GetHandler())
end
function c999999945.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c999999945.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999999945.spfilter2(c,e,tp)
	return c:IsSetCard(0xfd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999999945.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999999945.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c999999945.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999999945.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c999999945.spfilter(c,fc)
	return --c999999945.spcheck(nil,c) and 
	c:IsCanBeFusionMaterial(fc) and (c:IsControler(tp) or c:IsFaceup())
end

function c999999945.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_MONSTER,scard,sumtype,tp)
end
