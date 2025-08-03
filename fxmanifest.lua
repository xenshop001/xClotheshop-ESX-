fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Xen'
ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js'
}

shared_script{
  '@ox_lib/init.lua', 
   'config.lua'
  }

client_scripts {
  'client/adapter_esxskin.lua',
  'client/camera.lua',
  'client/main.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/pricing.lua',
  'server/main.lua'
}



dependency 'es_extended'
dependency 'esx_skin'
dependency 'skinchanger'
dependencies 'ox_lib'

