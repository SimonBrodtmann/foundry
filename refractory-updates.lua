local rusty_locale = require("__rusty-locale__.locale")
local rusty_icons = require("__rusty-locale__.icons")
local futil = require("util")
local util = require("data-util")

function has_suffix(s, suffix)
  return string.sub(s, -string.len(suffix), -1) == suffix
end

function has_prefix(s, prefix)
  return string.sub(s, 1, string.len(prefix)) == prefix
end

function is_space(name) 
  return name:match("holmium") or name:match("beryllium") or name:match("iridium")
end

local suffixes = {"-plate", "-ingot"}
function check_name(name)
  for i, suffix in pairs(suffixes) do
    if has_suffix(name, suffix) then return true end
  end
  if name == "kr-rare-metals" then return true end
  if name == "tungsten-carbide" then return true end
  return false
end

function make_recipe(recipe)
  local found_result = false
  local new_results = {}

  if recipe.results then -- standard recipes
    for i, result in pairs(recipe.results) do
      if result.name and check_name(result.name) then
        found_result = result.name
        new_results = futil.table.deepcopy(recipe.results)
        break
      end
    end
  end

  if found_result then
    log("Attempting to make refractory recipe for " .. recipe.name)
    local r = futil.table.deepcopy(recipe)
    r.name = r.name .. "-refractory"
    r.main_product = found_result
    r.results = {}
    r.enabled = false
    r.category = recipe.category == "casting" and "casting" or "founding"
    r.subgroup = data.raw.item[found_result] and data.raw.item[found_result].subgroup or "foundry-intermediate"
    icons = rusty_icons.of(data.raw.recipe[recipe.name])
    table.insert(
        icons,
        (mods.bzcarbon and
         { icon = "__bzcarbon__/graphics/icons/graphite-2.png",
           icon_size = 128, scale=0.125, shift={8, -8}})
        or (mods.bzsilicon and
            { icon = "__bzsilicon__/graphics/icons/silica.png",
              icon_size = 64, scale=0.25, icon_mipmaps = 3, shift={8, -8}})
        or (mods.bzzirconium and
            { icon = "__bzzirconium__/graphics/icons/zirconia.png",
              icon_size = 128, scale=0.125, shift={8, -8}})
        or (mods.bzaluminum and
            { icon = "__bzaluminum__/graphics/icons/alumina.png",
              icon_size = 128, scale=0.125, shift={8, -8}})
        or { icon = "__base__/graphics/icons/stone-brick.png",
             icon_size = 64, scale=0.25, icon_mipmaps = 4, shift={8, -8}}
    )
    r.icons = icons
    locale = rusty_locale.of_recipe(data.raw.recipe[recipe.name])
    r.localised_name = {"recipe-name.with-refractory", locale.name}
    r.results = new_results
    make_ingredients_and_products(r, r.name)
    r.allow_productivity = true
    return r
  end
  return nil
end


-- Gets refractories for a recipe (currently all recipes use same refractories)
-- TODO make this more varied and interesting based on reality
function get_refractories(recipe, name)
  local refractories = {}
  if mods.bzcarbon then table.insert(refractories, "graphite") end
  if mods.bzsilicon then table.insert(refractories, "silica") end
  if #refractories < 2 and mods.bzzirconium and name ~= "zirconium-plate-refractory" then table.insert(refractories, "zirconia") end
  if #refractories < 2 and mods.bzaluminum and name ~= "aluminum-plate-refractory" then table.insert(refractories, "alumina") end
  if #refractories < 2 then table.insert(refractories, "stone-brick") end
  return refractories
end

function make_ingredients_and_products(r, name)
  local refractories = get_refractories(r, name)
  local max_count = 1
  for i, ingredient in pairs(r.ingredients) do
    if ingredient.amount and ingredient.amount > max_count then
      max_count = ingredient.amount
    end
  end
  local refractory_amount = max_count
  -- For space exploration, most ingots use 25 times less refractory
  if mods["space-exploration"] and (has_suffix(name, "-ingot-refractory") or name == "tungsten-carbide-casting-refractory") then
      if refractory_amount > 25 then refractory_amount = refractory_amount / 25 end
  end
  for i, refractory in pairs(refractories) do
    for j, existing in pairs(r.ingredients) do
      if existing.name == refractory then
        log("Warning: "..name.." refractory recipe recipe unbalanced due to skipped ingredients")
        goto skip
      end
    end
    table.insert(r.ingredients, {type = "item", name = refractory, amount = refractory_amount})
  end
  ::skip::

  for i, result in pairs(r.results) do
    if result.name and check_name(result.name) then
      if result.amount then
        result.amount = result.amount * 2
      end
      if result.amount_min then
        result.amount_min = result.amount_min * 2
      end
      if result.amount_max then
        result.amount_max = result.amount_max * 2
      end
      break
    end
  end
  for i, refractory in pairs(refractories) do
    table.insert(r.results, {type="item", name=refractory, amount=refractory_amount, ignored_by_productivity=refractory_amount,
        ignored_by_stats=refractory_amount, probability=get_probability(#refractories)})
  end
end

local roots = {0.5, 0.7, 0.8, 0.84, 0.87, 0.89, 0.9}
-- returns approx nth root of 0.5
function get_probability(n)
  return roots[n]
end

if util.me.founding_plates() then
  local new_recipes = {}
  for name, recipe in pairs(data.raw.recipe) do 
    if not (recipe.category == "smelting" or (mods["space-exploration"] and recipe.category == "casting")) then goto continue end
    if (name == "steel-plate" or
        name == "imersium-plate" or
        name == "tungsten-carbide" or  -- exclude base recipe but not casting recipe
        (name == "glass" and mods.bztin) or -- exclude glass when tin is in use, thematically
        name == "se-naquium-ingot") then goto continue end
    local new_recipe = make_recipe(recipe )
    if new_recipe then
      table.insert(new_recipes, new_recipe)
    end
    ::continue::
  end
  data:extend(new_recipes)
  for i, recipe in pairs(new_recipes) do
    -- recipe unlock
    if is_space(recipe.name) and data.raw.technology["advanced-founding-space"] then
      util.add_effect("advanced-founding-space", {type="unlock-recipe", recipe=recipe.name})
    else
      util.add_effect("advanced-founding", {type="unlock-recipe", recipe=recipe.name})
    end
  end
end
