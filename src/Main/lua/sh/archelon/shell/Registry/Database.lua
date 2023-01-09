return function (Database)
    Archelon.Logger.Info("Loading database")
    Database = Database.r

    if not ({Database.db_list().contains("Archelon"):run()})[2][1] then
        Archelon.Logger.Info("Creating Archelon database")
        Database.db_create('Archelon'):run()
    end
    Database = Database.db("Archelon")

    local function CreateTableIfMissing(Name)
        local Exists = ({Database.table_list().contains(Name):run()})[2][1]
        if Exists == false then
            Archelon.Logger.Info("Creating %s database table", Name)
            Database.table_create(
                Name,
                {
                    primary_key = "Id"
                }
            ):run()
        end
    end

    CreateTableIfMissing("Nodes")
    CreateTableIfMissing("Roles")
    CreateTableIfMissing("Servers")
    CreateTableIfMissing("Sessions")
    CreateTableIfMissing("Settings")
    CreateTableIfMissing("Users")

    if not not ({Database.table("Users").get("Administrator"):run()})[2][1].Name == false then
        Archelon.Logger.Info("Creating default user")
        local User = {
            Id = 'Administrator',
            Name = 'Administrator',
            Administrator = true,
            Email = 'admin@archelon.corebyte.me',
            PasswordSalt = string.random(16)
        }
        User.PasswordHash = Archelon.Helpers.AuthHelper.GeneratePasswordHash("Admin", User)
        Database.table("Users").insert(User):run()
    end

    return Database
end