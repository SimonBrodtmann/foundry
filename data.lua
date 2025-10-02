local util = require("data-util")

require("prototypes/categories")

if util.me.enable() then
  require("prototypes/coke")
  require("prototypes/foundry")
  require("prototypes/entity/electric-foundry")
  require("prototypes/entity/foundry")
end
