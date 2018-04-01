--閃刀姫-カガリ
--Traffic Ghost
--Scripted by Eerie Code
--reused by NecroDraco
function c999999977.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999977.ffilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999977.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999977.spcon)
	e99:SetOperation(c999999977.spop)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999977.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999977.ffilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_MONSTER,scard,sumtype,tp)
end
function c999999977.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999977.spfilter(c,fc)
	return c999999977.ffilter(c) --and c:IsCanBeFusionMaterial(fc) 
	and c:IsFaceup()
end
function c999999977.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-3
		and Duel.IsExistingMatchingCard(c999999977.spfilter,tp,LOCATION_ONFIELD,nil,3,nil,tp,ft)
end
function c999999977.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999977.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,3,3,nil)
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999977.target(e,c)
	return c:GetCode() == 999999977
end