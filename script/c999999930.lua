--トリックスター・ベラマドンナ
--Trickstar Bella Madonna
--Script by nekrozar
--reused by NecroDraco
function c999999930.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999930.matfilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999930.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999930.spcon)
	e99:SetOperation(c999999930.spop)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999930.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
	--immune
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999999930.imcon)
	e1:SetValue(c999999930.immval)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999930,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,999999930)
	e2:SetCondition(c999999930.damcon)
	e2:SetTarget(c999999930.damtg)
	e2:SetOperation(c999999930.damop)
	c:RegisterEffect(e2)]]
end
--[[function c999999930.imcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetLinkedGroupCount()==0
end
function c999999930.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated()
end
function c999999930.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()==0
end
function c999999930.damfilter(c)
	return c:IsSetCard(0xfb) and c:IsType(TYPE_MONSTER)
end
function c999999930.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999930.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c999999930.damfilter,tp,LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c999999930.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c999999930.damfilter,tp,LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.Damage(p,dam,REASON_EFFECT)
end]]

--Borrowed Code of Starving Venom Pendulum Contact Fusion and Chimeratech Fortress Dragon
function c999999930.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0xfb)
end
function c999999930.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999930.spfilter(c,fc)
	return c999999930.matfilter(c)-- and c:IsCanBeFusionMaterial(fc) 
	and c:IsFaceup()
end
function c999999930.spcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-2--Min Count of Monsters
		and Duel.IsExistingMatchingCard(c999999930.spfilter,tp,LOCATION_ONFIELD,nil,2,nil,tp,ft)--the Number 2 represents the Min Count of Monsters
end
function c999999930.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999930.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,2,4,nil)--Count of Monsters thats needed. first is minimal count, second ist maximal count
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999930.target(e,c)
	return c:GetCode() == 999999930
end