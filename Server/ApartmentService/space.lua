--[[
space

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = space.TopLevel('foo')
    print(foobar.Thing)

DESCRIPTION

    A detailed description of the module.

API

    -- Describes each API item using Luau type declarations.

    -- Top-level functions use the function declaration syntax.
    function ModuleName.TopLevel(thing: string): Foobar

    -- A description of Foobar.
    type Foobar = {

        -- A description of the Thing member.
        Thing: string,

        -- Each distinct item in the API is separated by \n\n.
        Member: string,

    }
]]

-- Implementation of space.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Class
local space = {}
space.__index = space


function space.new(ApartmentType: string)
    
    local info = {
        ApartmentType = ApartmentType,
        Occupants = {}
    }
    setmetatable(info, space)
    return info
end

function space:AddPlayer(Player: Player)
    table.insert(self.Players, Player)
end

function space:Disconnect()
    for _, c: RBXScriptConnection in pairs(self.Connections) do
        c:Disconnect()
    end
end

function space:Destroy()
    self:Disconnect()
    
    setmetatable(self, nil)
    table.clear(self)
    table.freeze(self)
end


return space