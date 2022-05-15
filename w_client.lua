ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('w_crafting:sendSV', function()
    if(exports['s-taskbarskill']:taskBar(1,1) == 100) then
        TriggerServerEvent('w_crafting:SVC', 'Zrobil')
    else
        TriggerServerEvent('w_crafting:SVC', 'NieZrobil')
    end
end)