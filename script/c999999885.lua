--星辰のパラディオン
--Palladion of the Celestial Bodies
--Scripted by ahtelel
--reused by necrodraco
function c999999885.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999885,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,999999885)
	e1:SetCondition(c999999885.spcon)
	e1:SetValue(c999999885.spval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,54525058)
	e2:SetCondition(c999999885.thcon)
	e2:SetTarget(c999999885.thtg)
	e2:SetOperation(c999999885.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c999999885.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=Duel.GetLinkedZone(tp)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c999999885.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c999999885.filter1(c)
	return c:IsSetCard(0x116) and not c:IsCode(999999885) and c:IsAbleToHand()
end
function c999999885.filter2(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) --and c:GetLinkedGroup():IsContains(ec)
end
function c999999885.filter(c)
	return c:IsFaceup()
end
function c999999885.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetMatchingGroup(c999999885.filter,tp,LOCATION_MZONE,nil,nil,tp)
	local lg2=Duel.GetMatchingGroup(c999999885.filter,tp,nil,LOCATION_MZONE,nil,tp)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c999999885.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999999885.filter1(chkc) and c999999885.filter2(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c999999885.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c999999885.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c999999885.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

