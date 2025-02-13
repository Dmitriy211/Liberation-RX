_fob_pos = _this select 3;
if (isNil "_fob_pos") exitWith {};

private _fob_owner = [_fob_pos] call F_getFobOwner;
private _fob_name = [_fob_pos] call F_getFobName;
if (getPlayerUID player != _fob_owner) exitWith { hintSilent "Error!\nYour are NOT the owner of the Outpost!" };

private _cost = 1500;
private _result = [format [localize "STR_UPGRADE_OUTPOST_PAY", _cost], localize "STR_WARNING", true, true] call BIS_fnc_guiMessage;
if (!_result) exitWith {};
if (!([_cost] call F_pay)) exitWith {};

player setPos (player getPos [5, (getDir player) - 180]);
sleep 0.2;

private _outpost = nearestObjects [_fob_pos, [FOB_outpost], 30] select 0;
private _outpost_dir = getDir _outpost;
deleteVehicle _outpost;
{ deleteVehicle _x } foreach (_fob_pos nearObjects [FOB_sign, 30]);
sleep 0.5;

// add effect
private _fob = createVehicle [FOB_typename, _fob_pos, [], 1, "None"];
_fob setposATL _fob_pos;
private _fob_dir = (_outpost_dir - 180);
_fob setVectorDirAndUp [[sin _fob_dir, cos _fob_dir, 0], [0, 0, 1]];
[_fob] call fob_init;

[_fob_pos] remoteExec ["upgrade_fob_remote_call", 2];

hintSilent format ["%1 %2 "+ localize "STR_UPGRADE_OUTPOST_HINT", "Outpost", _fob_name];
