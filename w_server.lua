ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('w_crafting:SVC', function(_type)

    local src = source 
    local data = ESX.GetPlayerFromId(src)
    local getInventory = data.getInventoryItem
    if(_type == 'Zrobil') then
        print(getInventory('gunbarrel').count, getInventory('pistol_zamek').count, getInventory('gunframe').count)
        if(getInventory('pistol_zamek').count >= 1 and getInventory('gunframe').count >= 1 and getInventory('gunbarrel').count >= 1) then
            onPlayerCrafted(src)
            data.addInventoryItem('WEAPON_COMBATPISTOL', 1)
            Wait(50)
            data.removeInventoryItem('pistol_zamek', 1)
            Wait(50)
            data.removeInventoryItem('gunframe', 1)
            Wait(50)
            data.removeInventoryItem('gunbarrel', 1)

            print('tak')
            TriggerClientEvent("dopeNotify:SendNotification", src, {		
                text = '<b><i class="fas fa-pills"></i> POWIADOMIENIE</span></b></br><span style="color: #a9a29f;">Pomyślnie Wytworzono<span style="color: lightblue;"> Policyjny Glock!',
                type = "error",
                timeout = 2000,
                layout = "topRight"
            })
        else
            print('nima')
        end
    elseif(_type == 'NieZrobil') then 
        chance = math.random(1,3)
        local itemy = {
            ['1'] = 'pistol_zamek',
            ['2'] = 'gunframe',
            ['3'] = 'gunbarrel'
        }
        if(getInventory(itemy[tostring(chance)]).count >= 1) then
            data.removeInventoryItem(itemy[tostring(chance)], 1)
        end
    end

end)

onPlayerCrafted = function(src)
    local _src = src
    local data = ESX.GetPlayerFromId(_src)

    MySQL.Async.fetchAll('SELECT * FROM w_scripts_db WHERE identifier = @identifier', {
		['@identifier'] = data.identifier
	}, function(result)
        print(result[1])
        print(json.encode(result))
        if(result[1]) then
            MySQL.Async.execute('UPDATE w_scripts_db SET crafting_exp = crafting_exp + 1',{['@identifier'] = data.identifier})
            checkLvl(_src)
        else
            MySQL.Async.execute('INSERT INTO w_scripts_db (identifier) VALUES (@identifier)',{['@identifier'] = data.identifier})
        end
	end)
end

checkLvl = function(src)

    local _src = src
    local data = ESX.GetPlayerFromId(_src)

    MySQL.Async.fetchAll('SELECT * FROM w_scripts_db WHERE identifier = @identifier', {
		['@identifier'] = data.identifier
	}, function(result)
        print(result[1].crafting_exp)
        if(result[1].crafting_exp == 10) then
            print(12333333333333)
            TriggerClientEvent("dopeNotify:SendNotification", _src, {		
                text = '<b><i class="fas fa-pills"></i> POWIADOMIENIE</span></b></br><span style="color: #a9a29f;">Twój poziom Tworzenia broni podniósł się !<span style="color: lightblue;">',
                type = "error",
                timeout = 2000,
                layout = "topRight"
            })
            MySQL.Async.execute('UPDATE w_scripts_db SET crafting_exp = 0',{['@identifier'] = data.identifier})
            MySQL.Async.execute('UPDATE w_scripts_db SET level_crafting = level_crafting + 1',{['@identifier'] = data.identifier})
        end
	end)
    

end