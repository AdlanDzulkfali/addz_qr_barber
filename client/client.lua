local QRCore = exports['qr-core']:GetCoreObject()

AppearanceCache = {}

isInBarber = false

local barberChairs = {
    `p_barberchair01x`,
    `p_barberchair02x`,
    `p_barberchair03x`,
}

exports['qr-target']:AddTargetModel(barberChairs, {
    options = {
        {
            icon = "fa-regular fa-hand",
            label = "Barber",
            targeticon = "fas fa-eye",
            --event = "addz_drugprocessing:client_pickWeed"
            action = function(entity)
                 TriggerEvent('addz_qr_barber:client_enteringBarber', entity)
             end
        }
    },
    distance = 2.5,
})

--blip
Citizen.CreateThread(function()

    for i=1, #Config.Barber do
        local blip = N_0x554d9d53f696d002(1664425300, Config.Barber[i].location)
        SetBlipSprite(blip, 2204494572, 1)
        SetBlipScale(blip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Barber[i].name)
    end

 end)

RegisterNetEvent('addz_qr_barber:client_enteringBarber', function(entity)

    isInBarber = true
    local playerPed = PlayerPedId()
    local isWearHat = IsPedUsingComponent(playerPed, 0x9925C067)
    if isWearHat then
        ExecuteCommand('hat')
    end

    local playerCoords = GetEntityCoords(playerPed)

    local chairpos = GetOffsetFromEntityInWorldCoords(entity,0.0,0.0,0.8)
    local chairheading = GetEntityHeading(entity)

    print(chairpos, chairheading)

    local _test = TaskStartScenarioAtPosition(playerPed, GetHashKey("PROP_PLAYER_BARBER_SEAT"), chairpos.x, chairpos.y, chairpos.z, chairheading+180.0, 0, true, true, false, false)
    Wait(5000)
    CreationCamHead()
    --print('_test ' .. _test)
     QRCore.Functions.TriggerCallback('addz_qr_barber:server_getCurrentCloth', function(currentCloth)
        AppearanceCache = currentCloth
        print(json.encode(currentCloth))
        TriggerEvent('addz_qr_barber:client_barberMenu')
    end)
end)

------------------------
-- HAIR MENU

RegisterNetEvent('addz_qr_barber:client_selectVariationHair', function(args)

    local _table = args.table
    local _model = args.model
    local hairVariationMenu = {
        {
            header = "Go Back",
            params = {
                event = 'addz_qr_barber:client_barberHairMenu',
                args = {},
            }
        },
    }
    print('_table ' .. #_table)
    for i=1, #_table do
        hairVariationMenu[i+1] = {
            header = string.format("Variation : %03d",i),
            txt = "",
            icon = "",
            params = {
                event = 'addz_qr_barber:client_chooseHair',
                args = {
                    table = _table,
                    hairHash = _table[i]['hash'],
                    model = _model,
                    texture = i
                },
            }
        }
    end

    exports['qr-menu']:openMenu(hairVariationMenu)

end)

RegisterNetEvent('addz_qr_barber:client_chooseHair', function(args)

    local _table = args.table
    local _hash = args.hairHash
    local _model = args.model
    local _texture = args.texture

    NativeSetPedComponentEnabled(PlayerPedId(), tonumber(_hash), false, true, true)

    AppearanceCache.hair.texture = _texture
    AppearanceCache.hair.model = _model

    print('AppearanceCache ' .. json.encode(AppearanceCache))

    local _args = {
        table = _table,
        model = _model
    }

    TriggerEvent('addz_qr_barber:client_selectVariationHair', _args)

end)

RegisterNetEvent('addz_qr_barber:client_barberHairMenu', function()
--function BarberMenu()

    local barberMenu = {
        {
            header = "Go Back",
            params = {
                event = 'addz_qr_barber:client_barberMenu',
                args = {},
            }
        },
    }

    print(#hairs_list['male']['hair'])

    local pedIsMale = IsPedMale(PlayerPedId())
    local hairList = {}
    if pedIsMale then
        hairList = hairs_list['male']['hair']
    else
        hairList = hairs_list['female']['hair']
    end
    for i=1, #hairList do
        --if pedIsMale then
            barberMenu[i+1] = {
                header = string.format("Hair Number : %03d",i),
                txt = "",
                icon = "",
                params = {
                    event = 'addz_qr_barber:client_selectVariationHair',
                    args = {
                        table = hairList[i],
                        model = i
                    },
                }
            }
        --else
        --end
    end

    exports['qr-menu']:openMenu(barberMenu)

end)

------------------------
-- BEARD MENU

RegisterNetEvent('addz_qr_barber:client_barberBeardMenu', function()
    --function BarberMenu()
    
        local barberMenu = {
            {
                header = "Go Back",
                params = {
                    event = 'addz_qr_barber:client_barberMenu',
                    args = {},
                }
            },
        }
    
        print(#hairs_list['male']['hair'])
    
        local pedIsMale = IsPedMale(PlayerPedId())
        local hairList = {}
        if pedIsMale then
            hairList = hairs_list['male']['beard']
        else
            hairList = hairs_list['female']['hair']
        end
        for i=1, #hairList do
            --if pedIsMale then
                barberMenu[i+1] = {
                    header = string.format("Beard Number : %03d",i),
                    txt = "",
                    icon = "",
                    params = {
                        event = 'addz_qr_barber:client_selectVariationBeard',
                        args = {
                            table = hairList[i],
                            model = i
                        },
                    }
                }
            --else
            --end
        end
    
        exports['qr-menu']:openMenu(barberMenu)
    
    end)

RegisterNetEvent('addz_qr_barber:client_selectVariationBeard', function(args)

    local _table = args.table
    local _model = args.model
    local hairVariationMenu = {
        {
            header = "Go Back",
            params = {
                event = 'addz_qr_barber:client_barberBeardMenu',
                args = {},
            }
        },
    }
    print('_table ' .. #_table)
    for i=1, #_table do
        hairVariationMenu[i+1] = {
            header = string.format("Variation : %03d",i),
            txt = "",
            icon = "",
            params = {
                event = 'addz_qr_barber:client_chooseBeard',
                args = {
                    table = _table,
                    beardHash = _table[i]['hash'],
                    model = _model,
                    texture = i
                },
            }
        }
    end

    exports['qr-menu']:openMenu(hairVariationMenu)

end)

RegisterNetEvent('addz_qr_barber:client_chooseBeard', function(args)

    local _table = args.table
    local _hash = args.beardHash
    local _model = args.model
    local _texture = args.texture

    NativeSetPedComponentEnabled(PlayerPedId(), tonumber(_hash), false, true, true)

    AppearanceCache.beard.texture = _texture
    AppearanceCache.beard.model = _model

    print('AppearanceCache ' .. json.encode(AppearanceCache))

    local _args = {
        table = _table,
        model = _model
    }

    TriggerEvent('addz_qr_barber:client_selectVariationBeard', _args)

end)
------------------------
-- GENERAL

RegisterNetEvent('addz_qr_barber:client_barberMenu', function()

    local barberMenu = {
        {
            header = "Save All",
            params = {
                event = 'addz_qr_barber:client_saveNewSkin',
                args = {},
            }
        },
        {
            header = "Hair",
            params = {
                event = 'addz_qr_barber:client_barberHairMenu',
                args = {},
            }
        },
        {
            header = "Beard",
            params = {
                event = 'addz_qr_barber:client_barberBeardMenu',
                args = {},
            }
        },
        {
            header = "Cancel",
            params = {
                event = 'addz_qr_barber:client_cancelBarber',
                args = {},
            }
        },
--[[         {
            header = "Make Up",
            params = {
                event = 'addz_qr_barber:client_saveNewSkin',
                args = {},
            }
        }, ]]
    }

    exports['qr-menu']:openMenu(barberMenu)

end)



RegisterNetEvent('addz_qr_barber:client_saveNewSkin', function()

    TriggerEvent('addz_qr_barber:client_cancelBarber')

    TriggerServerEvent("addz_qr_barber:server_saveSkin", AppearanceCache)

end)

RegisterNetEvent('addz_qr_barber:client_cancelBarber', function()

    EndCamera()
    ClearPedTasks(PlayerPedId())
    isInBarber = false
end)

function NativeSetPedComponentEnabled(ped, componentHash, immediately, isMp)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, componentHash, immediately, isMp, true)
    NativeUpdatePedVariation(ped)
end

function NativeUpdatePedVariation(ped)
    Citizen.InvokeNative(0x704C908E9C405136, ped)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false)
    while not NativeHasPedComponentLoaded(ped) do
        Wait(1)
    end
end

function NativeHasPedComponentLoaded(ped)
    return Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, ped)
end

function IsPedUsingComponent(ped, clothCategory)
    return Citizen.InvokeNative(0xFB4891BD7578CDC1, ped, clothCategory)
end

function CreationCamHead()
	cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')

	local coordsCam = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.65)
	local coordsPly = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam, coordsCam)
	PointCamAtCoord(cam, coordsPly['x'], coordsPly['y'], coordsPly['z']+0.65)

	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)
end

function MoveCamera(x, y, z)
    local cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam2, true)
    SetCamActiveWithInterp(cam2, CharacterCreatorCamera, 750)
    PointCamAtCoord(cam2, -558.32, -3781.11, z)
    Wait(150)
    SetCamActive(CharacterCreatorCamera, false)
    DestroyCam(CharacterCreatorCamera)
    CharacterCreatorCamera = cam2
end

function EndCamera()
    RenderScriptCams(false, true, 1000, true, false)
    DestroyCam(CharacterCreatorCamera, false)
    CharacterCreatorCamera = nil
    DisplayHud(true)
    DisplayRadar(true)
    DestroyAllCams(true)
    FreezeEntityPosition(PlayerPedId() , false)
end

----------------------------------
--------- 3D DRAW TEXT ----------
----------------------------------
function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)

    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

------------------
-- COMMAND
RegisterCommand('resetbarber', function()

    TriggerEvent('addz_qr_barber:client_cancelBarber')

end)