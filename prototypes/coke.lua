local util = require("data-util")

if util.me.carbon() == "coke" and not data.raw.item["coke"] then
data:extend({
  {
    type = "item",
    name = "coke",
    icon = "__bzfoundry__/graphics/icons/coke-icon.png",
    icon_size = 128,
    pictures = {
      {size = 128, filename = "__bzfoundry__/graphics/icons/coke.png",   scale = 0.125},
      {size = 128, filename = "__bzfoundry__/graphics/icons/coke-1.png", scale = 0.125},
      {size = 128, filename = "__bzfoundry__/graphics/icons/coke-2.png", scale = 0.125},
      {size = 128, filename = "__bzfoundry__/graphics/icons/coke-3.png", scale = 0.125},
    },
    fuel_category = "chemical",
    fuel_value = "10MJ",
    fuel_acceleration_multiplier = 1.2,
    fuel_top_speed_multiplier = 1,
    subgroup = "raw-material",
    order = "c[coke]",
    stack_size = 50
  },
  {
    type = "recipe",
    name = "coke",
    category = "founding",
    ingredients = {{type="item", name="coal", amount=2}},
    results = {{ type = "item", name = "coke", amount = 1 }},
    energy_required = 3.2,
    enabled=false,
  },
})
  if util.me.woodcoke() then
    data:extend({
      {
        type = "recipe",
        name = "woodcoke",
        category = "founding",
        ingredients = {{type="item", name="coal", amount=1}, {type="item", name="wood", amount=2}},
        results = {{ type = "item", name = "coke", amount = 1 }},
        energy_required = 3.2,
        enabled=false,
        icons = {
          { icon = "__bzfoundry__/graphics/icons/coke-icon.png", icon_size = 128},
          { icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale=0.25, shift={8,-8}},
        },
      },
    })
  end
elseif util.me.carbon() == "solid-fuel" then
data:extend({
  {
    type = "recipe",
    name = "solid-fuel-from-coal",
    category = "founding",
    ingredients = {{type="item", name="coal", amount=4}},
    results = {{ type = "item", name = "solid-fuel", amount = 1 }},
    energy_required = 3.2,
    enabled=false,
  },
})
  if util.me.woodcoke() then
    data:extend({
      {
        type = "recipe",
        name = "woodcoke",
        category = "founding",
        ingredients = {{type="item", name="coal", amount=3}, {type="item", name="wood", amount=2}},
        results = {{ type = "item", name = "solid-fuel", amount = 1 }},
        energy_required = 3.2,
        enabled=false,
        icons = {
          { icon = "__base__/graphics/icons/solid-fuel.png", icon_size = 64, icon_mipmaps=4},
          { icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale=0.25, shift={8,-8}, icon_mipmaps=4},
        },
      },
    })
  end
end
