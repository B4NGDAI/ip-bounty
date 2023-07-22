local RSGCore = exports['rsg-core']:GetCoreObject()
local starting = false
local count = {}
local createdped = {}
local gpsx = 0.0
local gpsy = 0.0
local gpsz = 0.0
local pressing = false
local cd = 1200
local oncd = false
local BountyGroup = GetRandomIntInRange(0, 0xffffff)
local blip
local timer = 0
local allTargetsDead = false

CreateThread(function()
	for _, v in pairs(Config.LocationsB) do
		exports['rsg-target']:AddCircleZone(v.location, v.coords, 1, {
			name = v.name,
			debugPoly = false,
		}, {
			options = {
				{
					type = "client",
					label = "Start Bounty",
					action = function()
						TriggerEvent('ip-bounty:client:menu')
					end,
				}
			},
			distance = 3.0,
		})
		if v.showblip == true then
			local bountyBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
			SetBlipSprite(bountyBlip, -861219276)
			SetBlipScale(bountyBlip, Config.BlipBounty.blipScale)
			Citizen.InvokeNative(0x9CB1A1623062F402, bountyBlip, Config.BlipBounty.blipName)
		end
	end
end)

-- CreateThread(function()
--     for k, v in pairs(Config.LocationsB) do
--         blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300,  v.x, v.y, v.z)
--         SetBlipSprite(blip, -861219276)
--         Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Bounty Hunter")
--     end
-- end)

function MissionStart()
	local randomNCoords = math.random(21)
	local chossenCoords = {}


	if randomNCoords == 1 then
		chossenCoords = Config.Coordenates.coords
	elseif randomNCoords == 2 then
		chossenCoords = Config.Coordenates.coords2
	elseif randomNCoords == 3 then
		chossenCoords = Config.Coordenates.coords3
	elseif randomNCoords == 4 then
		chossenCoords = Config.Coordenates.coords4
	elseif randomNCoords == 5 then
		chossenCoords = Config.Coordenates.coords5
	elseif randomNCoords == 6 then
		chossenCoords = Config.Coordenates.coords6
	elseif randomNCoords == 7 then
		chossenCoords = Config.Coordenates.coords7
	elseif randomNCoords == 8 then
		chossenCoords = Config.Coordenates.coords8
	elseif randomNCoords == 9 then
		chossenCoords = Config.Coordenates.coords9
	elseif randomNCoords == 10 then
		chossenCoords = Config.Coordenates.coords10
	elseif randomNCoords == 11 then
		chossenCoords = Config.Coordenates.coords11
	elseif randomNCoords == 12 then
		chossenCoords = Config.Coordenates.coords12
	elseif randomNCoords == 13 then
		chossenCoords = Config.Coordenates.coords13
	elseif randomNCoords == 14 then
		chossenCoords = Config.Coordenates.coords14
	elseif randomNCoords == 15 then
		chossenCoords = Config.Coordenates.coords15
	elseif randomNCoords == 16 then
		chossenCoords = Config.Coordenates.coords16
	elseif randomNCoords == 17 then
		chossenCoords = Config.Coordenates.coords17
	elseif randomNCoords == 18 then
		chossenCoords = Config.Coordenates.coords18
	elseif randomNCoords == 19 then
		chossenCoords = Config.Coordenates.coords19
	elseif randomNCoords == 20 then
		chossenCoords = Config.Coordenates.coords20
	elseif randomNCoords == 21 then
		chossenCoords = Config.Coordenates.coords21
	end


	for k, item in pairs(chossenCoords) do
		--Take a random model
		local modelNumeroRandom = math.random(15)
		local modelRandom = Config.models[modelNumeroRandom].hash
		local _hash = GetHashKey(modelRandom)
		RequestModel(_hash)

		if not HasModelLoaded(_hash) then
			RequestModel(_hash)
		end

		while not HasModelLoaded(_hash) do
			Wait(1)
		end

		local randomNumeroArma = math.random(22)
		local arma = Config.weapons[randomNumeroArma].hash

		createdped[k] = CreatePed(_hash, item.x, item.y, item.z, true, true, true, true)
		Citizen.InvokeNative(0x283978A15512B2FE, createdped[k], true)
		Citizen.InvokeNative(0x23F74C2FDA6E7C61, 953018525, createdped[k])
		gpsx = item.x
		gpsy = item.y
		gpsz = item.z
		GiveWeaponToPed_2(createdped[k], arma, 50, true, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
		SetCurrentPedWeapon(createdped[k], arma, true)
		TaskCombatPed(createdped[k], PlayerPedId())
		--Give weapons to ped and equip them
		count[k] = createdped[k]
	end
	StartGpsMultiRoute(6, true, true)
	AddPointToGpsMultiRoute(gpsx, gpsy, gpsz)
	AddPointToGpsMultiRoute(gpsx, gpsy, gpsz)
	SetGpsMultiRouteRender(true)
	starting = true
	GameTimer()
	Wait(1000)
	CreateThread(function()
		local x = #chossenCoords
		local pl = Citizen.InvokeNative(0x217E9DC48139933D)
		while true do
			Wait(5)
			if starting then
				if timer <= 0 then
					if Config.DefaultNotification then
						RSGCore.Functions.Notification('Time is up!, You have failed to complete the mission in time.', 'inform', 4000)
					else
						TriggerEvent("ip-core:failmissioNotifY", "Time is up!", "You have failed to complete the mission in time.", 4000)
					end
					StopMission()
				else
					for k,v in pairs(createdped) do
						if IsEntityDead(v) then
							if count[k] ~= nil then
								x = x - 1
								count[k] = nil
								if x == 0 then
									allTargetsDead = true
								end
							end
						else
							allTargetsDead = false
							-- Check if player is close to target
							local pedCoords = GetEntityCoords(v)
							local playerCoords = GetEntityCoords(pl)
							local distance = #(pedCoords - playerCoords)
							if distance < 25.0 then
								if Config.DefaultNotification then
									RSGCore.Functions.Notification('Kill All The Targets', 'inform', 4000)
								else
									TriggerEvent("ip-core:ShowBasicTopNotification", "Kill All The Targets", 4000)
								end
							end
						end
					end
					if IsPlayerDead(pl) then
						-- Player is dead, stop the mission and show failure notification
						TriggerEvent("ip-core:failmissioNotifY", Config.DeadMessage, "You have lost your target.", 4000)
						StopMission()
					else
						if allTargetsDead == true then
							-- All targets are dead, show success notification and reward player
							if Config.DefaultNotification then
								RSGCore.Functions.Notification('success knock out all the opponents', 'success', 4000)
							else
								--put your own notif here
								TriggerEvent("ip-core:ShowBasicTopNotification", "success knock out all the opponents", 4000)
							end
							TriggerServerEvent('ip_bountyhunting:AddSomeMoney')
							Wait(4000)
							StopMission()
						end
					end
				end
			end
		end
	end)
end

-- local minutes = math.floor(timer / 60)
-- local seconds = timer - minutes * 60
-- local text = string.format("Time left: %02d:%02d", minutes, seconds)

function GameTimer()
    timer = 1200 -- set timer to 20 minutes (20 mins * 60 secs/min = 1200 seconds)
    local sleep = 1000
    CreateThread(function()
        while starting do
            Wait(sleep)
            if timer > 0 then
                timer = timer - 1
            end
        end
    end)
end

function DrawTimer()
    local minutes = math.floor(timer / 60)
    local seconds = timer % 60
    DrawTxt(minutes..':'..seconds, 0.50, 0.90, 0.7, 0.7, true, 255, 0, 0, 200, true)
end

CreateThread(function()
    while true do
        Wait(10)
        if starting == true then
            if timer > 0 then
                DrawTimer()
            end
        end
    end
end)

function StopMission()
	Wait(5000)
	pressing = false
	starting = false
	SetGpsMultiRouteRender(false)
	for k, v in pairs(createdped) do
		DeletePed(v)
		Wait(500)
	end
	table.remove {createdped}
	table.remove {count}
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

function StartDialog()
	Citizen.CreateThread(function()
		local timetocheck = 600
		while timetocheck >= 0 do
			Wait(0)
			if Config.DefaultNotification then
				RSGCore.Functions.Notification(Config.KillingMessage, 'inform', 5000)
			else
				TriggerEvent("ip-core:ShowTopNotification", "BOUNTY HUNTER", Config.KillingMessage, 5000)
			end
			timetocheck = timetocheck - 1
		end
	end)
end

RegisterNetEvent('ip-bounty:client:menu', function()
	local hasItem = RSGCore.Functions.HasItem(Config.TicketBounty, 1)
	if hasItem and oncd == false then
		StopMission()
		pressing = true
		TriggerServerEvent('ip-bounty:server:removeitem', Config.TicketBounty, 1)
		Wait(1000)
		oncd = true
		MissionStart()
		StartDialog()
	elseif not hasItem then
		if Config.DefaultNotification then
			RSGCore.Functions.Notification('you need a ticket to start bounty', 'inform', 5000)
		else
			TriggerEvent("ip-core:ShowTopNotification", "You Dont Have a Bounty Ticket", "To Start Bounty", 5000)
		end
	elseif oncd == true then
		if Config.DefaultNotification then
			RSGCore.Functions.Notification('bounty on cooldown', 'inform', 5000)
		else
			TriggerEvent("ip-core:ShowTopNotification", "On cooldown", "To Start Bounty", 5000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(10)
		if oncd then
			Wait(cd)
			oncd = false
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        pressing = false
        starting = false
        SetGpsMultiRouteRender(false)
        for k, v in pairs(createdped) do
            DeletePed(v)
            Wait(500)
        end
        createdped = {}
        count = {}
    end
end)