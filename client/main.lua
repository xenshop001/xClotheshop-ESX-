
ESX = nil
CreateThread(function()
  while not ESX do
    local ok, obj = pcall(function()
      return exports['es_extended']:getSharedObject()
    end)
    if ok and obj then
      ESX = obj
    end
    Wait(200)
  end
end)

AdapterEsxSkin = {}

function AdapterEsxSkin.getPlayerSkin(cb)
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
    cb(skin or {})
  end)
end

function AdapterEsxSkin.getCurrentSkin(cb)
  TriggerEvent('skinchanger:getSkin', function(skin)
    cb(skin or {})
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

local isOpen, oldSkin = false, nil

RegisterCommand(Config.Command or 'clotheshop', function()
  openShop()
end, false)

local hintShown = false
CreateThread(function()
  while true do
    local sleep = 1000
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    for _, shop in ipairs(Config.Shops or {}) do
      local near = #(pos - shop.coords) < (shop.radius or 2.0)
      if near then
        sleep = 0
        if not isOpen then
          if not hintShown then
            lib.showTextUI('[E] Ruhabolt megnyitása', { position = 'left-center' })
            hintShown = true
          end
          if IsControlJustPressed(0, 38) then
            lib.hideTextUI()
            hintShown = false
            openShop(shop)
          end
        else
          if hintShown then
            lib.hideTextUI()
            hintShown = false
          end
        end
      else
        if hintShown then
          lib.hideTextUI()
          hintShown = false
        end
      end
    end

    Wait(sleep)
  end
end)

function openShop(shop)
  if isOpen then return end
  isOpen = true

  AdapterEsxSkin.getPlayerSkin(function(skin)
    oldSkin = skin

    if shop and shop.camera then
      StartClothesCam(shop.camera)
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
      action = 'open',
      data = {
        basePrice = Config.BasePrice,
        sex       = (skin.sex == 1) and 'female' or 'male'
      }
    })

    lib.notify({
      title       = 'Ruhabolt',
      description = 'Megnyitva.',
      type        = 'inform'
    })
  end)
end

function closeShop()
  SetNuiFocus(false, false)
  StopClothesCam()
  isOpen = false
  SendNUIMessage({ action = 'close' })
end

local COMP = {
  mask=1, hair=2, arms=3, pants=4, bags=5,
  shoes=6, chain=7, tshirt=8, bproof=9,
  decals=10, torso=11
}
local PROP = {
  helmet=0, glasses=1, ears=2, watches=6, bracelets=7
}

local function clamp(n, lo, hi)
  if hi == nil then
    return math.max(lo or 0, n)
  end
  return math.max(lo or 0, math.min(n, hi))
end

local function normalizeSkin(skin)
  local ped = PlayerPedId()
  local s = table.clone and table.clone(skin) or json.decode(json.encode(skin))

  for base, slot in pairs(COMP) do
    local k1 = (base=='arms') and 'arms' or (base..'_1')
    local k2 = (base=='arms') and nil    or (base..'_2')
    local draw = tonumber(s[k1] or 0) or 0
    local maxD = GetNumberOfPedDrawableVariations(ped, slot) - 1
    s[k1] = clamp(draw, 0, math.max(0, maxD))

    if k2 then
      local tex  = tonumber(s[k2] or 0) or 0
      local maxT = GetNumberOfPedTextureVariations(ped, slot, s[k1]) - 1
      s[k2]  = clamp(tex, 0, math.max(0, maxT))
    end
  end

  for base, slot in pairs(PROP) do
    local k1, k2 = base..'_1', base..'_2'
    local draw   = tonumber(s[k1] or -1) or -1
    if draw >= 0 then
      local maxD = GetNumberOfPedPropDrawableVariations(ped, slot) - 1
      s[k1] = clamp(draw, 0, math.max(0, maxD))

      local tex  = tonumber(s[k2] or 0) or 0
      local maxT = GetNumberOfPedPropTextureVariations(ped, slot, s[k1]) - 1
      s[k2]  = clamp(tex, 0, math.max(0, maxT))
    else
      s[k1], s[k2] = -1, 0
    end
  end

  return s
end

RegisterNUICallback('focus', function(data, cb)
  ClothesCam.UpdatePos(data.group)
  cb(true)
end)

RegisterNUICallback('cam', function(data, cb)
  if data.cmd == 'rotLeft'  then ClothesCam.Rotate('left')
  elseif data.cmd == 'rotRight' then ClothesCam.Rotate('right')
  elseif data.cmd == 'zoomIn'   then ClothesCam.Zoom(-0.1)
  elseif data.cmd == 'zoomOut'  then ClothesCam.Zoom( 0.1)
  end
  cb(true)
end)

RegisterNUICallback('purchase', function(_, cb)
  AdapterEsxSkin.getCurrentSkin(function(newSkin)
    local normalized = normalizeSkin(newSkin)

    ESX.TriggerServerCallback('xen_clotheshop:purchase', function(ok, extra)
      if not ok then
        AdapterEsxSkin.loadSkin(oldSkin)
        lib.notify({
          title       = 'Ruhabolt',
          description = extra and (extra.reason or extra.msg)
                       or 'Sikertelen vásárlás (nincs elég pénz?)',
          type        = 'error'
        })
        cb(false, extra or {})
        return
      end

      AdapterEsxSkin.loadSkin(normalized)
      AdapterEsxSkin.saveCurrent()

      lib.notify({
        title       = 'Ruhabolt',
        description = ('Sikeres vásárlás! Ár: $%s'):format(extra and extra.price or 0),
        type        = 'success'
      })

      cb(true, extra or {})
      closeShop()
    end, { oldSkin = oldSkin, newSkin = normalized })
  end)
end)

RegisterNUICallback('cancel', function(_, cb)
  AdapterEsxSkin.loadSkin(oldSkin)
  cb(true)
  lib.notify({
    title       = 'Ruhabolt',
    description = 'Vásárlás megszakítva.',
    type        = 'inform'
  })
  closeShop()
end)
