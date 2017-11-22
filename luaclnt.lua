#!/usr/bin/env lua

--
--	unix domain socket CLIENT
--
--	v1	- send only
--

socket=require"socket"
unix=require"socket.unix"
c=unix()
assert(c:connect("/tmp/zz"))

while 1 do
	res, err, nsent = c:send("string-goes-to-server\n")
	print( "res="..tostring(res)..", err="..tostring(err)..", nsent="..tostring(nsent) )
	--
	socket.sleep(2)
end

c:close()
