print("Hello World!")

--Load libraries
local Resources = TypeWriter.LoadedPackages["ArchelonShell"].Resources
TypeWriter.Runtime.LoadJson(Resources["/Libraries/Sha2.twr"])
TypeWriter.Runtime.LoadInternal("Config")

_G.Archelon = {}
Archelon.Logger = TypeWriter.Logger
Archelon.Dev = process.env.ARCHELON_DEV == "true"
Archelon.Config = Import("sh.archelon.shell.Registry.Config")(
    Import("ga.corebyte.Config"):new("./ArchelonShell.properties")
):Parse()
Archelon.Helpers = {
    AuthHelper = Import("sh.archelon.shell.Helper.AuthHelper")
}
Archelon.Database = require('rethink-luvit').Connection.new(
    {
        host = Archelon.Config:GetOption("Database.Host"),
        port = Archelon.Config:GetOption("Database.Port"),
        username = Archelon.Config:GetOption("Database.User"),
        password = Archelon.Config:GetOption("Database.Password"),
        database = "Archelon"
    }
)
Archelon.Database:connect()
Archelon.Database = Import("sh.archelon.shell.Registry.Database")(Archelon.Database)
Archelon.Webserver = Import("sh.archelon.shell.Webserver"):new()
Archelon.Webserver:LoadRoutes()
Archelon.Webserver:Start()