--トリックスター・ホーリーエンジェル
--Trickster Holy Angel
--reused by NecroDraco
function c999999915.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999915.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkSummonRule(c,c999999915.matfilter,2,2)
	Auxiliary.AddFakeLinkATKReq(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999999915.damcon)
	e1:SetOperation(c999999915.damop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c999999915.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999915,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c999999915.atkcon)
	e5:SetOperation(c999999915.atkop)
	c:RegisterEffect(e5)
end
function c999999915.cfilter(c,g)
	return c:IsSetCard(0xfb) and g:IsContains(c)
end
function c999999915.damcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler()--:GetLinkedGroup()
	return lg and eg:IsExists(c999999915.cfilter,1,nil,lg)
end
function c999999915.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,999999915)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function c999999915.indtg(e,c)
	return c:IsSetCard(0xfb) and e:GetHandler():IsContains(c)
end
function c999999915.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xfb)
end
function c999999915.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c999999915.matfilter(c)
	return c:IsSetCard(0xfb)
end