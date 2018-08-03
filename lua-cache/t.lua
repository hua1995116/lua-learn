local _M = {}
_M.cache = {
    isRun = false,
    time = 0,
    data = '',
}
_M.time = 20

function _M.handle_connect_html() 
    local cjson = require "cjson"
    local data = ngx.arg[1] or ""
        
    local bodyInfo = ngx.ctx.foo
    if bodyInfo == nil then 
        ngx.arg[1] = data
        return
    end
    
    local isreplace = string.find(data, "<body>", 1) 
    if isreplace == nil then 
        ngx.arg[1] = data
    else
        local decodeData = cjson.decode(bodyInfo).jsSource
        local formatPercentStr = string.gsub(decodeData, '%%', '%%%%')
        local html = string.gsub(data, "<body>", "<body>"..formatPercentStr)
        ngx.arg[1] = html 
    end
end

function _M.requestUrl()
    local http = require "resty.http"
    local httpc = http.new()
    httpc:set_timeout(500)
    local resp, err = httpc:request_uri("")
    if not resp then  
        ngx.say("request error :", err)  
        return  
    end
    print('time=========update')
    _M.cache.isRun = true
    _M.cache.time = os.time()
    _M.cache.data = resp.body
end

function _M.updateCache(premature)
    if premature then
        return
    end
    _M.requestUrl()
    local ok, err = ngx.timer.at(_M.time, _M.updateCache)
    if not ok then
        ngx.log(ngx.ERR, "failed to create the timer: ", err)
        _M.cache.isRun = false
        return
    end
end

function _M.handle_access_request()
    local nowTime = os.time()
    if (nowTime - _M.cache.time > 20) and (not _M.cache.isRun) then 
        _M.requestUrl()
        _M.updateCache()
    end
    ngx.ctx.foo =  _M.cache.data
end

return _M
