--[[
apartment

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = apartment.TopLevel('foo')
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

-- Implementation of apartment.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Class
local apartment = {}
apartment.__index = apartment

export type apartmentInfo = {
    Owner: Player,
    Name: string,
    ApartmentType: string,
    Invited: {
        Player
    },
    PlayerLeft: BindableEvent,
    Connections: {
        [string]: RBXScriptConnection
    }
}

export type apartmentPlayerInfo = {Inside: boolean}

export type apartmentClass = {
    Id: string | number;
    Owner: Player,
    Name: string,
    ApartmentType: string,
    Invited: {
        Player
    },
    PlayerLeft: BindableEvent,
    Connections: {
        [string]: RBXScriptConnection
    },

    new: () -> nil;
    Init: () -> nil;
    listen: () -> nil;
    checkOccupants: () -> nil;
    Disconnect: () -> nil;
    Destroy: () -> nil;
}


function apartment.new(_Owner: Player, _ApartmentType: string)
    
    local info: apartmentInfo = {
        Owner = _Owner,
        ApartmentType = _ApartmentType,
        Players = {},
        PlayerLeft = Instance.new('BindableEvent'),
        Connections = {}
    }
    setmetatable(info, apartment)
    return info
end

function apartment:checkOccupants()
    local self: apartmentClass = self
    local temp = 0
    
    for index: Player, value: apartmentPlayerInfo in pairs(self.Players) do
        if value.Inside then
            temp += 1
        end
    end

    if temp == 0 then
        self:Destroy()
    end
end

function apartment:listen()
    local self: apartmentClass = self

    self.PlayerLeft.Event:Connect(function()
        self:checkOccupants()
    end)

end

function apartment:Init()
    
end

function apartment:Disconnect()
    for _, c: RBXScriptConnection in pairs(self.Connections) do
        c:Disconnect()
    end
end

function apartment:Destroy()
    self:Disconnect()
    
    setmetatable(self, nil)
    table.clear(self)
    table.freeze(self)
end


return apartment