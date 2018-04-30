--電影の騎士ガイアセイバー
--Gaiasaber, the Video Knight
--reused by NecroDraco
function c999999925.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999925.matfilter,2,3)
end

function c999999925.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_MONSTER,scard,sumtype,tp)
end