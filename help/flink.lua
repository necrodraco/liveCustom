--fakelink Procedures to emulate Link Monsters
--Debug.Message("Fake Link Opened")

function Auxiliary.AddFakeLinkProcedure(c,spfilter,minc,maxc,spcheck,manymustfulfill)
	Auxiliary.AddFakeLinkSummonRule(c,spfilter,minc,maxc,spcheck,manymustfulfill)
	Auxiliary.AddFakeLinkATKReq(c)
end

function Auxiliary.AddFakeLinkATKReq(c)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(Auxiliary.fakelinktarget)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
end

function Auxiliary.AddFakeLinkSummonRule(c,spfilter,minc,maxc,spcheck,manymustfulfill)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(Auxiliary.fakelinkcon(minc,spfilter,spcheck,manymustfulfill))
	e99:SetOperation(Auxiliary.fakelinkspop(minc,maxc,spfilter))
	e99:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e99)
end

function Auxiliary.AddFakeLinkSummonLimit(c)
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(Auxiliary.fakelinklimit)
	c:RegisterEffect(e100)
end

function Auxiliary.fakelinklimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end

function Auxiliary.fakelinkcon(minc,spfilter,spcheck,manymustfulfill)
	return function(e,c)
			if c==nil then return true end
			if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
			local tp=e:GetHandlerPlayer()
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			return ft>-minc 
			 and Duel.IsExistingMatchingCard(spfilter,tp,LOCATION_ONFIELD,nil,minc,nil,tp,ft)--the Number 2 represents the Min Count of Monsters
			 and (spcheck==nil or spcheck(Duel.GetMatchingGroup(spfilter,tp,LOCATION_ONFIELD,nil,nil)))
		end
end

function Auxiliary.fakelinkspop(minc,maxc,spfilter)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=Duel.GetMatchingGroup(spfilter,tp,LOCATION_MZONE,nil,nil,tp)
			local g1=g:Select(tp,minc,maxc,nil)--Count of Monsters thats needed. first is minimal count, second ist maximal count
			Duel.SendtoGrave(g1,REASON_COST)
		end
end

--Borrowed from Area A
function Auxiliary.fakelinktarget(e,c)
	return c == e:GetHandler()
end

--Todo: Check if it is exactly a Monster which use this summon system(e.g. Flag?)
function Auxiliary.containsFakeLinkMonsterFilter(c)
	return c:IsType(TYPE_FUSION)
end

--Imitate Link Zones = Check if there is a fake link monster on the field
function Duel.GetLinkedZone(tp)
	local hasFakeLinkMonster = Duel.IsExistingMatchingCard(containsFakeLinkMonsterFilter,tp,LOCATION_ONFIELD,nil,1,nil,tp,ft)
	if hasFakeLinkMonster then return 1 end
	return 0
end