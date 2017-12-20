#!/usr/bin/env lua

--
--	unix domain socket SERVER
--
--	v1	- receive only
--	v2	- receive and send reply
--	v3	- interoperability tested (with socat & udmStrClnt)
--	v4	- add timeout (in listen and receive) & receive mode
--

SOCKET=os.getenv("SOCKET") or "/tmp/uds_socket"
if #arg>0 then SOCKET=arg[1] end

socket=require "socket"
unix=require"socket.unix"
s=unix()

	require "nixio"
	if nixio.fs.access(SOCKET) then
		nixio.fs.remove(SOCKET)
	end

assert(s:bind(SOCKET))		-- assert() never returns
s:listen(5)

	print( "listend on "..SOCKET )

	-- --
	local acceptTimeout=os.getenv('ACCEPT_TIMEOUT')
	if acceptTimeout then acceptTimeout = tonumber(acceptTimeout) end
	if acceptTimeout then s:settimeout(acceptTimeout) end
	-- --

while 1 do
	--
	print( "accepting @ "..os.time() )
	c, err =s:accept()
	
	if c then break
	else
		if err=='timeout' then
			print( "accept: timeout @ "..os.time().. ", after "..tostring(acceptTimeout).." seconds, continue waiting..." )
		else
			print( "accept: error: "..err )
			return
		end
	end
	--
end	-- while

	-- --
	local receiveTimeout=os.getenv('RECEIVE_TIMEOUT')
	if receiveTimeout then receiveTimeout = tonumber(receiveTimeout) end
	if receiveTimeout then c:settimeout(receiveTimeout) end
	-- --

	print( "client connected "..tostring(c) )

local receive_mode=os.getenv('RECEIVE_MODE') or '*l'
while 1 do
	--
	print( "receiving @ "..os.time() )
	res, err, nbytes = c:receive(receive_mode)
	if res then
		print( res )
		-- send reply
		-- NOTE: append a '\n' so that receiving end can do socket:receive("*l")
		local replyStr = 'reply_'..res
		res, err, nsent = c:send( replyStr..'\n' )
		if res then print( "reply sent ..(" ..replyStr.. ")" ) end
	else
		if err~='timeout' then
			print( "err="..tostring(err) )
			print( "receive nothing... punt..." )
			c:close()
			break
		else
			print( "receive: timeout @ "..os.time().. ", after "..tostring(receiveTimeout).." seconds, abort receiving..." )
			--
			-- -- alternatively, close the client socket and goes back to listen
			--
			-- c:close()
			-- break
		end
	end
end

s:close()

