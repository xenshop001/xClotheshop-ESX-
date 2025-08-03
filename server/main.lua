
  ESX = exports['es_extended']:getSharedObject()


local function takePayment(xP, srcAccount, amount)
    local acc = string.lower(srcAccount or 'money')
    if acc == 'cash' then acc = 'money' end 
    if acc == 'money' then
        if xP.getMoney and xP.getMoney() >= amount then
            xP.removeMoney(amount)
            return true
        end
        return false
    else
        local a = xP.getAccount and xP.getAccount(acc)
        local bal = (a and a.money) or 0
        if bal >= amount then
            xP.removeAccountMoney(acc, amount)
            return true
        end
        return false
    end
end
ESX.RegisterServerCallback('xen_clotheshop:purchase', function(src, cb, data)
    local xP = ESX.GetPlayerFromId(src)
    if not xP then return cb(false, 'Nincs játékos') end
    if not data or not data.oldSkin or not data.newSkin then
        return cb(false, 'Hiányzó skin adatok')
    end

    local total = Pricing.computeTotal(xP, data.oldSkin, data.newSkin)
    if total <= 0 then return cb(true, { total = 0 }) end

    if not takePayment(xP, Config.PayFrom, total) then
        return cb(false, ('Nincs elég pénz (%s)'):format(Config.PayFrom))
    end

    cb(true, { total = total })
end)





