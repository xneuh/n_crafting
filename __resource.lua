
fx_version "bodacious"
games {"gta5"}

client_scripts {
  'w_client.lua'
}
server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'w_server.lua'
}
