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
    ngx.say("valid request")
else
    -- ngx.say("invalid request")
    ngx.exit(401)
end

local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("redis", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

local tutorial, err = red:get("tutorial-name")
if not tutorial then
    ngx.say("tutorial-name err: ", err)
    return
end
ngx.say("<br />redis connected. key: tutorial-name: ", tutorial)