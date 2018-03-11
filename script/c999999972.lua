--彼岸の黒天使 ケルビーニ
--Cherubini, Black Angel of the Burning Abyss
--Scripted by Eerie Code
--reused by NecroDraco
function c999999972.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999972.matfilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999972.spcon)
	e7:SetOperation(c999999972.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c999999972.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c999999972.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c999999972.desreptg)
	c:RegisterEffect(e2)
	--boost
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999972,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(0)
	e3:SetCountLimit(1,999999972)
	e3:SetCost(c999999972.atkcost)
	e3:SetTarget(c999999972.atktg)
	e3:SetOperation(c999999972.atkop)
	c:RegisterEffect(e3)
end
function c999999972.indtg(e,c)
	return e:GetHandler():IsContains(c)
end
function c999999972.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and (c:IsReason(REASON_BATTLE) or rp~=tp)
		and Duel.IsExistingMatchingCard(aux.NOT(Card.IsStatus),tp,LOCATION_ONFIELD,0,1,c,STATUS_BATTLE_DESTROYED) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,aux.NOT(Card.IsStatus),tp,LOCATION_ONFIELD,0,1,1,c,STATUS_BATTLE_DESTROYED)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c999999972.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c999999972.cfilter(c)
	return c:IsLevel(3) and (c:GetBaseAttack()>0 or c:GetBaseDefense()>0) and c:IsAbleToGraveAsCost()
end
function c999999972.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb1)
end
function c999999972.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c999999972.filter(chkc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c999999972.cfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingTarget(c999999972.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c999999972.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999999972.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c999999972.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and sc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(sc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(sc:GetDefense())
		tc:RegisterEffect(e2)
	end
end

--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999972.matfilter(c,scard,sumtype,tp)
	return c:IsLevel(3,scard,sumtype,tp)
end
function c999999972.spfilter(c,fc)
	return c999999972.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999972.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999999972.spfilter,2,nil,c)
end
function c999999972.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999972.spfilter,2,2,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function c999999972.target(e,c)
	return c:GetCode() == 999999972
end