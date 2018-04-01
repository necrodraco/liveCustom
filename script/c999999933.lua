--剛鬼ザ・マスター・オーガ
--Gouki The Master Ogre
--Script by nekrozar
--reused by NecroDraco
function c999999933.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999933.matfilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999933.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999933.spcon)
	e99:SetOperation(c999999933.spop)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999933.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999933,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetCost(c999999933.discost)
	e1:SetTarget(c999999933.distg)
	e1:SetOperation(c999999933.disop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--attack limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetCondition(c999999933.atcon)
	e3:SetValue(c999999933.atlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e4:SetCondition(c999999933.atcon)
	c:RegisterEffect(e4)
end
function c999999933.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c999999933.costfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0xfc) and g:IsContains(c) and c:IsAbleToHandAsCost()
end
function c999999933.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler()--:GetLinkedGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c999999933.costfilter,tp,LOCATION_MZONE,0,1,nil,lg)
				and Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil)
		else return false end
	end
	e:SetLabel(0)
	local rt=Duel.GetTargetCount(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local cg=Duel.SelectMatchingCard(tp,c999999933.costfilter,tp,LOCATION_MZONE,0,1,rt,nil,lg)
	local ct=cg:GetCount()
	Duel.SendtoHand(cg,nil,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c999999933.disfilter(c,e)
	return ((c:IsFaceup() and not c:IsDisabled()) or c:IsType(TYPE_TRAPMONSTER)) and c:IsRelateToEffect(e)
end
function c999999933.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c999999933.disfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
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
		tc=g:GetNext()
	end
end
function c999999933.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c999999933.atlimit(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	return not tg:IsContains(c) or c:IsFacedown()
end

--Borrowed Code of Starving Venom Pendulum Contact Fusion and Chimeratech Fortress Dragon
function c999999933.matfilter(c)
	return c:IsSetCard(0xfc)
end
function c999999933.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999933.spfilter(c,fc)
	return c999999933.matfilter(c)-- and c:IsCanBeFusionMaterial(fc) 
	and c:IsFaceup()
end
function c999999933.spcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-2--Min Count of Monsters
		and Duel.IsExistingMatchingCard(c999999933.spfilter,tp,LOCATION_ONFIELD,nil,2,nil,tp,ft)--the Number 2 represents the Min Count of Monsters
end
function c999999933.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999933.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,2,4,nil)--Count of Monsters thats needed. first is minimal count, second ist maximal count
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999933.target(e,c)
	return c:GetCode() == 999999933
end