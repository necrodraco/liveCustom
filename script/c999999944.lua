--デコード・トーカー
--reused by Necro Draco
function c999999944.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999944.matfilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999944.spcon)
	e7:SetOperation(c999999944.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c999999944.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c999999944.atkval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999944,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c999999944.discon)
	e2:SetCost(c999999944.discost)
	e2:SetTarget(c999999944.distg)
	e2:SetOperation(c999999944.disop)
	c:RegisterEffect(e2)
end
function c999999944.atkval(e,c)
	if Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE) <= 3 then
		return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)*500-500
	end
	if Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE) > 3 then
		return 1000
	end
end
function c999999944.tfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c999999944.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c999999944.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c999999944.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c999999944.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	--local lg=e:GetHandler()--:GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c999999944.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c999999944.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c999999944.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c999999944.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999944.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_EFFECT,scard,sumtype,tp)
end
function c999999944.spfilter(c,fc)
	return c999999944.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999944.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999999944.spfilter,2,nil,c)
end
function c999999944.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999944.spfilter,2,3,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function c999999944.target(e,c)
	return c:GetCode() == 999999944
end