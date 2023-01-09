local AuthHelper = {}

local Sha256 = Import("me.corebyte.sha").sha256

function AuthHelper.GeneratePasswordHash(Password, User)
    return Sha256(Password .. User.PasswordSalt)
end

return AuthHelper