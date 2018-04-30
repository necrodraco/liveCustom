--リンクルベル
--Linklebell
--Script by nekrozar
function c999999954.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Auxiliary.AddFakeLinkSummonLimit(c)
	Auxiliary.AddFakeLinkProcedure(c,c999999954.matfilter,2,2)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c999999954.spcost)
	c:RegisterEffect(e1)
end
function c999999954.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION then return true end
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>=3
end

function c999999954.matfilter(c,scard,sumtype,tp)
	return c:SetType(TYPE_MONSTER)
end