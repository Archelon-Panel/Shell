-- See https://github.com/Dot-lua/TypeWriter/wiki/package.info.lua-format for more info

return { InfoVersion = 1, -- Dont touch this

    ID = "ArchelonShell", -- A unique id 
    Name = "Archelon Shell",
    Description = "The panel",
    Version = "1.0.0",

    Author = {
        Developers = {
            "CoreByte"
        },
        Contributors = {}
    },

    Dependencies = {
        Luvit = {
            "truemedian/rethink-luvit",
            "creationix/uuid4",
            "creationix/weblit",
            "creationix/mime",
            "creationix/sha1"
        },
        Git = {},
        Dua = {}
    },

    Contact = {
        Website = "https://archelon.corebyte.me",
        Source = "https://github.com/Archelon-Panel/Shell",
        Socials = {}
    },

    Entrypoints = {
        Main = "sh.archelon.shell"
    }

}
