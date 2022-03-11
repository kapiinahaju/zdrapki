ESX						= nil
local nuiSC				= nil
local ScratchTable 		= {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('flux_scratchcard:payment')
AddEventHandler('flux_scratchcard:payment', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local payment = GetPayment(xPlayer.identifier)
	UpdateScratch(xPlayer.identifier, false, nil)
	if payment > 0 then
		xPlayer.addMoney(payment)
	end
end)

RegisterServerEvent('flux_scratchcard:draw')
AddEventHandler('flux_scratchcard:draw', function(type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local percent = math.random(1,100)
	if type == 'silver' then
		if percent <= 30 then
			local whichPayment = math.random(1,100)
			-- 1 -> 25% ; 2 -> 30% ; 3 -> 30% ; 4 -> 10% ; 5 -> 5%
			if whichPayment <= 25 then
				payment = 1000
				nuiSC = 'swin1'
			elseif whichPayment > 25 and whichPayment <= 55 then
				payment = 2000
				nuiSC = 'swin2'
			elseif whichPayment > 55 and whichPayment <= 85 then
				payment = 5000
				nuiSC = 'swin3'
			elseif whichPayment > 85 and whichPayment <= 95 then
				payment = 10000
				nuiSC = 'swin4'
			elseif whichPayment > 95 then
				payment = 20000
				nuiSC = 'swin5'
			end
			UpdateScratch(xPlayer.identifier, nil, payment)
			TriggerClientEvent('flux_scratchcard:showSC', _source, nuiSC)
		else
			payment = 0
			nuiSC = 'sloss' .. tostring(math.random(1,11))
			UpdateScratch(xPlayer.identifier, nil, payment)
			TriggerClientEvent('flux_scratchcard:showSC', _source, nuiSC)
		end
	elseif type == 'gold' then
		if percent <= 22 then
			local whichPayment = math.random(1,100)
			-- 1 -> 25% ; 2 -> 30% ; 3 -> 30% ; 4 -> 10% ; 5 -> 5%
			if whichPayment <= 25 then
				payment = 5000
				nuiSC = 'gwin1'
			elseif whichPayment > 25 and whichPayment <= 55 then
				payment = 10000
				nuiSC = 'gwin2'
			elseif whichPayment > 55 and whichPayment <= 85 then
				payment = 20000
				nuiSC = 'gwin3'
			elseif whichPayment > 85 and whichPayment <= 95 then
				payment = 35000
				nuiSC = 'gwin4'
			elseif whichPayment > 95 then
				payment = 50000
				nuiSC = 'gwin5'
			end
			UpdateScratch(xPlayer.identifier, true, payment)
			TriggerClientEvent('flux_scratchcard:showSC', _source, nuiSC)
		else
			payment = 0
			nuiSC = 'gloss' .. tostring(math.random(1,10))
			UpdateScratch(xPlayer.identifier, true, payment)
			TriggerClientEvent('flux_scratchcard:showSC', _source, nuiSC)
		end
	elseif type == 'platinum' then
		if percent <= 15 then
			local whichPayment = math.random(1,100)
			-- 1 -> 25% ; 2 -> 30% ; 3 -> 30% ; 4 -> 10% ; 5 -> 5%
			if whichPayment <= 25 then
				payment = 25000
				nuiSC = 'pwin1'
			elseif whichPayment > 25 and whichPayment <= 55 then
				payment = 40000
				nuiSC = 'pwin2'
			elseif whichPayment > 55 and whichPayment <= 85 then
				payment = 65000
				nuiSC = 'pwin3'
			elseif whichPayment > 85 and whichPayment <= 95 then
				payment = 100000
				nuiSC = 'pwin4'
			elseif whichPayment > 95 then
				payment = 200000
				nuiSC = 'pwin5'
			end
			UpdateScratch(xPlayer.identifier, true, payment)
			TriggerClientEvent('flux_scratchcard:showSC', _source, nuiSC)
		else
			payment = 0
			nuiSC = 'ploss' .. tostring(math.random(1,12))
			UpdateScratch(xPlayer.identifier, true, payment)
			TriggerClientEvent('flux_scratchcard:showSC', _source, nuiSC)
		end
	end
end)

function UpdateScratch(identifier, bool, payment)
	for i=1, #ScratchTable, 1 do
		if ScratchTable[i].user == identifier then
			if bool ~= nil then
				ScratchTable[i].isUsing = bool
			end
			if payment ~= nil then
				ScratchTable[i].payment = payment
			end
			break
		end
	end
	return
end

function GetPayment(identifier)
	local found = false
	for i=1, #ScratchTable, 1 do
		if ScratchTable[i].user == identifier then
			found = true
			return ScratchTable[i].payment
		end
	end
	if found == false then
		table.insert(ScratchTable, {user = identifier, isUsing = false, payment = 0})
		return false
	end
end

function GetScratch(identifier)
	local found = false
	for i=1, #ScratchTable, 1 do
		if ScratchTable[i].user == identifier then
			found = true
			return ScratchTable[i].isUsing
		end
	end
	if found == false then
		table.insert(ScratchTable, {user = identifier, isUsing = true, payment = 0})
		return false
	end
end

ESX.RegisterUsableItem('scratchcard', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	local isScratching = GetScratch(xPlayer.identifier)
	if isScratching == false then
		UpdateScratch(xPlayer.identifier, true)
		xPlayer.removeInventoryItem('scratchcard', 1)
		TriggerClientEvent('flux_scratchcard:draw', _source, 'silver')
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Wait until you'll scratch the current scratch card.")
	end
end)

ESX.RegisterUsableItem('scratchcardgold', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	local isScratching = GetScratch(xPlayer.identifier)
	
	if isScratching == false then
		UpdateScratch(xPlayer.identifier, true)
		xPlayer.removeInventoryItem('scratchcardgold', 1)
		TriggerClientEvent('flux_scratchcard:draw', _source, 'gold')
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Wait until you'll scratch the current scratch card.")
	end
end)

ESX.RegisterUsableItem('scratchcardpremium', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	local isScratching = GetScratch(xPlayer.identifier)
	
	if isScratching == false then
		UpdateScratch(xPlayer.identifier, true)
		xPlayer.removeInventoryItem('scratchcardpremium', 1)
		TriggerClientEvent('flux_scratchcard:draw', _source, 'platinum')
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Wait until you'll scratch the current scratch card.")
	end
end)