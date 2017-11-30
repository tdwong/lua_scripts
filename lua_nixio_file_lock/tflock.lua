#!/usr/bin/env lua

local lockFile='/tmp/tflock.tmp'
local doneFile='/tmp/tfdone.tmp'

local socket=require"socket"
local nixio=require"nixio", require"nixio.fs"

--
if nixio.fs.access(doneFile) then nixio.fs.remove(doneFile) end

--
-- utilize nixio.File.lock() to synchronize
--

	-- file must be open in 'w' mode for lock("lock") to work
	--
	f=nixio.open(lockFile,"w")

local ix=0
while nixio.fs.access(doneFile)==nil do

	ix=ix+1

		print( tostring(ix).." attempt to acquire lock on "..lockFile )

	-- file:lock("lock") will be BLOCKED if the file is locked by other process
	--
	f:lock("lock",0)
		print( os.time()..": "..tostring(ix).." successfully acquired lock on "..lockFile )

	math.randomseed(os.time())
	local sltime=math.random(1,5)
	socket.sleep(sltime)

		print( tostring(ix).." sleep for "..tostring(sltime).." second(s)" )

	-- file:lock("ulock") release the lock and unblock other process
	--
		print( tostring(ix).." woke up to release lock on "..lockFile )
	f:lock("ulock",0)

end

	f:close()

print( "script exiting due to "..doneFile )

