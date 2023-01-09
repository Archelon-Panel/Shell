
local ExpireTime = 60 * 60 * 24 * 90 -- 90  days

return {
    Method = "POST",
    Path = "/api/v1/auth/session/create",
    Authentication = {},
    Handler = function (Request, Response, User)
        if Request.Data == nil or Request.Data.Password == nil or Request.Data.Email == nil then
            Response.Data = {
                Error = "Please no"
            }
            Response.Code = 504
            return
        end
        Response.Code = 200
        
        local User = ({Archelon.Database.table("Users").filter({Email = Request.Data.Email}):run()})[2][1]
        if not User then
            Response.Data = {
                Error = "NOUSER"
            }
            return
        end

        local GeneratedHash = Archelon.Helpers.AuthHelper.GeneratePasswordHash(Request.Data.Password, User)
        local PasswordHash = User.PasswordHash
        if GeneratedHash == PasswordHash then
            Archelon.Logger.Info("Granting session to %s", User.Email)
            local CreatedSessionId = ({Archelon.Database.table("Sessions").insert(
                {
                    ExpiresAt = os.time() + ExpireTime,
                    UserId = User.Id
                }
            ):run()})[2][1].generated_keys[1]
            Response.Data = {
                SessionToken = CreatedSessionId,
                User = User
            }
            Response.Code = 200
        else
            Response.Data = {
                Error = "WRONGPASSWORD"
            }
            return
        end
    end
}