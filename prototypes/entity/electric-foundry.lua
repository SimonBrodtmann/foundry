require("util")
local futil = require("data-util")
require ("sound-util")
require ("circuit-connector-sprites")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local explosion_animations = require("__base__/prototypes/entity/explosion-animations")
local particle_animations = require("__base__/prototypes/particle-animations")

data:extend({
  {
    type = "assembling-machine",
    name = "electric-foundry",
    icon = "__bzfoundry__/graphics/icons/electric-foundry.png",
    icon_size = 64,
    flags = {"placeable-neutral","player-creation"},
    minable = {mining_time = 0.2, result = "electric-foundry"},
    max_health = 300,
    fast_replaceable_group = "foundry",
    corpse = "electric-foundry-remnants",
    dying_explosion = "foundry-explosion",
    circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
    circuit_connector = circuit_connector_definitions["foundry"],
    collision_box = {{-1.7, -1.7}, {1.7, 1.7}},
    selection_box = {{-2, -2}, {2, 2}},
    crafting_categories = {"founding", futil.me.smelt() and "smelting" or nil},
    energy_usage = "360kW",
    drain = "12kW",
    crafting_speed = 4,
    energy_source =
    {
      type = "electric",
      emissions_per_minute = { pollution = 2 },
      usage_priority = "secondary-input",
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box_vertical_extension = 1.3,
    module_slots = 3,
    icon_draw_specification = {scale = 2, shift = {0, -0.3}},
    icons_positioning =
    {
      {inventory_index = defines.inventory.assembling_machine_modules, shift = {0, 1.25}}
    },
    perceived_performance = {minimum = 0.25, maximum = 20},
    graphics_set = require("foundry-pictures").graphics_set,
    open_sound = sounds.steam_open,
    close_sound = sounds.steam_close,
    working_sound =
    {
      sound =
      {
        filename = "__bzfoundry__/sound/entity/foundry/foundry.ogg",
        volume = 0.5,
        audible_distance_modifier = 0.6
      },
      fade_in_ticks = 4,
      fade_out_ticks = 20,
      sound_accents =
      {
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-pipe-out.ogg", volume = 0.9, audible_distance_modifier = 0.4}, frame = 2},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-slide-close.ogg", volume = 0.65, audible_distance_modifier = 0.3}, frame = 18},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-clamp.ogg", volume = 0.45, audible_distance_modifier = 0.3}, frame = 39},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-slide-stop.ogg", volume = 0.7, audible_distance_modifier = 0.4}, frame = 43},
        {sound = {variations = sound_variations("__bzfoundry__/sound/entity/foundry/foundry-fire-whoosh", 3, 0.8), audible_distance_modifier = 0.3}, frame = 64},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-metal-clunk.ogg", volume = 0.65, audible_distance_modifier = 0.4}, frame = 64},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-slide-open.ogg", volume = 0.65, audible_distance_modifier = 0.3}, frame = 74},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-pipe-in.ogg", volume = 0.75, audible_distance_modifier = 0.4}, frame = 106},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-smoke-puff.ogg", volume = 0.8, audible_distance_modifier = 0.3}, frame = 106},
        {sound = {variations = sound_variations("__bzfoundry__/sound/entity/foundry/foundry-pour", 2, 0.7)}, frame = 110},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-rocks.ogg", volume = 0.65, audible_distance_modifier = 0.3}, frame = 120},
        {sound = {filename = "__bzfoundry__/sound/entity/foundry/foundry-blade.ogg", volume = 0.7}, frame = 126},
      },
      max_sounds_per_prototype = 2
    },
    water_reflection =
    {
      pictures = util.sprite_load("__bzfoundry__/graphics/entity/electric-foundry/foundry-reflection",
      {
          scale = 4,
          shift = {0,2}
      }),
      rotate = false
    }
  },
  {
    type = "corpse",
    name = "electric-foundry-remnants",
    icon = "__bzfoundry__/graphics/icons/electric-foundry.png",
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
      filename = "__bzfoundry__/graphics/entity/electric-foundry/foundry-remnants.png",
      line_length = 1,
      width = 494,
      height = 478,
      frame_count = 1,
      direction_count = 1,
      shift = util.by_pixel( -1.5, -5.5),
      scale = 0.4
    }
  },
  {
    type = "explosion",
    name = "foundry-explosion",
    icon = "__bzfoundry__/graphics/icons/electric-foundry.png",
    flags = {"not-on-map"},
    hidden = true,
    subgroup = "smelting-machine-explosions",
    order = "d[foundry]",
    height = 0,
    animations = explosion_animations.big_explosion(),
    smoke = "smoke-fast",
    smoke_count = 2,
    smoke_slow_down_factor = 1,
    sound = sounds.large_explosion(0.7, 1.0),
    created_effect =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-particle",
            repeat_count = 10,
            probability = 1,
            particle_name = "oil-refinery-metal-particle-big",
            offsets =
            {
              { 0.7734, -0.6484 },
              { -0.7266, 0.5859 }
            },
            offset_deviation = { { -0.6875, -0.6875 }, { 0.6875, 0.6875 } },
            initial_height = 0.8,
            initial_height_deviation = 0.49,
            initial_vertical_speed = 0.088,
            initial_vertical_speed_deviation = 0.05,
            speed_from_center = 0.03,
            speed_from_center_deviation = 0.05
          },
          {
            type = "create-particle",
            repeat_count = 38,
            probability = 1,
            particle_name = "oil-refinery-metal-particle-medium",
            offsets = { { 0, 0 }  },
            offset_deviation = { { -0.9805, -0.8867 }, { 0.9805, 0.8867 } },
            initial_height = 0.6,
            initial_height_deviation = 0.5,
            initial_vertical_speed = 0.098,
            initial_vertical_speed_deviation = 0.05,
            speed_from_center = 0.07,
            speed_from_center_deviation = 0.05
          },
          {
            type = "create-particle",
            repeat_count = 10,
            probability = 1,
            particle_name = "foundry-metal-particle-big",
            offsets =
            {
              { -1.492, -1.453 },
              { 1.555, -1.469 },
              { 1.477, 1.469 },
              { -0.6172, 0.3281 }
            },
            offset_deviation = { { -0.9961, -0.5938 }, { 0.9961, 0.5938 } },
            initial_height = 0.4,
            initial_height_deviation = 0.5,
            initial_vertical_speed = 0.075,
            initial_vertical_speed_deviation = 0.05,
            speed_from_center = 0.04,
            speed_from_center_deviation = 0.05
          },
          {
            type = "create-particle",
            repeat_count = 35,
            probability = 1,
            particle_name = "foundry-metal-particle-medium",
            offsets =
            {
              { -0.02344, -0.8984 }
            },
            offset_deviation = { { -0.5, -0.2969 }, { 0.5, 0.2969 } },
            initial_height = 0.7,
            initial_height_deviation = 0.15,
            initial_vertical_speed = 0.166,
            initial_vertical_speed_deviation = 0.047,
            speed_from_center = 0.05,
            speed_from_center_deviation = 0.005
          },
          {
            type = "create-particle",
            repeat_count = 20,
            particle_name = "foundry-metal-particle-small",
            offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
            initial_height = 0.5,
            initial_height_deviation = 0.5,
            initial_vertical_speed = 0.06,
            initial_vertical_speed_deviation = 0.05,
            speed_from_center = 0.04,
            speed_from_center_deviation = 0.05
          },
        }
      }
    }
  }
})

local make_particle = function(params)
  return {
    type = "optimized-particle",
    name = params.name,
    life_time = 60 * 15,
    render_layer = "object",
    render_layer_when_on_ground = "corpse",

    regular_trigger_effect_frequency = 2,
    regular_trigger_effect = params.regular_trigger_effect,
    ended_in_water_trigger_effect = {
      {
        type = "create-particle",
        probability = 1,
        affects_target = false,
        show_in_tooltip = false,
        particle_name = "tintable-water-particle",
        apply_tile_tint = "secondary",
        offset_deviation = { { -0.05, -0.05 }, { 0.05, 0.05 } },
        initial_height = 0,
        initial_height_deviation = 0.02,
        initial_vertical_speed = 0.05,
        initial_vertical_speed_deviation = 0.05,
        speed_from_center = 0.01,
        speed_from_center_deviation = 0.006,
        frame_speed = 1,
        frame_speed_deviation = 0,
        tail_length = 2,
        tail_length_deviation = 1,
        tail_width = 3,
        only_when_visible = true
      },
      {
        type = "create-particle",
        repeat_count = 10,
        repeat_count_deviation = 6,
        probability = 0.03,
        affects_target = false,
        show_in_tooltip = false,
        particle_name = "tintable-water-particle",
        apply_tile_tint = "primary",
        offsets =
        {
          { 0, 0 },
          { 0.01563, -0.09375 },
          { 0.0625, 0.09375 },
          { -0.1094, 0.0625 }
        },
        offset_deviation = { { -0.2969, -0.1992 }, { 0.2969, 0.1992 } },
        initial_height = 0,
        initial_height_deviation = 0.02,
        initial_vertical_speed = 0.053,
        initial_vertical_speed_deviation = 0.005,
        speed_from_center = 0.02,
        speed_from_center_deviation = 0.006,
        frame_speed = 1,
        frame_speed_deviation = 0,
        tail_length = 9,
        tail_length_deviation = 0,
        tail_width = 1,
        only_when_visible = true
      },
      {
        type = "play-sound",
        sound = sounds.small_splash
      }
    },
    pictures = params.pictures,
    shadows = params.shadows,
  }
end

local small_smoke_trigger_effect = function()
  return
  {
    type = "create-trivial-smoke",
    smoke_name = "smoke-explosion-particle-small",
    starting_frame_deviation = 0,
    offset_deviation = {{-0.03, -0.03}, {0.03, 0.03}},
    speed_from_center = nil
  }
end

local default_smoke_trigger_effect = function()
  return
  {
    type = "create-trivial-smoke",
    smoke_name = "smoke-explosion-particle",
    starting_frame_deviation = 5,
    offset_deviation = {{-0.06, -0.06}, {0.06, 0.06}},
    speed_from_center = 0.007
  }
end

data:extend({
  make_particle({
      name = "foundry-metal-particle-small",
      pictures = particle_animations.get_metal_particle_small_pictures({tint = {0.606, 0.408, 0.512, 1}}),
      shadows = particle_animations.get_metal_particle_small_pictures({ tint = shadowtint(), shift = util.by_pixel (1,0)}),
      regular_trigger_effect = nil,
    }),
    make_particle({
      name = "foundry-metal-particle-medium",
      pictures = particle_animations.get_metal_particle_medium_pictures({tint = {0.5, 0.5, 0.5, 1}}),
      shadows = particle_animations.get_metal_particle_medium_pictures({ tint = shadowtint(), shift = util.by_pixel (1,0)}),
      regular_trigger_effect = small_smoke_trigger_effect()
    }),
    make_particle({
      name = "foundry-metal-particle-big",
      pictures = particle_animations.get_metal_particle_big_pictures({tint = {0.65, 0.40, 0.35, 1}}),
      regular_trigger_effect = default_smoke_trigger_effect()
    })
})

futil.add_crafting_category("assembling-machine", "electric-foundry", "basic-founding")
