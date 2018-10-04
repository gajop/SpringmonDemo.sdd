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

function widget:Initialize()
	DIR = ''
	Recurse(DIR, function(f)
		local absPath = VFS.GetFileAbsolutePath(f)
		if absPath:sub(#absPath - 3) == ".sdd" then
			Spring.Echo("File: " .. f)
			Spring.Echo("Path: " .. absPath)
		end
	end, {
		mode = VFS.ZIP
	})
end

