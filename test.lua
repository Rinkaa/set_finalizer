local set_finalizer = require "set_finalizer"

local counter = 0
local initializer = function (name)
  counter = counter + 1
  return {name = name}
end
local finalizer = function (t)
  counter = counter - 1
  print("gc: " .. t.name)
end

local t = set_finalizer(initializer("outer"), finalizer)
assert(counter == 1)
do
  -- Deliberately overshadowing t
  local t = set_finalizer(initializer("inner"), finalizer)
  collectgarbage()
  assert(counter == 2)
  t = nil
  collectgarbage()
  assert(counter == 1)
end
collectgarbage()
assert(counter == 1)
t = nil
collectgarbage()
assert(counter == 0)

print("Ok!")
return true
