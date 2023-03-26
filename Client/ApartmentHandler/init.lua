--[[
ApartmentHandler

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = ApartmentHandler.TopLevel('foo')
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

-- Implementation of ApartmentHandler.

--// Types
type apartmentClass = {
    Id: string | number;
    Owner: Player,
    Name: string,
    ApartmentType: string,
    Invited: {
        [number]:Player
    },
    PlayerLeft: BindableEvent,
    Connections: {
        [string]: RBXScriptConnection
    },
}

type apartmentSpace = {
    Owner: Player,
    ApartmentType: string,
    Occupants: {
        [number]:Player
    }
}

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")


--// Variables
local ApartmentEntered: RemoteEvent
local GetApartment: RemoteFunction

local ApartmentModels: Folder
local ApartmentSpaces: Folder


--// Class
local ApartmentHandler = {}
ApartmentHandler.__index = ApartmentHandler


function ApartmentHandler.new()
    
    local info = {
        Connections = {}
    }
    setmetatable(info, ApartmentHandler)
    return info
end

function ApartmentHandler:HideCharacter(Character: Model)
    for index, value: BasePart | MeshPart in pairs(Character:GetDescendants()) do
        if value:IsA('MeshPart') or value:IsA('BasePart') then
            value.Transparency = 1
        end
    end
end

function ApartmentHandler:Entered(Host: Player)
    local desiredPocket: apartmentClass, desiredSpace: apartmentSpace = GetApartment:InvokeServer(Host)

    local CurrentApartmentModel = ApartmentModels.CurrentApartmentName:Clone()
    CurrentApartmentModel.Parent = ApartmentSpaces

    for i, v:Player in pairs(Players:GetPlayers()) do
        if not table.find(desiredSpace.Occupants, v) then
            local Character = v.Character or v.CharacterAdded:Wait()
            self.Connections[v.Name] = v.CharacterAdded
            self:HideCharacter(Character)
        end
    end
end

function ApartmentHandler:Init()
    ApartmentEntered.OnServerEvent:Connect(function(player)
        self:Entered()
    end)
end

function ApartmentHandler:Disconnect()
    for _, c: RBXScriptConnection in pairs(self.Connections) do
        c:Disconnect()
    end
end

function ApartmentHandler:Destroy()
    self:Disconnect()
    
    setmetatable(self, nil)
    table.clear(self)
    table.freeze(self)
end


return ApartmentHandler