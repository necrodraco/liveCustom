--電影の騎士ガイアセイバー
--Gaiasaber, the Video Knight
--reused by NecroDraco
function c999999925.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999925.matfilter,2,false)
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkSummonRule(c,c999999925.matfilter,2,3)
	Auxiliary.AddFakeLinkATKReq(c)
end

function c999999925.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_MONSTER,scard,sumtype,tp)
end