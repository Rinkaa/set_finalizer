local function _initialize_proxy(t, finalizer)
  local proxy
  if _VERSION == "Lua 5.1" then
    proxy = newproxy(true)
  else
    proxy = setmetatable({}, {__gc = true})
  end
  getmetatable(proxy).finalizer = function ()
    return finalizer(t)
  end
  return proxy
end
local function _finalize_proxy(proxy)
  local finalizer = getmetatable(proxy).finalizer
  return finalizer()
end
local function set_finalizer(t, finalizer)
  local gc_proxy = _initialize_proxy(t, finalizer)
  if not getmetatable(t) then setmetatable(t, {}) end
  getmetatable(t).gc_proxy = gc_proxy
  getmetatable(gc_proxy).__gc = _finalize_proxy
  return t
end

return set_finalizer
