local Resources = TypeWriter.LoadedPackages["ArchelonShell"].Resources
local Mimes = require('mime')

return function (Request, Response, Next)
    local Path = Request.path

    local ResourcePath
    if Resources[string.format("/Frontend%s", Path)] then
        ResourcePath = string.format("/Frontend%s", Path)
    elseif Resources[string.format("/Frontend%sindex.html", Path)] then
        ResourcePath = string.format("/Frontend%sindex.html", Path)
    elseif Resources[string.format("/Frontend%s/index.html", Path)] then
        ResourcePath = string.format("/Frontend%s/index.html", Path)
    else
        return Next()
    end

    Response.code = 200
    Response.body = Resources[ResourcePath]

    Response.headers["Content-Type"] = Mimes.getType(ResourcePath)
    Response.headers["Content-Length"] = #Response.body
    Response.headers["Cache-Control"] = 'public, max-age=' .. 0
end