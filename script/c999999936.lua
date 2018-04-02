--無限泡影
--Infinite Transience
--reused by NecroDraco
function c999999936.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c999999936.target)
	e1:SetOperation(c999999936.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c999999936.handcon)
	c:RegisterEffect(e2)
end
function c999999936.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	local pos=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsPreviousPosition(POS_FACEDOWN) and POS_FACEDOWN or 0
	Duel.SetTargetParam(pos)
end
function c999999936.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local pos=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3
		if tc:IsType(TYPE_TRAPMONSTER) then
			e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		if not tc:IsImmuneToEffect(e1) and not tc:IsImmuneToEffect(e2) and (not e3 or not tc:IsImmuneToEffect(e3)) 
			and c:IsRelateToEffect(e) and bit.band(pos,POS_FACEDOWN)>0 then
			Duel.BreakEffect()
			c:RegisterFlagEffect(999999936,RESET_CHAIN,0,0)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e4:SetTarget(c999999936.distg)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(c999999936.disop)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e5,tp)
		end
	end
end
function c999999936.distg(e,c)
	local seq=e:GetLabel()
	if c:IsControler(1-e:GetHandlerPlayer()) then seq=4-seq end
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and seq==c:GetSequence() and c:GetFlagEffect(999999936)==0
end
function c999999936.disop(e,tp,eg,ep,ev,re,r,rp)
	local cseq=e:GetLabel()
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	local rc=re:GetHandler()
	if rc:GetFlagEffect(999999936)>0 then return end
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		if bit.band(loc,LOCATION_SZONE)==0 or rc:IsControler(1-p) then
			if rc:IsLocation(LOCATION_SZONE) and rc:IsControler(p) then
				seq=rc:GetSequence()
			else
				seq=rc:GetPreviousSequence()
			end
		end
		if bit.band(loc,LOCATION_SZONE)==0 then
			local val=re:GetValue()
			if val==nil or val==LOCATION_SZONE or val==LOCATION_FZONE or val==LOCATION_PZONE then
				loc=LOCATION_SZONE
			end
		end
	end
	if ep~=e:GetHandlerPlayer() then cseq=4-cseq end
	if bit.band(loc,LOCATION_SZONE)~=0 and cseq==seq then
		Duel.NegateEffect(ev)
	end
end
function c999999936.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
