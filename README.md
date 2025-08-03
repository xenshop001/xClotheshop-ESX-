🛠️ Features
NUI based modern interface

Detailed clothing category management

Tops, pants, shoes, hats, accessories, etc.

Buy clothes

Interactive camera management

Automatic camera switching based on the selected clothing item (top, pants, shoes, etc.)

Easy to configure

Optimized performance

🖥️ Technical details
🔧 Dependencies
ESX Legacy (1.9.0+ recommended)

oxmysql (for database management)

skinchanger or esx_skin (character wardrobe support)

**Discounts Can Be Set for Specific Jobs**
```
Config.Discounts = {
  { job='police',    grade=3, percent=20 },
  { job='ambulance', grade=0, percent=10 },
}
```
```
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
