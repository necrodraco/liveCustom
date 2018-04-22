--剛鬼サンダー・オーガ
--Gouki Thunder Ogre
--reused by NecroDraco
function c999999918.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999918.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999918.matfilter,2,3)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(999999918,0))
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetValue(c999999918.sumval)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999918,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c999999918.atkcon)
	e3:SetOperation(c999999918.atkop)
	c:RegisterEffect(e3)
end
function c999999918.sumval(e,c)
	if c:IsControler(e:GetHandlerPlayer()) then
		local sumzone=e:GetHandler()--:GetLinkedZone()
		local relzone=-(bit.lshift(1,e:GetHandler():GetSequence()))
		return 0,sumzone,relzone
	else
		local sumzone=e:GetHandler()--:GetLinkedZone(1-e:GetHandlerPlayer())
		local relzone=-(bit.lshift(1,e:GetHandler():GetSequence()+16))
		return 0,sumzone,relzone
	end
end
function c999999918.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c999999918.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c999999918.cfilter,1,nil,tp,e:GetHandler())--:GetLinkedZone())
end
function c999999918.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end

function c999999918.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0xfc)
end