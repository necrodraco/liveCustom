--副話術士クララ＆ルーシカ
--Ventriloquists Clara & Lucika
--Script by nekrozar
--reused by NecroDraco
function c999999969.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999969.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkSummonRule(c,c999999969.matfilter,1,1)
	Auxiliary.AddFakeLinkATKReq(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c999999969.spcost)
	c:RegisterEffect(e1)
end
function c999999969.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION then return true end
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end

function c999999969.matfilter(c,scard,sumtype,tp)
	return c:IsSummonType(SUMMON_TYPE_NORMAL,scard,sumtype,tp)
end