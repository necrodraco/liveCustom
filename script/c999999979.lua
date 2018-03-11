--閃刀術式－アフターバーナー
--Brandish Skill Afterburner
--Scripted by ahtelel
--reused by Necrodraco
function c999999979.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c999999979.condition)
    e1:SetTarget(c999999979.target)
    e1:SetOperation(c999999979.activate)
    c:RegisterEffect(e1)
end
function c999999979.cfilter(c)
    monsterCount = Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    if monsterCount==0 or (monsterCount==1 and c:GetSummonLocation()==LOCATION_EXTRA and c:IsLocation(LOCATION_MZONE)) then
        return false
    end
    return true
end
function c999999979.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c999999979.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c999999979.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999999979.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c999999979.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
        local dg=Duel.GetMatchingGroup(c999999979.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        if dg:GetCount()>0 and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 and Duel.SelectYesNo(tp,aux.Stringid(999999979,0)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=dg:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        end
    end
end
