--サイバース・ウィッチ
--Cyberse Witch
--Scripted by ahtelel
function c999999949.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999949.matfilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999949.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999949.spcon1)
	e99:SetOperation(c999999949.spop)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999949.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
	--link summon
	--aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,0x1000000),2,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999949,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,999999949)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999999949.thcon)
	e1:SetCost(c999999949.thcost)
	e1:SetTarget(c999999949.thtg)
	e1:SetOperation(c999999949.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999949,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101005135)
	e2:SetCondition(c999999949.spcon2)
	e2:SetTarget(c999999949.sptg)
	e2:SetOperation(c999999949.spop)
	c:RegisterEffect(e2)
end
function c999999949.thcfilter(c,tp,lg)
	return c:IsControler(tp) and lg:IsContains(c)
end
function c999999949.thcon(e,tp,eg,ep,ev,re,r,rp)
	--local lg=e:GetHandler():GetLinkedGroup()
	return true--eg:IsExists(c999999949.thcfilter,1,nil,tp,lg)
end
function c999999949.cfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c999999949.thfilter(c,tp)
	return c:IsCode(101005051) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c999999949.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c999999949.thfilter2(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsRace(0x1000000) and c:IsAbleToHand()
end
function c999999949.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999949.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c999999949.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c999999949.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999949.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999949.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c999999949.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c999999949.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
	Duel.RegisterFlagEffect(tp,999999949,RESET_PHASE+PHASE_END,0,1)
end
function c999999949.spcon2(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.GetFlagEffect(tp,999999949)>0
end
function c999999949.spfilter(c,e,tp)
	return c:IsRace(0x1000000) and c:IsLevelBelow4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999999949.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c999999949.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(aux.NecroValleyFilter(c999999949.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c999999949.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c999999949.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999949.matfilter(c,scard,sumtype,tp)
	return c:IsRace(0x1000000,scard,sumtype,tp)
end
function c999999949.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999949.spfilter(c,fc)
	return c999999949.matfilter(c) --and c:IsCanBeFusionMaterial(fc) 
	and c:IsFaceup()
end
function c999999949.spcon1(e,c,tp)
	if c==nil then return true end
	--local tp=:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-2
		and Duel.IsExistingMatchingCard(c999999949.spfilter,tp,LOCATION_ONFIELD,nil,2,nil,tp,ft)
end
function c999999949.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999949.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,2,2,nil)
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999949.target(e,c)
	return c:GetCode() == 999999949
end