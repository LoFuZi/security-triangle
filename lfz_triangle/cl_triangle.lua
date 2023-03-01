print("La ressource à démarée, la commande est /"..Config.Command)

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/'..Config.Command, 'Permet de faire poser un triangle au sol', {})

    RegisterCommand(Config.Command, function(source)
        if IsModelValid(Config.PropModel) then    
			LoadAnim('random@domestic')
			TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 50, 0, false, false, false)
			Wait(1000)
            local devant = -0.50
	        local coords = GetEntityCoords(GetPlayerPed(-1)) + GetEntityForwardVector(GetPlayerPed(-1)) * - devant
			local headingJoueur = GetEntityHeading(GetPlayerPed(-1))
			local prop = CreateObject(GetHashKey(Config.PropModel), coords, true)  
			local closeprop = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1)), 1.5, GetHashKey(Config.PropModel), 70)
			SetEntityHeading(closeprop, headingJoueur)
			PlaceObjectOnGroundProperly(closeprop)

			local pCoords = GetEntityCoords(closeprop) 
			local _, ground = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true)
			
			SetEntityCoords(closeprop, pCoords.x, pCoords.y, ground, true, false, false, false) 

			FreezeEntityPosition(closeprop, true)
			ClearPedTasks(GetPlayerPed(-1))
		else 
			print("props invalide")
			return
		end
	end, false)

	RegisterCommand(Config.CommandDel, function(source)
		if IsModelValid(Config.PropModel) then
			LoadAnim('random@domestic')
			TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 50, 0, false, false, false)
			Wait(1000)
			model = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1)), 5.0 , GetHashKey(Config.PropModel), 70)
			DeleteEntity(model)  
			ClearPedTasks(GetPlayerPed(-1))
		else 
			print("pas de props")
			return
		end 
	end, false)	
end)