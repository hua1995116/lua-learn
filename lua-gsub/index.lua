local st = "%sada %sa";

local st2 = string.gsub(st, '%%', '%%%%');

-- local html = string.gsub(st, 's', st2);

print(st2);