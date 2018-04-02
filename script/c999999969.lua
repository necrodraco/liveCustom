--副話術士クララ＆ルーシカ
--Ventriloquists Clara & Lucika
--Script by nekrozar
--reused by NecroDraco
function c999999969.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999969.matfilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999969.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999969.spcon)
	e99:SetOperation(c999999969.spop)
	e99:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999969.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c999999969.spcost)
	c:RegisterEffect(e1)
end
function c999999969.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION then return true end
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end

--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999969.matfilter(c,scard,sumtype,tp)
	return c:IsSummonType(SUMMON_TYPE_NORMAL,scard,sumtype,tp)
end
function c999999969.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999969.spfilter(c,fc)
	return c999999969.matfilter(c)
end
function c999999969.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1
		and Duel.IsExistingMatchingCard(c999999969.spfilter,tp,LOCATION_ONFIELD,nil,1,nil,tp,ft)
end
function c999999969.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999969.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999969.target(e,c)
	return c:GetCode() == 999999969
end