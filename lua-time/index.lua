local time = os.time();

function sleep(n)
    os.execute("sleep " .. n)
end

sleep(5)

local nowTime = os.time();

print(nowTime - time);