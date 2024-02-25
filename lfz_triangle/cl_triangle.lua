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
			local ped = PlayerPedId()
			LoadAnim('random@domestic')
			TaskPlayAnim(ped, 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 50, 0, false, false, false)
			Wait(1000)

			local prop = CreateObject(GetHashKey(Config.PropModel), GetEntityCoords(ped) + GetEntityForwardVector(ped) * 0.50, true)  
			while not DoesEntityExist(prop) do Wait(5) end
			SetEntityHeading(prop, GetEntityHeading(ped))
			PlaceObjectOnGroundProperly(prop)
			FreezeEntityPosition(prop, true)
			ClearPedTasks(ped)
		else 
			print("Prop invalide")
		end
	end, false)

	RegisterCommand(Config.CommandDel, function(source)
		if IsModelValid(Config.PropModel) then
			local ped = PlayerPedId()
			model = GetClosestObjectOfType(GetEntityCoords(ped), 5.0 , GetHashKey(Config.PropModel), 70)
			if model == 0 then print("Aucun props trouvé à proximité") return end
			LoadAnim('random@domestic')
			TaskPlayAnim(ped, 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 50, 0, false, false, false)
			Wait(1000)
			while not NetworkHasControlOfEntity(model) do 
				NetworkRequestControlOfEntity(model) 
				Wait(15) 
			end
			DeleteEntity(model)  
			ClearPedTasks(ped)
		else 
			print("Prop invalide")
		end 
	end, false)	
end)
