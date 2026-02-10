local Cache = {}

function Cache.isNotNull(var)
	return var ~= nil and var ~= ''
end

function Cache.Exists(cacheFile)
	local f = io.open(cacheFile, "r")
	if Cache.isNotNull(f) then
		f:close()
		return true
	else
		return false
	end
end

function Cache.isObsolete(date, updateRate)
	return os.difftime(os.time(), date) > updateRate
end

function Cache.Write(cacheFile, data)
	if Cache.isNotNull(data) then
		local cache = io.open(cacheFile, "w+")
		data.dateCreation = os.time()
		cache:write(json.encode(data))
		cache:close()
	end
end

function Cache.Read(cacheFile)
	local data
	if Cache.Exists(cacheFile) then
		local cache = io.open(cacheFile,"r")
		data = json.decode(cache:read())
		cache:close()
	end
	return data
end

return Cache
