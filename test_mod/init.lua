
minetest.log("info", "[TEST] integration-test enabled!")


local function doExit()
	print("Exiting")
	local data = minetest.write_json({ success = true }, true);
	local file = io.open(minetest.get_worldpath().."/integration_test.json", "w" );
	if file then
		file:write(data)
		file:close()
	end

	minetest.log("info", "[TEST] integration tests done!")
	minetest.request_shutdown("success")
end

local function doTests()
	print("Testing")
	local pos1 = { x=-5, y=-5, z=-5 }
	local pos2 = { x=5, y=5, z=5 }
	minetest.get_voxel_manip(pos1, pos2)
	doExit()
end

local function doEmerge()
	print("Emerging")
	local pos1 = { x=-50, y=-10, z=-50 }
	local pos2 = { x=50, y=50, z=50 }
	minetest.emerge_area(pos1, pos2, function(_, _, calls_remaining)
		if calls_remaining == 0 then
			doTests()
		end
	end)
end



minetest.register_on_mods_loaded(function()
	minetest.after(1, doEmerge)
end)
