#!/usr/bin/env lua

--
--	unix domain socket CLIENT
--
--	v1	- send only
--	v2	- send and receive reply
--

socket=require"socket"
unix=require"socket.unix"
c=unix()
assert(c:connect("/tmp/zz"))

	local outString = "string-goes-to-server\n"

while 1 do
	res, err, nsent = c:send( outString )
	print( "res="..tostring(res)..", err="..tostring(err)..", nsent="..tostring(nsent) )
	if res then
		print( "sent ..(" ..outString.. ")" )
		res, err, elapsed = c:receive("*l")
	else
		print( "failed to send... punt..." )
		break
	end
	--
	socket.sleep(2)
end

c:close()
