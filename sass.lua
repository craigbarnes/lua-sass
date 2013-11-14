-- The C module is named lsass to avoid name clashes with the dynamic
-- linker. This is a simple shim to allow loading via `require "sass"`.
return require "lsass"
