--シャドール・ネフィリム
--Shaddoll Construct
--Scripted by Eerie Code
--reused by NecroDraco
function c999999950.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999999950.matfilter,2,false)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(c999999950.splimit)
	c:RegisterEffect(e100)
	--special summon rule
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_FIELD)
	e99:SetCode(EFFECT_SPSUMMON_PROC)
	e99:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_EXTRA)
	e99:SetCondition(c999999950.spcon)
	e99:SetOperation(c999999950.spop)
	e99:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e99)
	--It will automatically set to ATK. But it can be set facedown at the moment - TODO
	local e98=Effect.CreateEffect(c)
	e98:SetType(EFFECT_TYPE_FIELD)
	e98:SetCode(EFFECT_SET_POSITION)
	e98:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e98:SetRange(LOCATION_MZONE)
	e98:SetTarget(c999999950.target)
	e98:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e98:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e98)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999950,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,999999950)
	e1:SetTarget(c999999950.sptg)
	e1:SetOperation(c999999950.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999950,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,86938485)
	e2:SetTarget(c999999950.sptg2)
	e2:SetOperation(c999999950.spop2)
	c:RegisterEffect(e2)
end
function c999999950.spfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c999999950.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c999999950.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c999999950.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c999999950.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c999999950.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c999999950.spfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c999999950.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c999999950.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c999999950.cfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x9d) and c:IsAbleToGraveAsCost()
end
function c999999950.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c999999950.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c999999950.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and sg:GetCount()>=1 and (ft>0 or sg:IsExists(c999999950.mzfilter,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999999950.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c999999950.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,c999999950.mzfilter,1,1,nil)		
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,1,1,nil)
	end
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Borrowed Code of Starving Venom Pendulum Contact Fusion
function c999999950.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_FLIP,scard,sumtype,tp)
end
function c999999950.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999950.spfilter(c,fc)
	return c999999950.matfilter(c)
end
function c999999950.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-2
		and Duel.IsExistingMatchingCard(c999999950.spfilter,tp,LOCATION_ONFIELD,nil,2,nil,tp,ft)
end
function c999999950.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999950.spfilter,tp,LOCATION_MZONE,nil,nil,tp)
	local g1=g:Select(tp,2,2,nil)
	Duel.SendtoGrave(g1,REASON_COST)
end
--Borrowed from Area A
function c999999950.target(e,c)
	return c:GetCode() == 999999950
end