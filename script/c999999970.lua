--リンク・スパイダー
--reused by NecroDraco
function c999999970.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999970.matfilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999970.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999970.spcon)
	e99:SetOperation(c999999970.spop)
	e99:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999970.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999970,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c999999970.ctarget)
	e1:SetOperation(c999999970.operation)
	c:RegisterEffect(e1)
end
function c999999970.filter(c,e,tp,zone)
	return c:IsLevelBelow(4) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c999999970.ctarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		--local zone=e:GetHandler()--:GetLinkedZone(tp)
		return Duel.IsExistingMatchingCard(c999999970.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c999999970.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler()--:GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999999970.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999970.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_NORMAL,scard,sumtype,tp)
end
function c999999970.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999970.spfilter(c,fc)
	return c999999970.matfilter(c)
end
function c999999970.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1
		and Duel.IsExistingMatchingCard(c999999970.spfilter,tp,LOCATION_ONFIELD,nil,1,nil,tp,ft)
end
function c999999970.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999970.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999970.target(e,c)
	return c:GetCode() == 999999970
end