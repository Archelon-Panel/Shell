window.addEventListener(
    "load",
    async function() {
        const LoginButton = document.getElementById("loginbutton")

        function SetError(Error) {
            document.getElementById("error").innerText = `Error: ${Error}`
        }

        function SetButtonState(State) {
            if (State) {
                LoginButton.innerText = "Login"
                LoginButton.removeAttribute("disabled")
            } else {
                LoginButton.innerText = "Loading..."
                LoginButton.setAttribute("disabled", true)
            }
        }

        LoginButton.addEventListener(
            "click",
            async function() {
                SetButtonState(false)
                const Email = document.getElementById("emailinput").value
                p(Email)
                const Password = document.getElementById("passwordinput").value
                p(Password)

                if (Email == "" || Password == "") {
                    SetError("Please fill in all the fields")
                    SetButtonState(true)
                    return
                }

                const AuthData = (await Archelon.HTTP.APIRequest(
                    "POST",
                    "/api/v1/auth/session/create",
                    {},
                    {
                        Email: Email,
                        Password: Password
                    }
                )).Data
                p(AuthData)

                if (AuthData.Error) {
                    const Error = AuthData.Error
                    if (Error == "NOUSER") {
                        SetError("There was no email found with that account")
                    }
                    if (Error == "WRONGPASSWORD") {
                        SetError("The password does not seem to match with the email")
                    }

                    return SetButtonState(true)
                }

                localStorage.User = AuthData.User
                localStorage.SessionToken = AuthData.SessionToken
                location.href = "/"
            }
        )
    }
)