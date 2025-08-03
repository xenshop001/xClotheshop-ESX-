ClothesCam = {
  cam = nil,
  baseOffset = vector3(1.0, 1.0, 0.6),
  dist = -1.2,                         
  yaw = 0.0,                          
}

local function pedCoords()
  local ped = PlayerPedId()
  return ped, GetEntityCoords(ped)
end


local Focus = {
  tshirt    = { z = 0.58, dist = 1.10 },
  torso     = { z = 0.62, dist = 1.10 }, 
  decals    = { z = 0.60, dist = 1.10 }, 
  arms      = { z = -0.20, dist = 0.90 }, 
  pants     = { z = -0.15, dist = 1.30 }, 
  shoes     = { z = -0.55, dist = 1.40 }, 
  mask      = { z = 0.74, dist = 1.00 }, 
  bags      = { z = 0.47, dist = 1.20, rotateBack = true },
  bproof    = { z = 0.50, dist = 1.15 }, 
  chain     = { z = 0.62, dist = 1.05 }, 
  helmet    = { z = 0.78, dist = 1.00 },
  glasses   = { z = 0.74, dist = 1.00 }, 
  ears      = { z = 0.74, dist = 1.00 },
  watches   = { z = 0.33, dist = 1.10 }, 
  bracelets = { z = 0.33, dist = 1.10 }, 
}

function StartClothesCam(camCfg)
  if ClothesCam.cam then return end
  local ped, p = pedCoords()
  ClothesCam.yaw = GetEntityHeading(ped) * math.pi/180.0
  ClothesCam.dist = -1.2
  local off = camCfg and camCfg.offset or vector3(0.0, 1.0, 0.6)

  ClothesCam.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
  SetCamFov(ClothesCam.cam, (camCfg and camCfg.fov) or 45.0)

  ClothesCam.baseOffset = off
  ClothesCam.UpdatePos('torso')

  SetCamActive(ClothesCam.cam, true)
  RenderScriptCams(true, true, 700, true, true)
end

function StopClothesCam()
  if not ClothesCam.cam then return end
  RenderScriptCams(false, true, 600, true, true)
  DestroyCam(ClothesCam.cam, false)
  ClothesCam.cam = nil
end

function ClothesCam.UpdatePos(group, customFocusPoint)
  if not ClothesCam.cam then return end
  local ped, base = pedCoords()
  local f = Focus[group] or { z = 0.62, dist = ClothesCam.dist } 
  local targetDist = f.dist or ClothesCam.dist
  if targetDist then ClothesCam.dist = targetDist end

  if f.rotateBack then
    ClothesCam.yaw = (GetEntityHeading(ped) * math.pi/180.0) + math.pi 
    local zoom = (GetEntityCoords(ped) or ClothesCam.Zoom(0 * -1))
  else
    ClothesCam.yaw = GetEntityHeading(ped) * math.pi/180.0 
  end

  function ClothesCam.Zoom(delta)
    if not ClothesCam.cam then return end
    ClothesCam.dist = math.max(0.5, math.min(3.0, ClothesCam.dist + delta))
    ClothesCam.UpdatePos()
end
  local forward = vector3(-math.sin(ClothesCam.yaw), math.cos(ClothesCam.yaw), 0.0)
  local camPos = base + vector3(0.0, 0.0, f.z) + forward * ClothesCam.dist
  SetCamCoord(ClothesCam.cam, camPos.x, camPos.y, camPos.z)

  if customFocusPoint then
    PointCamAtCoord(ClothesCam.cam, customFocusPoint.x, customFocusPoint.y, customFocusPoint.z)
  else
    local focusZ = f.z or 0.62
    PointCamAtCoord(ClothesCam.cam, base.x, base.y, base.z + focusZ)
  end
end

function ClothesCam.Rotate(dir)
  if not ClothesCam.cam then return end
  local step = 0.08 
  if dir == 'left' then
    ClothesCam.yaw = ClothesCam.yaw - step
  else
    ClothesCam.yaw = ClothesCam.yaw + step
  end
  ClothesCam.UpdatePos() 
end

function ClothesCam.Zoom(delta)
  if not ClothesCam.cam then return end
  ClothesCam.dist = math.max(0.5, math.min(2.5, ClothesCam.dist + delta * 0.05))
  ClothesCam.UpdatePos() 
end


function ClothesCam.SetFocusPoint(focusPoint)
  if not ClothesCam.cam then return end
  ClothesCam.UpdatePos(nil, focusPoint)
end