# set_finalizer.lua

A simple solution that allows tables to have finalizers in Lua 5.1 / LuaJIT, for those who find the `__gc` metamethod doesn't work for tables in these versions.
This snippet of code provides a function called `set_finalizer`, which modifies the metatable of the table you wish to have a finalizer. When the table is garbage-collected, the finalizer is automatically called.

## Usage

```lua
local set_finalizer = require "set_finalizer"
t = set_finalizer(t, finalizer)
```

That's it. `finalizer` is a function that takes `t` as its parameter just like the `__gc` method in Lua 5.2 ~ 5.4.

## Caveats

- This snippet of code directly modifies the metatable of the provided table, writing a `gc_proxy` field in it. Take special care when the metatable is intended to be shared among multiple tables!
- This snippet of code is also compatible with Lua 5.2 ~ 5.4, however calling this will have additional cost than using `__gc` directly. This is because whether the metatable already has a `__gc` field is unknown, and setting the field after the metatable is set for the table does not mark the table for finalization.
- This snippet of code assumes the finalizer of each table is called only once, and does not handle ressurecting(reviving the table by adding reference count during the call of the finalizer).

## License

MIT
