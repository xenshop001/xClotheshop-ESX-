Pricing = {}

local function getDiscount(xPlayer)
  for _, d in ipairs(Config.Discounts or {}) do
    if xPlayer.job and xPlayer.job.name == d.job and (xPlayer.job.grade or 0) >= (d.grade or 0) then
      return math.max(0, math.min(100, d.percent or 0))
    end
  end
  return 0
end


local Groups = {
  tshirt    = {'tshirt_1','tshirt_2'},
  torso     = {'torso_1','torso_2'},
  decals    = {'decals_1','decals_2'},
  arms      = {'arms'},
  pants     = {'pants_1','pants_2'},
  shoes     = {'shoes_1','shoes_2'},
  mask      = {'mask_1','mask_2'},
  bags      = {'bags_1','bags_2'},
  bproof    = {'bproof_1','bproof_2'},
  chain     = {'chain_1','chain_2'},
  helmet    = {'helmet_1','helmet_2'},
  glasses   = {'glasses_1','glasses_2'},
  ears      = {'ears_1','ears_2'},
  watches   = {'watches_1','watches_2'},
  bracelets = {'bracelets_1','bracelets_2'},
}

local function groupChanged(group, oldSkin, newSkin)
  for _, k in ipairs(Groups[group]) do
    if (newSkin[k] or 0) ~= (oldSkin[k] or 0) then
      return true
    end
  end
  return false
end

function Pricing.computeTotal(xPlayer, oldSkin, newSkin)
  local total = 0
  for group, fields in pairs(Groups) do
    if groupChanged(group, oldSkin, newSkin) then
      total = total + (Config.BasePrice[group] or 0)
    end
  end
  local disc = getDiscount(xPlayer)
  if disc > 0 then total = math.floor(total * (100 - disc) / 100) end
  return math.max(0, total)
end
