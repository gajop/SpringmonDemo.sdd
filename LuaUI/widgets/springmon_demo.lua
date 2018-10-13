function widget:GetInfo()
	return {
		name      = "springmon_demo",
		desc      = "SpringMon",
		author    = "gajop",
		date      = "in the future",
		license   = "GPL-v2",
		layer     = 0,
		enabled   = true,
	}
end

local LOG_SECTION = "springmon"

function Recurse(path, f, opts)
	opts = opts or {}
	for _, file in pairs(VFS.DirList(path), "*", opts.mode) do
		f(file)
	end
	for _, dir in pairs(VFS.SubDirs(path, "*", opts.mode)) do
		if opts.apply_folders then
			f(dir)
		end
		Recurse(dir, f, opts)
	end
end

function explode(div, str)
    if (div=='') then return false end
    local pos,arr = 0,{}
    -- for each divider found
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
        pos = sp + 1 -- Jump past current divider
    end
    table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
    return arr
end

function widget:TextCommand(text)
	local args = explode(" ", text)
	local cmdName = args[1]

	if cmdName == "ar_loaded" then
		Spring.Echo(VFS.GetLoadedArchives())
	elseif cmdName == "recurse" then
		Spring.Echo("== vfs file -> absolutePath | archiveName ==")
		local DIR = ''
		Recurse(DIR, function(f)
			local absPath = VFS.GetFileAbsolutePath(f)
			local archiveName = VFS.GetArchiveContainingFile(f)
			Spring.Echo(f .. " -> " .. tostring(absPath) .. " | " .. tostring(archiveName))
		end, {
			mode = VFS.ZIP
		})
	elseif cmdName == "ar_all" then
		Spring.Echo(VFS.GetAllArchives())
	elseif cmdName == "ar_path" then
		-- local archiveName = text:sub(#"ar_path" + 2)
		-- local archivePath = VFS.GetArchivePath(archiveName)
		-- Spring.Echo("Archive \"" .. tostring(archiveName) .. "\" path:" .. tostring(archivePath))
		Spring.Echo("=== ALL ===")
		for _, archiveName in pairs(VFS.GetAllArchives()) do
			local archivePath = VFS.GetArchivePath(archiveName)
			Spring.Echo(archiveName .. ": " .. archivePath)
		end
		Spring.Echo("=== ALL ===")
		Spring.Echo("=== LOADED ===")
		for _, archiveName in pairs(VFS.GetLoadedArchives()) do
			local archivePath = VFS.GetArchivePath(archiveName)
			Spring.Echo(archiveName .. ": " .. archivePath)
		end
		Spring.Echo("=== LOADED ===")
	end
end

function widget:Initialize()
	Spring.Echo("Widget initialized")
end

-- /luaui ar_path Flove $VERSION
-- /luaui ar_path /home/gajop/opt/spring/share/games/spring/base/cursors.sdz
-- /luaui ar_all
-- /luaui ar_loaded
