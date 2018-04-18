--デコード・トーカー
--reused by Necro Draco
function c999999944.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999944.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkSummonRule(c,c999999944.matfilter,2,3)
	Auxiliary.AddFakeLinkATKReq(c)
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
	local count=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,nil)
	if  count<= 3 then
		return count*500-500
	end
	if count > 3 then
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

function c999999944.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_EFFECT,scard,sumtype,tp)
end