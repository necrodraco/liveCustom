--閃刀起動－エンゲージ
--Brandish Start-Up Engage
--Scripted by ahtelel
--reused by Necrodraco
function c999999982.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c999999982.condition)
	e1:SetTarget(c999999982.target)
	e1:SetOperation(c999999982.activate)
	c:RegisterEffect(e1)
end
function c999999982.cfilter(c)
	monsterCount = Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if monsterCount==0 or (monsterCount==1 and c:GetSummonLocation()==LOCATION_EXTRA and c:IsLocation(LOCATION_MZONE)) then
		return false
	end
	return true
end
function c999999982.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c999999982.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c999999982.filter(c)
	return c:IsSetCard(0x115) and c:IsAbleToHand() and not c:IsCode(999999982)
end
function c999999982.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999982.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	end
end
function c999999982.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999982.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1) 
			and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
			and Duel.SelectYesNo(tp,aux.Stringid(999999982,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
