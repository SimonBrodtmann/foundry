require("util")
local futil = require("data-util")
local meld = require("meld")

local fuel = {"chemical"}
if mods.Krastorio2 then table.insert(fuel, "kr-vehicle-fuel") end
if mods["aai-industry"] then table.insert(fuel, "processed-chemical") end

local foundry = table.deepcopy(data.raw["assembling-machine"]["electric-foundry"])
meld(foundry, {
  name = "foundry",
  next_upgrade = "electric-foundry",
  icon = "__bzfoundry__/graphics/icons/foundry.png",
  minable = {mining_time = 0.2, result = "foundry"},
  energy_usage = "180kW",
  energy_source = {
    type = "burner",
    fuel_categories = fuel,
    effectivity = 1,
    emissions_per_minute = { pollution = 8 },
    fuel_inventory_size = 1,
    smoke =
    {
      {
        name = "smoke",
        frequency = 20,
        position = {1, -1.7},
        starting_vertical_speed = 0.1,
        starting_frame_deviation = 60
      }
    }
  },
})
foundry.graphics_set.animation.layers[1].filenames = {
  "__bzfoundry__/graphics/entity/foundry/foundry-main-1.png",
  "__bzfoundry__/graphics/entity/foundry/foundry-main-2.png"
}

data:extend({
  foundry,
  {
      type = "corpse",
      name = "foundry-remnants",
      icon = "__bzfoundry__/graphics/icons/foundry.png",
      flags = {"placeable-neutral", "not-on-map"},
      hidden_in_factoriopedia = true,
      subgroup = "smelting-machine-remnants",
      order = "d[foundry]",
      selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
      tile_width = 5,
      tile_height = 5,
      selectable_in_game = false,
      time_before_removed = 60 * 60 * 15, -- 15 minutes
      expires = false,
      final_render_layer = "remnants",
      remove_on_tile_placement = false,
      animation =
      {
        filename = "__bzfoundry__/graphics/entity/foundry/foundry-remnants.png",
        line_length = 1,
        width = 494,
        height = 478,
        frame_count = 1,
        direction_count = 1,
        shift = util.by_pixel( -1.5, -5.5),
        scale = 0.4
      }
    }
})

futil.add_crafting_category("assembling-machine", "foundry", "basic-founding")
