--閃刀姫-カガリ
--Traffic Ghost
--Scripted by Eerie Code
--reused by NecroDraco
function c999999977.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999977.ffilter,3,3)
end

function c999999977.ffilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_MONSTER,scard,sumtype,tp)
end