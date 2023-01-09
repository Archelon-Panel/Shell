return {
    Method = "GET",
    Path = "/api/v1/ping",
    Authentication = {},
    Handler = function (Request, Response, User)
        Response.Body = string.format("Running Archelon/Shell@%s", TypeWriter.LoadedPackages.ArchelonShell.Package.Version)
        Response.Code = 200
    end
}