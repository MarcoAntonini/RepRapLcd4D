// object indexes into ImageControl
#CONST
    iImage1         // offset 0x0
    iImage2         // offset 0x10C00
    iGauge1         // offset 0x14600
    iGauge2         // offset 0x65600
    iGauge3         // offset 0xB6600
    iImage3         // offset 0x107600
    iWinbutton1     // offset 0x107800
    iWinbutton2     // offset 0x108400
    iWinbutton3     // offset 0x109000
    iWinbutton4     // offset 0x109800
    iWinbutton5     // offset 0x10A000
    iWinbutton6     // offset 0x10A800
    iLed2           // offset 0x10B000
    iLed3           // offset 0x10BE00
    iLed1           // offset 0x10C800
    iTrackbar1      // offset 0x10D600
#END

var disk, hndl ;


/***********************************************************************************
*   Touch Region Axis Move
************************************************************************************/
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
byte X_PLUS_FAST_ACT "G91\nG1 X100 F12000\nG90\0"
byte X_PLUS_NORMAL_ACT "G91\nG1 X10 F12000\nG90\0"
byte X_PLUS_SLOW_ACT "G91\nG1 X1 F12000\nG90\0"
byte X_PLUS_VSLOW_ACT "G91\nG1 X0.1 F12000\nG90\0"

byte X_MINUS_FAST_ACT "G91\nG1 X-100 F12000\nG90\0"
byte X_MINUS_NORMAL_ACT "G91\nG1 X-10 F12000\nG90\0"
byte X_MINUS_SLOW_ACT "G91\nG1 X-1 F12000\nG90\0"
byte X_MINUS_VSLOW_ACT "G91\nG1 X-0.1 F12000\nG90\0"


//Y Touch Region
word Y_PLUS_FAST  48,7,135,22
word Y_PLUS_NORMAL  66,27,120,39
word Y_PLUS_SLOW  72,46,118,56
word Y_PLUS_VSLOW  80,60,106,76

word Y_MINUS_FAST  60, 155, 134, 168
word Y_MINUS_NORMAL  69, 137, 122, 149
word Y_MINUS_SLOW  76, 119, 113, 134
word Y_MINUS_VSLOW  82,100,107,116


//Action
byte Y_PLUS_FAST_ACT "G91\nG1 Y100 F12000\nG90\0"
byte Y_PLUS_NORMAL_ACT "G91\nG1 Y10 F12000\nG90\0"
byte Y_PLUS_SLOW_ACT "G91\nG1 Y1 F12000\nG90\0"
byte Y_PLUS_VSLOW_ACT "G91\nG1 Y0.1 F12000\nG90\0"

byte Y_MINUS_FAST_ACT "G91\nG1 Y-100 F12000\nG90\0"
byte Y_MINUS_NORMAL_ACT "G91\nG1 Y-10 F12000\nG90\0"
byte Y_MINUS_SLOW_ACT "G91\nG1 Y-1 F12000\nG90\0"
byte Y_MINUS_VSLOW_ACT "G91\nG1 Y-0.1 F12000\nG90\0"

//Z Touch region
word Z_PLUS_FAST  196, 28, 220, 44
word Z_PLUS_NORMAL  196, 48, 220, 63
word Z_PLUS_SLOW  196, 67, 220, 83

word Z_MINUS_FAST  196, 128, 218, 146
word Z_MINUS_NORMAL  196, 109, 220, 124
word Z_MINUS_SLOW  196, 92, 220, 107

//Action
byte Z_PLUS_FAST_ACT "G91\nG1 Z10 F1000\nG90\0"
byte Z_PLUS_NORMAL_ACT "G91\nG1 Z1 F1000\nG90\0"
byte Z_PLUS_SLOW_ACT "G91\nG1 Z0.1 F1000\nG90\0"

byte Z_MINUS_FAST_ACT "G91\nG1 Z-10 F1000\nG90\0"
byte Z_MINUS_NORMAL_ACT "G91\nG1 Z-1 F1000\nG90\0"
byte Z_MINUS_SLOW_ACT "G91\nG1 Z-0.1 F1000\nG90\0"

//Homing
word HOMING  4, 140, 35, 168
word X_HOMING  4, 4, 35, 32
word Y_HOMING  152, 4, 183, 32
word Z_HOMING  152, 140, 183, 168

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

#END
