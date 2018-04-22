--トポロジック・トゥリスバエナ
--reused by NecroDraco
function c999999928.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999928.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999928.matfilter,2,3)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999928,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999999928.rmcon)
	e1:SetTarget(c999999928.rmtg)
	e1:SetOperation(c999999928.rmop)
	c:RegisterEffect(e1)
end
function c999999928.cfilter(c,ec)
	return ec:IsContains(c)
end
function c999999928.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c999999928.cfilter,1,nil,e:GetHandler())
end
function c999999928.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c999999928.cfilter,nil,e:GetHandler())
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.SetTargetCard(tg)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c999999928.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:Merge(g2)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,1-tp)
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function c999999928.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_EFFECT,scard,sumtype,tp)
end
