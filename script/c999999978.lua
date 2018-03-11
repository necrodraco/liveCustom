--閃刀姫-カガリ
--LANPholinks
--Scripted by Eerie Code
--reused by NecroDraco
function c999999978.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999978.ffilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999978.spcon)
	e7:SetOperation(c999999978.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c999999978.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999978.ffilter(c,scard,sumtype,tp)
	return c:IsFusionType(TYPE_MONSTER,scard,sumtype,tp)
end
function c999999978.spfilter(c,fc)
	return c999999978.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999978.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999999978.spfilter,2,nil,c)
end
function c999999978.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999978.spfilter,2,2,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function c999999978.target(e,c)
	return c:GetCode() == 999999978
end