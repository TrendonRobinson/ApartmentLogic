--// Services
local Players = game:GetService("Players")

--// Modules
local apartment: { new: (Player: Player) -> apartmentClass} = require(script.apartment)
local space: { new: (Owner: Player, ApartmentType: string) -> apartmentSpace} = require(script.apartment)

--// Events
local ApartmentEntered: RemoteEvent
local GetApartment: RemoteFunction

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

    new: () -> nil;
    Init: () -> nil;
    listen: () -> nil;
    checkOccupants: () -> nil;
    Disconnect: () -> nil;
    Destroy: () -> nil;
}

type apartmentSpace = {
    Owner: Player,
    ApartmentType: string,
    Occupants: {
        [number]:Player
    }
}


--// Variables
local Apartments: {[Player]: apartmentClass} = {}
local Spaces: apartmentSpace = {}
local ApartmentMethods

--// Module
local ApartmentService = {}


function ApartmentService.new()
    
end


--// CRUD function sorting


--// Create
function ApartmentService.CreatePocket(Player: Player): nil
    local desiredPocket = ApartmentService.GetPocket(Player)

    if desiredPocket then
        warn(Player, 'owns pocket already, destroying previous and removing players') -- Just in case some bug happens 
        desiredPocket:Destroy()
    else 
        Apartments[Player] = apartment.new(Player)
    end
end

function ApartmentService.CreateSpace(Owner: Player, ApartmentType: string): apartmentSpace
    local desiredPocket = ApartmentService.GetSpace(ApartmentType)

    if desiredPocket then
        return desiredPocket
    else 
        Spaces[Owner] = space.new(Owner, ApartmentType)
        return Spaces[Owner]
    end
end



--// Read
function ApartmentService.GetPocket(Player: Player): apartmentClass | false
    local desiredPocket = Apartments[Player]

    if desiredPocket then
        return desiredPocket
    end

    return false
end

function ApartmentService.GetSpace(Owner: number, ApartmentType: string): apartmentSpace | false
    local desiredSpace = Spaces[Owner]

    if desiredSpace then
        return ApartmentType
    end

    return false
end

function ApartmentService.GetApartment(Player: Player, Host: Player)
    local desiredPocket = ApartmentService.GetPocket(Player)

    if desiredPocket then

        local ApartmentType = ApartmentService.GetPocket(Host)
        local desiredSpace = ApartmentService.GetSpace(Host)

        return desiredPocket, desiredSpace
    else 
        return warn('Apartment does not exist')
    end
end


--// Update

--// Should run when a player is added to the invite list
function ApartmentService.UpdatePocket(Player: Player, Host: Player) 
    local desiredPocket = ApartmentService.GetPocket(Player)

    if desiredPocket then
        table.insert(desiredPocket.Invited, Player)
    end
end

--// Should run when a player initiates entering an apartment
function ApartmentService.UpdateSpace(Player: Player, Host: Player) 
    local desiredPocket = ApartmentService.GetPocket(Player)

    if desiredPocket then
        local desiredSpace = ApartmentService.GetSpace(desiredPocket.ApartmentType)
        table.insert(desiredSpace.Occupants, Player)
    end
end


--// Destroy
function ApartmentService.DestroyPocket(Player: Player): nil
    local desiredPocket = ApartmentService.GetPocket(Player)

    if desiredPocket then
        desiredPocket:Destroy()
    else 
        warn(Player, 'does not have a pocket')
    end
end

function ApartmentService.DestroySpace(Player: Player): nil
    local desiredPocket = ApartmentService.GetPocket(Player)

    if desiredPocket then
        desiredPocket:Destroy()
    else 
        warn(Player, 'does not have a pocket')
    end
end


GetApartment.OnClientInvoke(ApartmentService.GetApartment)
Players.PlayerRemoving(ApartmentService.DestroyPocket)



return ApartmentService