#!/usr/bin/env lua

--
--	unix domain socket CLIENT
--
--	v1	- send only
--	v2	- send and receive reply
--	v3	- interoperability tested (with socat & udmStrServ)
--	v4	- allow customized initial string & add simple help
--

-- simple command line help
local usage = "usage: "..arg[0].." [unix-domain-socket-path] [initial-outgoing-string]"
if #arg>0 then
	for i=1,#arg do
		if arg[i]=='-h' or arg[i]=='--help' then print( usage ) ; return end
	end
end


SOCKET=os.getenv("SOCKET") or "/tmp/uds_socket"
if #arg>0 then SOCKET=arg[1] end

local outString = "string-goes-to-server"
if #arg>1 then outString=arg[2] end

socket=require"socket"
unix=require"socket.unix"
c=unix()
assert(c:connect(SOCKET))		-- assert() never returns

	print( "client connected to "..SOCKET )

local no_recv=os.getenv('NO_RECEIVE')
if no_recv==nil then no_recv=false else no_recv=true end

while 1 do
	-- NOTE: append a '\n' so that receiving end can do socket:receive("*l")
	res, err, nsent = c:send( outString..'\n' )
	print( "res="..tostring(res)..", err="..tostring(err)..", nsent="..tostring(nsent) )
	if res then
		print( "sent ..(" ..outString.. ")" )
		if no_recv==false then
			res, err, elapsed = c:receive("*l")
			if res then print( "server reply: (" .. res .. ")" ) end
		end
	else
		print( "failed to send... punt..." )
		break
	end
	--
	--socket.sleep(2)
	io.write( "enter data to be sent: " )
	outString = io.read()
		-- print( 'outString: '..outString..', #outString: '..tostring(#outString) )
	if #outString==1 and (outString=='.' or outString=='q') then break end
end

c:close()
