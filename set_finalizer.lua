local function _initialize_proxy()
  local proxy
  if _VERSION == "Lua 5.1" then
    proxy = newproxy(true)
  else
    proxy = setmetatable({}, {__gc = true})
  end
  return proxy
end
local function _assign_to_proxy(t, proxy, finalizer)
  local proxy_finalizer = finalizer and function ()
    return finalizer(t)
  end or nil
  getmetatable(proxy).finalizer = proxy_finalizer
end
local function _finalize_proxy(proxy)
  local proxy_finalizer = getmetatable(proxy).finalizer
  if proxy_finalizer then
    return proxy_finalizer()
  else
    return nil
  end
end
local function set_finalizer(t, finalizer)
  local meta = getmetatable(t)
  if not meta then
    meta = {}
    setmetatable(t, meta)
  end
  if not meta["gc_proxy"] then
    local gc_proxy = _initialize_proxy()
    getmetatable(gc_proxy).__gc = _finalize_proxy
    meta["gc_proxy"] = gc_proxy
  end
  _assign_to_proxy(t, meta["gc_proxy"], finalizer)
  return t
end

return set_finalizer

