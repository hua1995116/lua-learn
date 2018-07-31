local p = "/usr/local/etc/openresty/nginx/config/lua_src"
local m_package_path = package.path
package.path = string.format("%s?.lua;%s?/init.lua;%s", p, p, m_package_path)
cmd = require("t")
cjson = require "cjson"
http = require "resty.http"