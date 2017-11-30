#!/usr/bin/env lua

--
--	unix domain socket SERVER
--
--	v1	- receive only
--	v2	- receive and send reply
--	v3	- interoperability tested (with socat & udmStrClnt)
--

SOCKET=os.getenv("SOCKET") or "/tmp/uds_socket"
if #arg>0 then SOCKET=arg[1] end

require "socket"
unix=require"socket.unix"
s=unix()

	require "nixio"
	if nixio.fs.access(SOCKET) then
		nixio.fs.remove(SOCKET)
	end

assert(s:bind(SOCKET))
s:listen(5)

	print( "listend on "..SOCKET )

c=s:accept()

	print( "client connected "..tostring(c) )

while 1 do
	res, err, elapsed = c:receive("*l")
	if res then
		print( res )
		-- send reply
		-- NOTE: append a '\n' so that receiving end can do socket:receive("*l")
		local replyStr = 'reply_'..res
		res, err, nsent = c:send( replyStr..'\n' )
		if res then print( "reply sent ..(" ..replyStr.. ")" ) end
	else
		print( "err="..tostring(err)..", elapsed="..tostring(elapsed) )
		print( "receive nothing... punt..." )
		break
	end
end
