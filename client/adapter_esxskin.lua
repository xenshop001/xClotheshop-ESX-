local AdapterEsxSkin = {}

function AdapterEsxSkin.getPlayerSkin(callback)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        callback(skin or {})
    end)
end

function AdapterEsxSkin.getCurrentSkin(callback)
    TriggerEvent('skinchanger:getSkin', function(skin)
        callback(skin or {})
    end)
end

function AdapterEsxSkin.loadSkin(skin)
    TriggerEvent('skinchanger:loadSkin', skin)
end

function AdapterEsxSkin.change(component, value)
    TriggerEvent('skinchanger:change', component, value)
end

function AdapterEsxSkin.saveCurrent()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin then
            TriggerServerEvent('esx_skin:save', skin)
        end
    end)
end

return AdapterEsxSkin
