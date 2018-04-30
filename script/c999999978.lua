--閃刀姫-カガリ
--LANPholinks
--Scripted by Eerie Code
--reused by NecroDraco
function c999999978.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999978.ffilter,2,2)
end

function c999999978.ffilter(c,scard,sumtype,tp)
	return c:IsFusionType(TYPE_MONSTER,scard,sumtype,tp)
end