
local jobs = {}

local function qdataToTable( -- awesome API
	ping,
	name,
	desc,
	map,
	players,
	maxplayers,
	botplayers,
	pass,
	lastplayed,
	address,
	gamemode,
	workshopid
)
	return {
		ping = ping,
		name = name,
		desc = desc,
		map = map,
		players = players,
		maxplayers = maxplayers,
		botplayers = botplayers,
		pass = pass,
		lastplayed = lastplayed,
		address = address,
		gamemode = gamemode,
		wsid = workshopid
	}
end

-- BUG: game crashes on refresh if a query is started
function serverlist.StartQuerying(query_id, obj, data)
	jobs[query_id] = true
	
	local cb1 = data.Callback
	local cb2 = data.Finished
	
	local cbFound = function(...)
		local data = qdataToTable(...)
		
		if not jobs[query_id] then
			return false
		end
		
		cb1(obj, query_id, data)
		
		return true
	end
	
	local cbFinished = function()
		if not jobs[query_id] then
			return
		end
		
		return cb2(obj, query_id)
	end
	
	serverlist.Query({
		Type = data.Type,
		GameDir = data.GameDir,
		AppID = data.AppID,
		
		Callback = cbFound,
		Finished = cbFinished,
	})
end

function serverlist.StopQuerying(query_id)
	jobs[query_id] = nil
end
