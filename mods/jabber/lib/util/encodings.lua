local function e()
error("Function not implemented");
end
local e=require"mime";
module"encodings"
stringprep={};
base64={encode=e.b64,decode=e.unb64};
return _M;
