--reused by NecroDraco
function cXXXXXXXXX.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cXXXXXXXXX.matfilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(cXXXXXXXXX.spcon)
	e7:SetOperation(cXXXXXXXXX.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(cXXXXXXXXX.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
end

--Borrowed Code of Starving Venom Pendulum Contact Fusion
function cXXXXXXXXX.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_FIEND,scard,sumtype,tp)
end
function cXXXXXXXXX.spfilter(c,fc)
	return cXXXXXXXXX.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function cXXXXXXXXX.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,cXXXXXXXXX.spfilter,2,nil,c)
end
function cXXXXXXXXX.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cXXXXXXXXX.spfilter,2,2,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function cXXXXXXXXX.target(e,c)
	return c:GetCode() == XXXXXXXXX
end




--Alternate from Blue-Eyes Twin Burst Dragon
--青眼の双爆裂龍
function cXXXXXXXXX.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,89631139,2)
	aux.AddContactFusion(c,cXXXXXXXXX.contactfil,cXXXXXXXXX.contactop,cXXXXXXXXX.splimit)
end
cXXXXXXXXX.material_setcode=0xdd
function cXXXXXXXXX.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function cXXXXXXXXX.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function cXXXXXXXXX.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
