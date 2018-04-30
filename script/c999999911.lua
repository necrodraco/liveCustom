--アカシック・マジシャン
--Akashic Magician
--reused by NecroDraco
function c999999911.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999911.filter,2,2,c999999911.spcheck)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999999911.regcon)
	e1:SetOperation(c999999911.regop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999911,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c999999911.thcon)
	e2:SetTarget(c999999911.thtg)
	e2:SetOperation(c999999911.thop)
	c:RegisterEffect(e2)
	--[[announce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999911,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c999999911.actg)
	e3:SetOperation(c999999911.acop)
	c:RegisterEffect(e3)]]
end
function c999999911.filter(c,lc,sumtype,tp)
	return not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end
function c999999911.spcheck(g,lc,tp)
	return g:GetClassCount(Card.GetRace,lc,SUMMON_TYPE_Fusion,tp)==1
end
function c999999911.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c999999911.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c999999911.splimit1)
	Duel.RegisterEffect(e1,tp)
end
function c999999911.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(999999911) and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c999999911.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c999999911.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler()--:GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),0,0)
end
function c999999911.thop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler()--:GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	Duel.SendtoHand(lg,nil,REASON_EFFECT)
end
--[[function c999999911.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local lg=c:GetMutualLinkedGroup()
		local ct=lg:GetSum(Card.GetLink)
		if ct<=0 or not Duel.IsPlayerCanDiscardDeck(tp,ct) then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c999999911.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c999999911.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c999999911.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c999999911.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetMutualLinkedGroup()
	local ct=lg:GetSum(Card.GetLink)
	if ct<=0 or not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local hg=g:Filter(c999999911.thfilter,nil,ac)
	g:Sub(hg)
	if hg:GetCount()~=0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
		Duel.ShuffleHand(tp)
	end
	if g:GetCount()~=0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end]]