const Pages = {}
var SelectedPageId

function RegisterPage(Id, Default=false, SelectedClass) {
    const PageData = {
        Id: Id,
        Default: Default,
        SelectedClass: SelectedClass,
        Button: document.getElementById(`page-${Id}`)
    }

    function SelectPage() {
        SelectedPageId = Id
        document.getElementById("contentframe").src = `/pages/${Id}/`

        for (const PageId in Pages) {
            const Page = Pages[PageId]
            if (Page.Button) {
                Page.Button.classList.remove(Page.SelectedClass)
            }
        }

        PageData.Button.classList.add(PageData.SelectedClass)
    }

    if (PageData.Button) {
        PageData.Button.addEventListener(
            "click",
            SelectPage
        )
    }

    Pages[Id] = PageData

    if (Default) {
        SelectPage()
    }
}

window.addEventListener(
    "click",
    function() {
        RegisterPage("admin", false, "active")
        RegisterPage("servers", true, "active")
        RegisterPage("settings", false, "active")
    }
)