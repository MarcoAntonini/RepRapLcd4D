#CONST

/* Configuration Constant  */
BUFF_LEN 50 //Length of the buffer for the Serial Protocol
COMBUFF_LEN 300  //Circular Serial Buffer
                 //300 is best for 50 file
MESSAGE_DIM 46   //Lenght of Message files
MAX_FILE 50     //Max readinf file
                //50 is best for RAM
MAX_FILE_NAME 11

COLOURSEL_INDICATOR 0x8D9C
COLOURSEL BLUE
COLOUR_TRACKPAD 0x8D9C
//COLOUR_TRACKPAD 0xD699

GAUGE_TTEMP 85
GAUGE_MAX_TEMP_H 250
GAUGE_MAX_TEMP_B 120

TRACKPAD_MAX_EXTMM 300
TRACKPAD_MAX_EXTMM_MIN 300 // map function does not work with >300
TRACKPAD_MAX_EXTTEMP 250
TRACKPAD_MAX_BEDTEMP 120

/*** Comparison Constant  ***/
//Boolean
FALSE 0
TRUE 1

UPDATE 0
EVENT 1

//for Sound
STARTUP 0
ALERT 1
FINISH 2

//for Timeout
//SET_TIMER 0
//REMOVE_TIMER 1

/*** Serial Protocol ID Constant  ***/
MESSAGE_ID 'M'
HOTEND_ID 'H'  //H0,H1
TARGETT_ID 'T' //T0,T1,TB
BED_ID 'B'
TIME_ID 't'
ZPOS_ID 'Z'
SDPERCENT_ID 'S'
SOUND_ID 's'
DEBUG_SHOW_MEM_ID 'D'


/*** Window ID Constant  ***/
// !!!Order is important!!
W_MAIN 4       //Main Window
W_SDCARD 5    //SDcard file Window
W_EXTMM 0     //Extrude (mm) Slider Window
W_EXTMM_MIN 1 //Extrude (mm/min) Slider Window
W_EXTTEMP 2   //Extrude (temperature) Slider Window
W_BEDTEMP 3   //Bed (temperature) Slider Window
W_PRINT_CONFIRM 6 //Printer Confirm Window
W_PRINTING_OPTION 7 //Printing Option Window

#END

/*** Global Vars  ***/

//Semaphore Vars
var EN_TOUCH_MOVING; //Enable Touch Moving
var WINDOW; //Current Window
var FILE_START; //Parsing File from SD
var SD_READING; //Reading file from SD
var PRINTING; //Print status

//Storing the current state Vars
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
var timePrint[7]; //Time printing
var sdPerc[4]; //Printing percentage
var ex_setmm[4];     //Extrude mm of filament
var ex_setmm_min[4]; //Extruder mm/min
var ex_setTemp[4]; //Set Ext. Temp
var bed_setTemp[4]; //Set Bed Temp
var msg[MESSAGE_DIM]; //Message string Max 46 char
var current_extruder; //Current Extruder
var sd_current_page:=0; //Curretn SD file pages
var sd_page_count:=0;   //Max SD file pages

//SD File Vars
var filenames; //Pointer to the file list
var file_count; //File Count
var files[MAX_FILE]; //File name Pointers Array
var p_filenames; //Pointer index





