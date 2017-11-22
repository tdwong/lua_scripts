#!/usr/bin/env lua

--
--	unix domain socket SERVER
--
--	v1	- receive only
--	v2	- receive and send reply
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
		-- send reply
		res, err, nsent = c:send( "reply\n" )
	else
		print( "failed to receive... punt..." )
		break
	end
end
