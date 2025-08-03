# 🛍️ Xen Clotheshop

A modern, interactive clothes shop solution for **FiveM ESX** servers.

## 🌟 Features

* **🎨 NUI-based modern interface**
* **👔 Detailed clothing categories**

  * Tops, pants, shoes, hats, accessories, and more
* **🛒 Easy clothing purchase**
* **🎥 Interactive camera management**

  * Automatically adjusts based on selected clothing item (top, pants, shoes, etc.)
* **⚙️ Easy configuration**
* **⚡ Optimized performance**
* **🎟️ Job-specific discounts**
* **Available languages: Hungarian**

**Preview:** [Watch Video](https://www.youtube.com/watch?v=cdmq1v2u-R4)
**Support:** [Discord Server](https://discord.gg/43QuRqqUgV)

---

## 🖥️ Technical Details

### 🔧 Dependencies

* `es_extended` (ESX Legacy 1.9.0+ recommended)
* `oxmysql` (for database management)
* `skinchanger` or `esx_skin` (character wardrobe support)

---

## 🎯 Special Features

### 🎖️ Job-Specific Discounts

Easily configure custom discounts for specific jobs or ranks:

```lua
Config.Discounts = {
  { job = 'police',    grade = 3, percent = 20 },
  { job = 'ambulance', grade = 0, percent = 10 },
}
```

---

### 🗺️ Shop Configuration Example

```lua
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
```

---

## 📂 Folder Structure (Example)

```
xen_clotheshop/
├── client/
│   ├── main.lua
│   └── camera.lua
├── server/
│   └── main.lua
├── config.lua
├── fxmanifest.lua
└── html/
    ├── index.html
    ├── app.js
    └── style.css
```

---
<img width="1903" height="1057" alt="Képernyőkép 2025-08-03 013516" src="https://github.com/user-attachments/assets/45f881b2-188a-4c7e-b004-f323f2ddc1a7" />


**Xen Clotheshop** — Designed for seamless integration and maximum customization.
