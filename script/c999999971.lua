--セキュア・ガードナー
--Security Gardna
--reused by NecroDraco
function c999999971.initial_effect(c)
	c:SetUniqueOnField(1,0,999999971)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999971.matfilter,2,false)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c999999971.spcon)
	e7:SetOperation(c999999971.spop)
	c:RegisterEffect(e7)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c999999971.target)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e8)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c999999971.regop)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c999999971.damval2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(c999999971.damcon)
	c:RegisterEffect(e4)
end
function c999999971.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c999999971.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,999999971,RESET_PHASE+PHASE_END,0,1)
end
function c999999971.matfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_CYBERSE,lc,sumtype,tp) and c:IsType(TYPE_FUSION,lc,sumtype,tp)
end
function c999999971.damval1(e,re,val,r,rp,rc)
	if r&REASON_EFFECT~=0 then return 0
	else return val end
end
function c999999971.damval2(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if r&REASON_EFFECT>0 and Duel.GetFlagEffect(tp,999999971)~=0 then return val end
	if r&REASON_BATTLE+REASON_EFFECT~=0 and c:GetFlagEffect(999999971)==0 then
		c:RegisterFlagEffect(999999971,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function c999999971.damcon(e)
	return e:GetHandler():GetFlagEffect(999999971)==0
end
--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999971.spfilter(c,fc)
	return c999999971.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999999971.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999999971.spfilter,2,nil,c)
end
function c999999971.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999999971.spfilter,2,2,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
--Borrowed from Area A
function c999999971.target(e,c)
	return c:GetCode() == 999999971
end