--電影の騎士ガイアセイバー
--Gaiasaber, the Video Knight
--reused by NecroDraco
function c999999925.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999925.matfilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999925.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999925.spcon)
	e99:SetOperation(c999999925.spop)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999925.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion and Chimeratech Fortress Dragon
function c999999925.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_MONSTER,scard,sumtype,tp)
end
function c999999925.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999925.spfilter(c,fc)
	return c999999925.matfilter(c)-- and c:IsCanBeFusionMaterial(fc) 
	and c:IsFaceup()
end
function c999999925.spcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-2--Min Count of Monsters
		and Duel.IsExistingMatchingCard(c999999925.spfilter,tp,LOCATION_ONFIELD,nil,2,nil,tp,ft)--the Number 2 represents the Min Count of Monsters
end
function c999999925.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999925.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,2,3,nil)--Count of Monsters thats needed. first is minimal count, second ist maximal count
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999925.target(e,c)
	return c:GetCode() == 999999925
end