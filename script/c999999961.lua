--剛鬼ジェット・オーガ
--Gouki Jet Ogre
--Script by nekrozar
--reused by NecroDraco
function c999999961.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999961.matfilter,2,2)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999961,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c999999961.postg)
	e1:SetOperation(c999999961.posop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999961,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,999999961)
	e2:SetCondition(c999999961.atkcon)
	e2:SetTarget(c999999961.atktg)
	e2:SetOperation(c999999961.atkop)
	c:RegisterEffect(e2)
end
function c999999961.desfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfc)
		and Duel.IsExistingMatchingCard(c999999961.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c999999961.posfilter(c)
	return c:IsDefensePos() or c:IsFacedown()
end
function c999999961.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c999999961.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c999999961.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c999999961.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999999961.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c999999961.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if g:GetCount()==0 then return end
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
end
function c999999961.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999999961.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfc)
end
function c999999961.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999961.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c999999961.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999999961.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

function c999999961.matfilter(c)
	return c:IsSetCard(0xfc)
end