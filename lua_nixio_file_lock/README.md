# Lua file locking sample (using nixio)

- make sure '[nixio](https://luarocks.org/modules/luarocks/nixio/0.3-1)' and '[socket](https://luarocks.org/modules/luarocks/luasocket)' modules are both installed
- run 'lua tflock.lua' in multiple command line windows 
- every instance runs indefinitely
- to stop, do 'touch /tmp/tfdone.tmp'


