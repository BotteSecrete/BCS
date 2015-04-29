// ActionScript file




var featArray:Array;
var featToSheet:Array;
var geolArray:Array;
var geolToSheet:Array;
var geolToSheetSelected:Array;

var objToId:Array;
var objIdHoleId:Array;

var HeaderColumn:Array = ["PROJ_ID","LOCA_ID","LOCA_TYPE","LOCA_STAT","LOCA_NATE","LOCA_NATN","LOCA_GREF",
	"LOCA_GL","LOCA_REM","LOCA_FDEP","LOCA_STAR","LOCA_PURP","LOCA_TERM","LOCA_END","LOCA_ENDD","LOCA_LOCX","LOCA_LOCY","LOCA_LOCZ","LOCA_LREF","LOCA_DATM",
	"LOCA_ETRV","LOCA_NTRV","LOCA_LTRV","LOCA_XTRL","LOCA_YTRL","LOCA_ZTRL","LOCA_LAT","LOCA_LON","LOCA_ELAT","LOCA_ELON","LOCA_LLZ","LOCA_LOCM","LOCA_LOCA",
	"LOCA_CLST","LOCA_ALID","LOCA_OFFS","LOCA_CNGE","LOCA_TRAN","LOCA_FSET","VALIDE","COMPLETE","CHECK"];
var HeaderColumnGeol:Array = ["LOCA_ID","GEOL_TOP","GEOL_BASE","GEOL_LEG","GEOL_GEOL","GEOL_DESC","GEOL_GEO2","GEOL_STAT","GEOL_BGS","GEOL_FORM","FILE_FSET"];
