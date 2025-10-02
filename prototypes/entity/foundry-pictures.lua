local foundry_animation_speed = 0.16
local frames = 128

local function foundry_main_pictures()
  return util.sprite_load("__bzfoundry__/graphics/entity/electric-foundry/foundry-main",
  {
    animation_speed = foundry_animation_speed,
    frame_count = frames,
    scale = 0.4
  })
end

local function foundry_main_shadow_pictures()
  return util.sprite_load("__bzfoundry__/graphics/entity/electric-foundry/foundry-shadow",
  {
    animation_speed = foundry_animation_speed,
    frame_count = frames,
    draw_as_shadow = true,
    scale = 0.4
  })
end

local function foundry_working_pictures()
  return
  {
    fadeout = true,
    animation =
    util.sprite_load("__bzfoundry__/graphics/entity/electric-foundry/foundry-working",
      {
        animation_speed = foundry_animation_speed,
        frame_count = frames,
        scale = 0.4
      }
    )
  }
end

local function foundry_lights_pictures()
  return
  {
    effect = "flicker",
    fadeout = true,
    animation =
    util.sprite_load("__bzfoundry__/graphics/entity/electric-foundry/foundry-lights",
      {
        draw_as_glow = true,
        animation_speed = foundry_animation_speed,
        frame_count = frames,
        blend_mode = "additive",
        scale = 0.4
      }
    )
  }
end

local function foundry_status_lamp_pictures()
  return
  {
    animation =
    util.sprite_load("__bzfoundry__/graphics/entity/electric-foundry/foundry-status-lamp",
      {
        draw_as_glow = true,
        repeat_count = frames,
        blend_mode = "additive",
        scale = 0.4
      }
    )
  }
end

local function foundry_chimney_smoke()
  return
  {
    fadeout = true,
    constant_speed = true,
    render_layer = "wires",
    animation =
    {
      filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
      frame_count = 47,
      line_length = 16,
      width = 90,
      height = 188,
      animation_speed = 0.5,
      shift = util.by_pixel(52, -131),
      tint = {0.4, 0.4, 0.4, 1},
      scale = 0.4
    }
  }
end

return {
  graphics_set =
  {
    animation =
    {
      layers =
      {
        foundry_main_pictures(),
        foundry_main_shadow_pictures()
      }
    },
    working_visualisations =
    {
      foundry_working_pictures(),
      foundry_lights_pictures(),
      foundry_status_lamp_pictures(),
      foundry_chimney_smoke()
    }
  }
}
