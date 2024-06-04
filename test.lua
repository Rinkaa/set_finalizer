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

-- Basic
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

-- Replace existing finalizer
local finalizer_error = function (t)
  counter = counter - 1
  error("Should not reach here!")
end
local t2 = set_finalizer(initializer("replace"), finalizer_error)
collectgarbage()
assert(counter == 1)
set_finalizer(t2, finalizer)
t2 = nil
collectgarbage()
assert(counter == 0)

t2 = set_finalizer(initializer("replace_2"), finalizer)
collectgarbage()
assert(counter == 1)
set_finalizer(t2, nil) -- Don't use a finalizer any more
t2 = nil
collectgarbage()
assert(counter == 1)
counter = 0

print("Ok!")
return true
