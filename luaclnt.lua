#!/usr/bin/env lua

--
--	unix domain socket CLIENT
--
--	v1	- send only
--	v2	- send and receive reply
--

SOCKET=os.getenv("SOCKET") or "/tmp/uds_socket"
if #arg>0 then SOCKET=arg[1] end

socket=require"socket"
unix=require"socket.unix"
c=unix()
assert(c:connect(SOCKET))

	print( "client connected to "..SOCKET )

	local outString = "string-goes-to-server"

while 1 do
	-- NOTE: append a '\n' so that receiving end can do socket:receive("*l")
	res, err, nsent = c:send( outString..'\n' )
	print( "res="..tostring(res)..", err="..tostring(err)..", nsent="..tostring(nsent) )
	if res then
		print( "sent ..(" ..outString.. ")" )
		res, err, elapsed = c:receive("*l")
		if res then print( "server reply: (" .. res .. ")" ) end
	else
		print( "failed to send... punt..." )
		break
	end
	--
	socket.sleep(2)
end

c:close()
