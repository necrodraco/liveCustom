--閃刀姫-カガリ
--Brandish Maiden Kagari
--Scripted by Eerie Code
function c999999992.initial_effect(c)
	c:SetSPSummonOnce(999999992)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999992.ffilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999992.spcon)
	e7:SetOperation(c999999992.spop)
	c:RegisterEffect(e7)
	--stats up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c999999992.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999992,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c999999992.thtg)
	e3:SetOperation(c999999992.thop)
	c:RegisterEffect(e3)
end
function c999999992.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*100
end
function c999999992.thfilter(c,tp)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c999999992.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999999992.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999992.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c999999992.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c999999992.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c999999992.matfilter(c,scard,sumtype,tp)
	return c:IsFusionSetCard(0x1115) and not c:IsAttribute(ATTRIBUTE_FIRE,scard,sumtype,tp)
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999992.ffilter(c)
	return c999999992.matfilter--c:IsFusionAttribute(ATTRIBUTE_EARTH)
end
function c999999992.spfilter(c,fc)
	return c999999992.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999992.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c999999992.spfilter,1,nil,c)
end
function c999999992.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999992.spfilter,1,1,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end