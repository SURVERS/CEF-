#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <cef>

main(){}

new URL[56] = "http://wh225.web1.bhweb.ru/";        							// URL CEF
new PlayerMoney[MAX_PLAYERS] = 0;                                               // Количество денег у игрока

forward SetGunCost(playerid, const text[]);                                     // Данная функция устанавливает цену за оружие
forward SetValueGun(playerid, const text[]);                                    // Данная функция устанавливает кол-во оружия
forward SetGunID(playerid, const text[]);                                       // Данная функция отвечает за выбор оружия

forward rouletteWin(playerid, const text[]);                                    // Данная функция отвечает за победу в рулетке (Доступно будет если залить сайт с рулеткой)
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);         // Данная функция проверяет на нахождения игрока на нужных координатах
forward DestroyBrowser(playerid);                                               // Данная функция позволяет закрыть браузер (CEF у игрока)

public OnGameModeInit()
{
	LoadPickups();

    cef_subscribe("pwd:SetGunID", "SetGunID");
    cef_subscribe("pwd:SetValueGun", "SetValueGun");
    cef_subscribe("pwd:SetGunCost", "SetGunCost");
    //cef_subscribe("pwd:rouletteWin", "rouletteWin");
	SetGameModeText("SURVERS RP");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnGameModeExit() return 1;
public OnPlayerConnect(playerid) return 1;
public OnPlayerDisconnect(playerid, reason) return 1;
public OnPlayerSpawn(playerid) return 1;
public OnPlayerDeath(playerid, killerid, reason) return 1;
public OnVehicleSpawn(vehicleid) return 1;
public OnVehicleDeath(vehicleid, killerid) return 1;
public OnPlayerText(playerid, text[]) return 1;
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) return 1;
public OnPlayerExitVehicle(playerid, vehicleid) return 1;
public OnPlayerStateChange(playerid, newstate, oldstate) return 1;
public OnPlayerEnterCheckpoint(playerid) return 1;
public OnPlayerLeaveCheckpoint(playerid) return 1;
public OnPlayerEnterRaceCheckpoint(playerid) return 1;
public OnPlayerLeaveRaceCheckpoint(playerid) return 1;
public OnPlayerRequestSpawn(playerid) return 1;
public OnObjectMoved(objectid) return 1;
public OnPlayerObjectMoved(playerid, objectid) return 1;
public OnPlayerPickUpPickup(playerid, pickupid) return 1;
public OnVehicleMod(playerid, vehicleid, componentid) return 1;
public OnVehiclePaintjob(playerid, vehicleid, paintjobid) return 1;
public OnVehicleRespray(playerid, vehicleid, color1, color2) return 1;
public OnPlayerSelectedMenuRow(playerid, row) return 1;
public OnPlayerExitedMenu(playerid) return 1;
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) return 1;
public OnRconLoginAttempt(ip[], password[], success) return 1;
public OnPlayerUpdate(playerid) return 1;
public OnPlayerStreamIn(playerid, forplayerid) return 1;
public OnPlayerStreamOut(playerid, forplayerid) return 1;
public OnVehicleStreamIn(vehicleid, forplayerid) return 1;
public OnVehicleStreamOut(vehicleid, forplayerid) return 1;
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) return 1;
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) return SetPlayerPos(playerid, fX, fY, fZ);
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z){
	if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) return 1;
	}
	return 0;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
	if(newkeys == KEY_WALK){
	    if(PlayerToPoint(2.0, playerid, 1961.0790,1342.9253,15.3672)){
			cef_destroy_browser(playerid, 1);
    		cef_create_browser(playerid, 1, URL, false, true);
    		
    		SetTimerEx("DestroyBrowser", 25000, false, "d", playerid);
	    }
	}
}
public rouletteWin(playerid, const text[]){
	new str[256];
	format(str, 256, "[ Рулетка CEF ]: {FFFFFF}Вы получили %s с рулетки. Поздравляем!", text);
	return SendClientMessage(playerid, 0x318CE7FF, str);
}
public DestroyBrowser(playerid){
	cef_destroy_browser(playerid, 1);
    return cef_create_browser(playerid, 1, "", false, false);
}
public SetGunCost(playerid, const text[]) return SetPVarInt(playerid, "ConstGun", strval(text));
public SetValueGun(playerid, const text[]) return SetPVarInt(playerid, "ValueGuns", strval(text));
public SetGunID(playerid, const text[]){
	SetPVarInt(playerid, "IDGun", strval(text));
	
	if(PlayerMoney[playerid] < GetPVarInt(playerid, "ConstGun")) return SendClientMessage(playerid, 0xEB4C42FF, "[Ошибка]: {FFFFFF}У вас недостаточно средств!");
	GivePlayerWeapon(playerid, GetPVarInt(playerid, "IDGun"), GetPVarInt(playerid, "ValueGuns"));
	PlayerMoney[playerid] -= GetPVarInt(playerid, "ConstGun");
	GivePlayerMoney(playerid, -GetPVarInt(playerid, "ConstGun"));
	DestroyBrowser(playerid);
	return SendClientMessage(playerid, 0x41EB4CFF, "[Информация]: {FFFFFF}Вы успешно приобрели оружие!");
}

stock LoadPickups(){
	CreatePickup(19132, 23, 1961.0790,1342.9253,15.3672, 0);
}

CMD:test(playerid){
    PlayerMoney[playerid] = 10000;
    GivePlayerMoney(playerid, 10000);
    return SendClientMessage(playerid, -1, "Вы выдали 10000$");
}
