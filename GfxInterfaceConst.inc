/***********************************************************************************
*  Object indexes into ImageControl
************************************************************************************/
#CONST
    iImage1         // offset 0x0
    iImage2         // offset 0x10C00
    iGauge1         // offset 0x14600
    iGauge3         // offset 0x65600
    iImage3         // offset 0xB6600
    iWinbutton1     // offset 0xB6800
    iWinbutton2     // offset 0xB7400
    iWinbutton3     // offset 0xB8000
    iWinbutton4     // offset 0xB8800
    iWinbutton5     // offset 0xB9000
    iWinbutton6     // offset 0xB9C00
    iLed1           // offset 0xBA800
    iLed3           // offset 0xBB600
    iTrackbar1      // offset 0xBC000
    iWinbutton9     // offset 0x172200
    iMotorsOffBtn   // offset 0x173E00
    iCentreBedBtn   // offset 0x175600
    iWinbutton7     // offset 0x176E00
    iWinbutton8     // offset 0x177400
    iWinbutton10    // offset 0x177A00
    iWinbutton13    // offset 0x179600
    iWinbutton14    // offset 0x179E00
    iWinbutton11    // offset 0x17A600
    iWinbutton12    // offset 0x17B400
    iWinbutton15    // offset 0x17C200
    iWinbutton16    // offset 0x17D400
    iWinbutton17    // offset 0x17E600
    iWinbutton18    // offset 0x17FA00
    iWinbutton19    // offset 0x180E00
    iWinbutton20    // offset 0x181400
    iWinbutton22    // offset 0x181A00
    iWinbutton23    // offset 0x182000
    iWinbutton26    // offset 0x182600
    iWinbutton27    // offset 0x182C00
    iWinbutton28    // offset 0x183200
    iWinbutton29    // offset 0x183800
    iWinbutton30    // offset 0x183E00
    iWinbutton21    // offset 0x184600
    iImage4         // offset 0x185A00
#END

var disk, hndl ;


/***********************************************************************************
*   Touch Region Axis Move
************************************************************************************/
#CONST
    HOMING_ACTION_INDEX 22
#END

#DATA


word AXIS_MOVE_TOUCH_REGION  X_PLUS_FAST,X_PLUS_NORMAL,X_PLUS_SLOW,X_PLUS_VSLOW,
                             X_MINUS_FAST,X_MINUS_NORMAL,X_MINUS_SLOW,X_MINUS_VSLOW,
                             Y_PLUS_FAST,Y_PLUS_NORMAL,Y_PLUS_SLOW,Y_PLUS_VSLOW,
                             Y_MINUS_FAST,Y_MINUS_NORMAL,Y_MINUS_SLOW,Y_MINUS_VSLOW,
                             Z_PLUS_FAST,Z_PLUS_NORMAL,Z_PLUS_SLOW,
                             Z_MINUS_FAST,Z_MINUS_NORMAL,Z_MINUS_SLOW,
                             HOMING,X_HOMING,Y_HOMING,Z_HOMING

word AXIS_MOVE_TOUCH_ACTION  X_PLUS_FAST_ACT,X_PLUS_NORMAL_ACT,X_PLUS_SLOW_ACT,X_PLUS_VSLOW_ACT,
                             X_MINUS_FAST_ACT,X_MINUS_NORMAL_ACT,X_MINUS_SLOW_ACT,X_MINUS_VSLOW_ACT,
                             Y_PLUS_FAST_ACT,Y_PLUS_NORMAL_ACT,Y_PLUS_SLOW_ACT,Y_PLUS_VSLOW_ACT,
                             Y_MINUS_FAST_ACT,Y_MINUS_NORMAL_ACT,Y_MINUS_SLOW_ACT,Y_MINUS_VSLOW_ACT,
                             Z_PLUS_FAST_ACT,Z_PLUS_NORMAL_ACT,Z_PLUS_SLOW_ACT,
                             Z_MINUS_FAST_ACT,Z_MINUS_NORMAL_ACT,Z_MINUS_SLOW_ACT,
                             HOMING_ACT,X_HOMING_ACT,Y_HOMING_ACT,Z_HOMING_ACT

//X Touch Region
word X_PLUS_FAST 165, 60, 180, 117
word X_PLUS_NORMAL 147, 64, 160, 112
word X_PLUS_SLOW  128, 65, 141, 112
word X_PLUS_VSLOW  104,80,126,97

word X_MINUS_FAST  8, 60, 23, 117
word X_MINUS_NORMAL  28, 64, 41, 112
word X_MINUS_SLOW  48, 64, 61, 111
word X_MINUS_VSLOW  64, 80, 86, 97

//Action
byte X_PLUS_FAST_ACT "G1 X100 F12000\0"
byte X_PLUS_NORMAL_ACT "G1 X10 F12000\0"
byte X_PLUS_SLOW_ACT "G1 X1 F12000\0"
byte X_PLUS_VSLOW_ACT "G1 X0.1 F12000\0"

byte X_MINUS_FAST_ACT "G1 X-100 F12000\0"
byte X_MINUS_NORMAL_ACT "G1 X-10 F12000\0"
byte X_MINUS_SLOW_ACT "G1 X-1 F12000\0"
byte X_MINUS_VSLOW_ACT "G1 X-0.1 F12000\0"


//Y Touch Region
word Y_PLUS_FAST  48,7,135,22
word Y_PLUS_NORMAL  66,27,120,39
word Y_PLUS_SLOW  72,46,118,56
word Y_PLUS_VSLOW  80,60,106,76

word Y_MINUS_FAST  55, 156, 139, 172
word Y_MINUS_NORMAL  63, 136, 136, 150
word Y_MINUS_SLOW  76, 119, 113, 134
word Y_MINUS_VSLOW  82,100,107,116


//Action
byte Y_PLUS_FAST_ACT "G1 Y100 F12000\0"
byte Y_PLUS_NORMAL_ACT "G1 Y10 F12000\0"
byte Y_PLUS_SLOW_ACT "G1 Y1 F12000\0"
byte Y_PLUS_VSLOW_ACT "G1 Y0.1 F12000\0"

byte Y_MINUS_FAST_ACT "G1 Y-100 F12000\0"
byte Y_MINUS_NORMAL_ACT "G1 Y-10 F12000\0"
byte Y_MINUS_SLOW_ACT "G1 Y-1 F12000\0"
byte Y_MINUS_VSLOW_ACT "G1 Y-0.1 F12000\0"

//Z Touch region
word Z_PLUS_FAST  196, 28, 220, 44
word Z_PLUS_NORMAL  196, 48, 220, 63
word Z_PLUS_SLOW  196, 67, 220, 83

word Z_MINUS_FAST  196, 128, 218, 146
word Z_MINUS_NORMAL  196, 109, 220, 124
word Z_MINUS_SLOW  196, 92, 220, 107

//Action
byte Z_PLUS_FAST_ACT "G1 Z10 F200\0"
byte Z_PLUS_NORMAL_ACT "G1 Z1 F200\0"
byte Z_PLUS_SLOW_ACT "G1 Z0.1 F200\0"

byte Z_MINUS_FAST_ACT "G1 Z-10 F200\0"
byte Z_MINUS_NORMAL_ACT "G1 Z-1 F200\0"
byte Z_MINUS_SLOW_ACT "G1 Z-0.1 F200\0"

//Homing
word HOMING  4, 140, 35, 168
word X_HOMING  4, 4, 35, 32
word Y_HOMING  152, 4, 183, 32
word Z_HOMING  150, 139, 190, 178

//Action
byte HOMING_ACT "G28\0"
byte X_HOMING_ACT "G28 X0\0"
byte Y_HOMING_ACT "G28 Y0\0"
byte Z_HOMING_ACT "G28 Z0\0"

#END

/***********************************************************************************
*   Touch Region Button Set
************************************************************************************/
#CONST

EXTMM_ACT 0
EXTMM_MIN_ACT 1
EXTTEMP_ACT 2
BEDTEMP_ACT 3

#END

#DATA
word BUTTON_SET_NUMBER BUTTON_EXTMM,BUTTON_EXTMM_MIN,BUTTON_EXTTEMP,BUTTON_BEDTEMP

word BUTTON_EXTMM 60, 184, 87, 198
word BUTTON_EXTMM_MIN 60, 199, 87, 213
word BUTTON_EXTTEMP 172, 184, 199, 198
word BUTTON_BEDTEMP 172, 199, 199, 213

word TRACKPAD_CONTAINER 28, 140, 212, 176
word WIN_SDCARD_CONTAINER 0, 0, 320, 215

#END


/***********************************************************************************
*   Button SDCard File List
************************************************************************************/
#DATA

word PRINTING_OPTION_TOUCH_REGION 228, 132, 310, 214

word BUTTON_FILES_Y 10,32,54,76,98,120,142,164
word BUTTON_FILES_X 10,112,214

#END

#CONST

BUTTON_FILE_WIDTH 98
BUTTON_FILE_HEIGHT 17

#END

/***********************************************************************************
*   Z Calibration
************************************************************************************/
#DATA

word BUTTON_Z_CAL_TOUCH_REGION 104, 228, 203, 239
word WIN_Z_CAL_TOUCH_REGION 36, 50, 226, 203


word BUTTON_Z_PROBE_TOUCH_REGION 112, 170, 170, 184
word BUTTON_Z_OFFSET_TOUCH_REGION 112, 144, 170, 158
word BUTTON_Z_INT_PLUS_TOUCH_REGION 112, 61, 128, 74
word BUTTON_Z_INT_MINUS_TOUCH_REGION  112, 115, 128, 128
word BUTTON_Z_DEC1_PLUS_TOUCH_REGION 147, 61, 163, 74
word BUTTON_Z_DEC1_MINUS_TOUCH_REGION  147, 115, 163, 128
word BUTTON_Z_DEC2_PLUS_TOUCH_REGION 171, 61, 187, 74
word BUTTON_Z_DEC2_MINUS_TOUCH_REGION 171, 115, 187, 128
word BUTTON_Z_DEC3_PLUS_TOUCH_REGION 195, 61, 211, 74
word BUTTON_Z_DEC3_MINUS_TOUCH_REGION  195, 115, 211, 128
word BUTTON_Z_SIGN_TOUCH_REGION 44, 86, 77, 100

byte FORCE_UPDATE_CMD "M116"

#END

/***********************************************************************************
*   Messages
************************************************************************************/
#DATA

byte MSG_OP_NOT_PERMITTED "Operation not permitted while printing.\0"
byte MSG_SET_HEATER "set Heater target to \0"
byte MSG_SET_BED "set Bed target to \0"
byte MSG_HEATER_SHUTDOWN "Heater shutdown\0"
byte MSG_BED_SHUTDOWN "Bed shutdown\0"
byte MSG_CENT " C\0"
byte MSG_HOMING "Homing...\0"
byte MSG_MM_OF_FILAMENT "mm of filament..\0"
byte MSG_COLD_EXTR_PREVENT "Cold Extrusion Prevent!\0"
byte MSG_TOGGLE_FAN "Switching cooling fan \0"

//ALAN
byte MSG_CentreBed "Centreing ...\0"
byte MSG_MotorsOff "Motors off \0"
// end ALAN

#END


