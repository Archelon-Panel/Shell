return function (Config)
    
    Archelon.Logger.Info("Loading config options")
    Config:AddOption("Webserver.Host", "127.0.0.1")
    Config:AddOption("Webserver.Port", "443")
    Config:AddOption("Webserver.TLS.Certificate", "")
    Config:AddOption("Webserver.TLS.PrivateKey", "")
    Config:AddOption("Webserver.Debug.Logging", "false")
    Config:AddLine()
    Config:AddOption("Database.Host", "localhost")
    Config:AddOption("Database.Port", 28015)
    Config:AddOption("Database.User", "admin")
    Config:AddOption("Database.Password", "")

    return Config
end