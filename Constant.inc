/*
 this file is part of ReprapLcd4D Project

 Copyright (C) 2012 Marco Antonini

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#CONST

/*** Configuration Constant  ***/

//Debug Constant
//DEBUG_NO_EXTR_PREVENT
//DEBUG_NO_BOOTSPLASH

VERSION "0.21" //
AUTHOR "marcomail.anto@gmail.com"

//CONTRAST_TIMEOUT 5000 //Screen Timeout, Comment out to disable
STARTUP_TIMEOUT 800

SOUND_VOLUME 30 //60 for low PWR
//SOUND_BED_NOTIFY //to change, does not work correctly
OBJECT_RELEASE_TEMP 40 //Temperature release of Object on the bed
                       //which is used only as a notification sound

//Gauge & Slider Temperature range
GAUGE_TTEMP 85
GAUGE_MAX_TEMP_H 250
GAUGE_MAX_TEMP_B 120

TRACKPAD_MAX_EXTMM 300
TRACKPAD_MAX_EXTMM_MIN 300 // map function does not work with >300
TRACKPAD_MAX_EXTTEMP 250
TRACKPAD_MAX_BEDTEMP 120

//Mem Constant
BUFF_LEN 50 //Length of the buffer for the Protocol
COMBUFF_LEN 800  //Circular Serial Buffer
                 //800 is best for 100 file
MESSAGE_DIM 46   //Lenght of Message files, <(BUFF_LEN-3)
MAX_FILE 100     //Max reading file

MAX_FILE_NAME 12 //Max char in file name

//Color Constant
COLOURSEL_INDICATOR 0x8D9C
COLOURSEL BLUE


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
SET_TIMER 0
REMOVE_TIMER 1
GET_TIMER 2

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
W_Z_CALIBRATION 8 // Z Calibration Window

#END

#CONST

Z_SET_OFFSET 0
Z_PROBE 1
Z_SIGN 2
Z_INT_PLUS 3
Z_INT_MINUS 4
Z_DEC1_PLUS 5
Z_DEC1_MINUS 6
Z_DEC2_PLUS 7
Z_DEC2_MINUS 8
Z_DEC3_PLUS 9
Z_DEC3_MINUS 10
#END

/*** Global Vars  ***/

//Semaphore Vars
var EN_TOUCH_MOVING; //Enable Touch Moving
var WINDOW; //Current Window
var FILE_START; //Parsing File from SD
var SD_READING; //Reading file from SD
var PRINTING; //Print status

//Storing the current state
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
var msg[MESSAGE_DIM]; //Message string
var extruder_selected; //Current Extruder
var sd_current_page; //Curretn SD file pages
var sd_page_count;   //Max SD file pages

//SD File Vars
var filenames; //Pointer to the file list
var file_count; //File Count
var files[MAX_FILE]; //File name Pointers Array
var p_filenames; //Pointer index

//Z Calibration:
//Z offset: sign int.dec1 dec2 dec3 (-0.230)
var z_cal_sign;
var z_cal_int;
var z_cal_dec1;
var z_cal_dec2;
var z_cal_dec3;





