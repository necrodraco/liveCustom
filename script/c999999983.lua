--影王デュークシェード
--Duke Shade, King of the Umbra
--Scripted by Eerie Code
function c999999983.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,999999983)
	e1:SetCost(c999999983.spcost)
	e1:SetTarget(c999999983.sptg)
	e1:SetOperation(c999999983.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12766475)
	e2:SetCost(c999999983.cost)
	e2:SetTarget(c999999983.thtg)
	e2:SetOperation(c999999983.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(999999983,ACTIVITY_SPSUMMON,c999999983.counterfilter)
end
function c999999983.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c999999983.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(999999983,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c999999983.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c999999983.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c999999983.spcheck(sg,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(Card.IsInMainMZone,1,nil,tp)
end
function c999999983.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c999999983.cost(e,tp,eg,ep,ev,re,r,rp,0) 
		and Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,c999999983.spcheck) end
	c999999983.cost(e,tp,eg,ep,ev,re,r,rp,1)
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,99,c999999983.spcheck)
	local ct=Duel.Release(g,REASON_COST)
	e:SetLabel(ct)
end
function c999999983.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999999983.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500*e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c999999983.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c999999983.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999999983.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999983.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c999999983.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c999999983.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end