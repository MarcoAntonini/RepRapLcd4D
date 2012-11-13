#inherit "4DGL_16bitColours.fnc"
#CONST

FALSE 0
TRUE 1
BUFF_LEN 50
MESSAGE_DIM 46

STARTUP 0
ALERT 1
FINISH 2

COLOURSEL_INDICATOR 0x8D9C
COLOURSEL BLUE
COLOUR_TRACKPAD 0x8D9C
//COLOUR_TRACKPAD 0xD699

GAUGE_TTEMP 85
GAUGE_MAX_TEMP 250

//ID Serial Protocol
MESSAGE_ID 'M'
HOTEND_ID 'H'  //H0,H1
TARGETT_ID 'T' //T0,T1,TB
BED_ID 'B'
TIME_ID 't'
ZPOS_ID 'Z'
SDPERCENT_ID 'S'

TRACKPAD_MAX_EXTMM 300
TRACKPAD_MAX_EXTMM_MIN 300 // map function does not work with >300
TRACKPAD_MAX_EXTTEMP 250
TRACKPAD_MAX_BEDTEMP 120

// Windows ID !!!Order is important!!
W_MAIN 4
W_SDCARD 5
W_EXTMM 0
W_EXTMM_MIN 1
W_EXTTEMP 2
W_BEDTEMP 3

#END

//Global Vars
var EN_TOUCH_MOVING;
var WINDOW;
var _ttH0; //Temp Target HotEnd0
var ttH0[4];
var _ttH1; //Temp Target HotEnd1
var ttH1[4];
var _ttB;  //Temp Target Bed
var ttB[4];
var tH0[4];//Temp HotEnd0
var tH1[4];//Temp HotEnd1
var tB[4]; //Temp Bed
var zPos[8]; //Z Position
var timePrint[7];
var sdPerc[4];

var ex_setmm[4];     // Extrude mm of filament
var ex_setmm_min[4]; // Extruder mm/min
var ex_setTemp[4]; //Button Set Ext. Temp
var bed_setTemp[4]; //Buttpn Set Bed Temp
var msg[MESSAGE_DIM]; //Max 46 char

var current_extruder;







