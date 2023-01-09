local Webserver = Class:extend()

local RoutesList = Import("sh.archelon.shell.Webserver.RoutesList")
local FS = require("fs")
local Json = require("json")

function Webserver:initialize()
    self.App = require("weblit-app")
    local App = self.App
    
    local Tls
    if Archelon.Config:GetOption("Webserver.TLS.Certificate") ~= "" then
        Tls = {
            cert = FS.readFileSync(Archelon.Config:GetOption("Webserver.TLS.Certificate")),
            key = FS.readFileSync(Archelon.Config:GetOption("Webserver.TLS.PrivateKey"))
        }
    end

    App.bind(
        {
            host = Archelon.Config:GetOption("Webserver.Host"),
            port = Archelon.Config:GetOption("Webserver.Port"),
            tls = Tls
        }
    )

    if Archelon.Config:GetOption("Webserver.Debug.Logging") == "true" then
        Archelon.Logger.Info("Enabeling webserver debug logging")
        App.use(require('weblit-logger'))
    end
    App.use(Import("sh.archelon.shell.Webserver.Middleware.Static"))
    App.use(require('weblit-cors'))
    App.use(require('weblit-auto-headers'))
end

function Webserver:LoadRoutes()
    Archelon.Logger.Info("Loading %s webserver routes", #RoutesList)

    for _, Route in pairs(RoutesList) do
        Archelon.Logger.Info("Loading '%s' route '%s'", Route.Method, Route.Path)
        self.App.route(
            {
                method = Route.Method,
                path = Route.Path
            },
            function (Request, Response, Go)
                local RequestHeaders = {}
                for _, Header in pairs(Request.headers) do
                    RequestHeaders[Header[1]] = Header[2]
                end
                local RequestData
                pcall(
                    function ()
                        RequestData = Json.decode(Request.body)
                    end
                )
                local ResponseData = {Body = "Not found", Code = 404, Headers = {}}
                Route.Handler(
                    {
                        Parameters = Request.params,
                        Method = Request.method,
                        Path = Request.path,
                        Body = Request.body,
                        Data = RequestData,
                        Socket = Request.socket,
                        KeepAlive = Request.keepAlive,
                        Version = Request.version,
                        Headers = RequestHeaders,
                    },
                    ResponseData,
                    {}
                )

                Response.body = ResponseData.Body
                Response.code = ResponseData.Code

                if ResponseData.Data then
                    Response.body = Json.encode(ResponseData.Data)
                end
                
                for HeaderKey, HeaderValue in pairs(ResponseData.Headers) do
                    table.insert(
                        Response.headers,
                        {
                            HeaderKey,
                            HeaderValue
                        }
                    )
                end
            end
        )
    end
end

function Webserver:Start()
    self.App.start()
end

return Webserver