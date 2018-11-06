local redis = require("code.utils.rediscli")

local red = redis.new({host = "redis"})
local res, err = red:exec(
    function(red)
        red:set("test-key", "测试value")
        return red:get("test-key")
    end
)
ngx.say("test-key: ", res)

-- 遍历 key value
local keys, err = red:exec(
    function(red)
        return red:keys("*")
    end
)
ngx.say("<br /> redis: <br />")
for i, v in ipairs(keys) do
    local rk, err = red:exec(
        function(red)
            return red:get(v)
        end
    )
    ngx.say("<br />"..v..": " .. rk)
end