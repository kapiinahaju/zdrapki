ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local isScratching = false
local open = false

RegisterNetEvent('flux_scratchcard:draw')
AddEventHandler('flux_scratchcard:draw', function(type)
	TriggerServerEvent('flux_scratchcard:draw', type)
end)

RegisterNetEvent('flux_scratchcard:showSC')
AddEventHandler('flux_scratchcard:showSC', function(nuiSC)
	if isScratching == false then
		ESX.UI.Menu.CloseAll()
		isScratching = true
		open = true
		Citizen.Wait(100)
		TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, false)
		SetNuiFocus(true, true)
		SendNUIMessage({type = 'showNUI', value = nuiSC})
	end
end)

RegisterNUICallback('NUIFocusOff', function()
	open = false
	isScratching = false
	SetNuiFocus(false, false)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	TriggerServerEvent('flux_scratchcard:payment')
end)