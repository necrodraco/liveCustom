--百獣のパラディオン
--Palladion of the Hundred Beasts
--Scripted by ahtelel
--reused by necrodraco
function c999999884.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999884,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,999999884)
	e1:SetCondition(c999999884.spcon)
	e1:SetValue(c999999884.spval)
	c:RegisterEffect(e1)
	---pierce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999884,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,28031914)
	e2:SetCondition(c999999884.condition)
	e2:SetTarget(c999999884.target)
	e2:SetOperation(c999999884.operation)
	c:RegisterEffect(e2)
end
function c999999884.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=Duel.GetLinkedZone(tp)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c999999884.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c999999884.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c999999884.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x116) and c:IsType(TYPE_FUSION) and not c:IsHasEffect(EFFECT_PIERCE)
end
function c999999884.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c999999884.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999999884.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c999999884.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
