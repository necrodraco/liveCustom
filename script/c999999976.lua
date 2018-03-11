--クリフォート・ゲニウス
--Qliphort Genius
--Scripted by Eerie Code
--reused by NecroDraco
function c999999976.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999976.matfilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999976.spcon)
	e7:SetOperation(c999999976.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c999999976.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c999999976.immcon)
	e1:SetValue(c999999976.efilter)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999976,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c999999976.distg)
	e2:SetOperation(c999999976.disop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999976,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c999999976.thcon)
	e3:SetTarget(c999999976.thtg)
	e3:SetOperation(c999999976.thop)
	c:RegisterEffect(e3)
end
function c999999976.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c999999976.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return te:IsActiveType(TYPE_LINK) and te:IsActivated() and te:GetOwner()~=e:GetOwner() end
end
function c999999976.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c999999976.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c999999976.thcfilter(c,lg)
	return lg:IsContains(c)
end
function c999999976.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local lg=c:GetLinkedGroup()
	return not eg:IsContains(c)-- and eg:FilterCount(c999999976.thcfilter,nil,lg)==2
end
function c999999976.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c999999976.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999976.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999976.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999976.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999976.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_MACHINE,scard,sumtype,tp)
end
function c999999976.spfilter(c,fc)
	return c999999976.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999976.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999999976.spfilter,2,nil,c)
end
function c999999976.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999976.spfilter,2,2,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function c999999976.target(e,c)
	return c:GetCode() == 999999976
end