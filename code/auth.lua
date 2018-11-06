ngx.req.read_body()
local args, err = ngx.req.get_uri_args()

local http = require "resty.http"
local httpc = http.new()
local res, err = httpc:request_uri(
    "http://127.0.0.1:81/spe_md5",
        {
        method = "POST",
        body = args.data,
        }
)

if 200 ~= res.status then
    ngx.exit(res.status)
end

if args.key == res.body then
    ngx.say("<b>valid request.</b>")
else
    -- ngx.say("invalid request")
    ngx.exit(401)
end

-- redis test
local redis = require("code.utils.rediscli")

local red = redis.new({host = "redis"})
local tutorial, err = red:exec(
    function(red)
        -- 发布测试
        red:publish("chat", "http 测试赛")
        return red:get("tutorial-name")
    end
)
ngx.say("<br />redis key: tutorial-name: ", tutorial)

ngx.say("<br />" .. os.date("%y.%m.%d %H:%M:%S %A %B"))