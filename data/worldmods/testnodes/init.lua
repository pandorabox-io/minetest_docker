
minetest.register_node("testnodes:metachanger", {
		description = "Metadata changer block",
		tiles = {"default_mese_block.png"},
		groups = { dig_immediate = 1 },
		after_place_node = function(pos)
			minetest.get_node_timer(pos):start(1)
		end,
		on_timer = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("rnd", math.random(10000))
			return true
		end
})


minetest.register_node("testnodes:metagenerator", {
		description = "Metadata generator block",
		tiles = {"default_mese_block.png"},
		groups = { dig_immediate = 1 },
		after_place_node = function(pos)
			local meta = minetest.get_meta(pos)
			for i=0,20000 do
				meta:set_string("" .. i * i, "value" .. (i-1) * (i-1))
			end
		end
})
