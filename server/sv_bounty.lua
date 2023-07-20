local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('ip_bountyhunting:AddSomeMoney')
AddEventHandler('ip_bountyhunting:AddSomeMoney', function()
    local _source = source
    local price = Config.Price
    local Character = RSGCore.Functions.GetPlayer(source)
    Character.Functions.AddMoney('cash', price, 'bounty-hunting')
    --TriggerClientEvent("ip-core:TipRight", _source, "You Got Paid ".."$"..price, 5000)
    TriggerClientEvent('ip-core:NotifyLeft', _source, "Bounty", "You Got Paid ".."+$"..price, "INVENTORY_ITEMS", "money_billstack", 5000)
end)

RegisterNetEvent('ip-bounty:server:removeitem')
AddEventHandler('ip-bounty:server:removeitem', function(itemName, amount)
	local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(itemName, amount)
	TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[itemName], "remove", amount)
end)

-- RegisterServerEvent('bounty:checkcard')
-- AddEventHandler('bounty:checkcard', function()
--     local _source = source -- id 
--     local Character = VorpCore.getUser(_source).getUsedCharacter
--     local job = Character.job -- player job
--     local count = VORPInv.getItemCount(_source, "license") -- item needed

--         if CheckTable(Config.Jobs,job) then -- if job exist in table then pass

--         TriggerClientEvent('bounty:findcard', _source)

--         elseif count > 0 then -- if item is greaer than 0 then pass 
--             TriggerClientEvent('bounty:findcard', _source)

--         else
--         TriggerClientEvent("vorp:TipRight",_source,"you need the job or item",4000)
--         end
-- end)