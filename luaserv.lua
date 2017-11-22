#!/usr/bin/env lua

--
--	unix domain socket SERVER
--
--	v1	- receive only
--

require "socket"
unix=require"socket.unix"
s=unix()

	require "nixio"
	if nixio.fs.access("/tmp/zz") then
		nixio.fs.remove("/tmp/zz")
	end

assert(s:bind("/tmp/zz"))
s:listen(5)
c=s:accept()

while 1 do
	res, err, elapsed = c:receive("*l")
	if res then
		print( res )
	else
		break
	end
end
