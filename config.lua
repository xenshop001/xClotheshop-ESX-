Config = {}

Config.Framework = 'ESX'         

Config.PayFrom = 'money'
Config.Command   = 'clotheshop'   


Config.Discounts = {
  { job='police',    grade=3, percent=20 },
  { job='ambulance', grade=0, percent=10 },
}

Config.BasePrice = {
  tshirt = 1000, torso = 3500, decals = 800, arms = 1200, pants = 2500,
  shoes = 2000, mask = 1200, bags = 1600, bproof = 3000, chain = 1800,
  helmet = 1500, glasses = 1200, ears = 900, watches = 1400, bracelets = 1400
}

Config.Shops = {
  {
    name = 'Ponsonbys Rockford',
    coords = vec3(-709.48, -153.75, 37.42),
    heading = 120.0,
    camera = { offset = vec3(0.0, 2.0, 0.6), fov = 45.0 },
    blip   = { sprite = 73, color = 2, scale = 0.85 },
    radius = 2.0
  }
}
