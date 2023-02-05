local QRCore = exports['qr-core']:GetCoreObject()


QRCore.Functions.CreateCallback('addz_qr_barber:server_getCurrentCloth', function(source, cb)

    local _value = value
    local _source = source
    local _skin = {}
    local User = QRCore.Functions.GetPlayer(_source)
    local citizenid = User.PlayerData.citizenid
    local skins =  MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ?', {citizenid})

    _skin = json.decode(skins[1].skin)

    cb(_skin)

end)

RegisterNetEvent("addz_qr_barber:server_saveSkin",function(appearanceCache)

    local _source = source
    local encodeSkin = json.encode(appearanceCache)
    local Player = QRCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid

    MySQL.Async.execute("UPDATE playerskins SET `skin` = ? WHERE `citizenid`= ?", {encodeSkin, citizenid})

end)