/*
 this file is part of ReprapLcd4D Project

 Original file: Marco Antonini
 Amended Alan D. Ryder 5th March 2013

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

#inherit "Constant.inc"

func drawGfxInterface()
    if(WINDOW==W_MAIN)
        MainGfxInterface();
    else if(WINDOW==W_SDCARD)
         drawSDScreen();
    endif
endfunc

func MainGfxInterface()
    drawAxisMove();
    drawStatusBar();
    drawTempIndicator();
    drawButtonControl();
    updateMessage(str_Ptr(msg)," "," ");
endfunc


func drawAxisMove()
    img_Show(hndl,iImage1); //X-Y pos Image
    img_Show(hndl,iImage2); //Z pos Image
    img_Show(hndl,iImage3); //SD card Image
    gfx_Panel(PANEL_RAISED, 0, 0, 230, 2, 0xD699);
    gfx_Panel(PANEL_RAISED, 1, 178, 230, 3, 0xD699);
    gfx_Panel(PANEL_RAISED, 0, 1, 3, 178, 0xD699);
    gfx_Panel(PANEL_RAISED, 227, 1, 3, 178, 0xD699);
endfunc


func drawButtonControl()
    //draw Extruder/Reverse Section
    updateButtonExtrude(FALSE);
    setFontMessage(92, 188);
    printBuffer("mm");

    updateButtonReverse(FALSE);
    setFontMessage(92,204);
    printBuffer("mm/min");

    gfx_Panel(PANEL_RAISED, 60, 184, 27, 14, 0xD699); // panel Ex mm
    updateExmm(str_Ptr(ex_setmm),BLACK);
    gfx_Panel(PANEL_RAISED, 60, 199, 27, 14, 0xD699); // pnael Ex mm/min
    updateExmm_min(str_Ptr(ex_setmm_min),BLACK);

    //draw Button Temp Extruder Set
    updateButtonExOff(FALSE);

    updateButtonBedOff(FALSE);

    gfx_Panel(PANEL_RAISED, 172, 184, 27, 14, 0xD699); // panel Ex Temp
    gfx_Panel(PANEL_RAISED, 172, 199, 27, 14, 0xD699); // panel Bed Temp

    setFontMessage(202, 188);
    printBuffer("C");
    setFontMessage(202, 204);
    printBuffer("C");

    updateExSetTemp(str_Ptr(ex_setTemp),BLACK);
    updateBedSetTemp(str_Ptr(bed_setTemp),BLACK);

    updateButtonExSet(FALSE);

    updateButtonBedSet(FALSE);

    updateMotorsOffBtn(FALSE);
    updateFanONBtn(FALSE);
    updateFanOFFBtn(FALSE);
    if (PresetTempState == PLA) updatePresetBtn(PLA); else updatePresetBtn(ABStyrene);
    
endfunc

func drawTempIndicator()
    //draw Extruder0
    gfx_Panel(PANEL_RAISED, 230, 60, 90, 61, 0xD699) ; //Panel Container
    setFontLabel(268,104);
    putstr("/");
    updateHotEnd0(str_Ptr(tH0));
    updateTHotEnd0(str_Ptr(ttH0));

gfx_Panel(PANEL_RAISED, 230, 0, 90, 61, 0x0000) ; //Panel Container for top buttons - the final argument is the pane colour which looks to be independentof what is set in the designer
// end ALAN

    //draw Bed
    gfx_Panel(PANEL_RAISED, 230, 120, 90, 61, 0xD699) ; //Panel Container
    setFontLabel(268,164);
    putstr("/");
    updateBed(str_Ptr(tB));
    updateTBed(str_Ptr(ttB));
endfunc

func drawStatusBar()
    gfx_Panel(PANEL_RAISED, 0, 226, 320, 3, 0xD699); // Info Bar
    //draw Time Info
    setFontInfo(4,232);
    printBuffer("Time:");
    updateTime(str_Ptr(timePrint));

    //draw Z pos Info
    setFontInfo(113,232);
    printBuffer("Z:");
    setFontInfo(188,232);
    printBuffer("mm");
    updateZpos(str_Ptr(zPos));

    //draw SDPerc
    setFontInfo(216,232);
    printBuffer("SD:");
    setFontInfo(272,232);
    printBuffer("%");
    updateSDPerc(str_Ptr(sdPerc));
endfunc

func setFont(var x,var y,var font,var fcolor,var bcolor)
    txt_Set(FONT_ID,font);
    txt_FGcolour(fcolor);
    txt_BGcolour(bcolor);
    gfx_MoveTo(x,y);
endfunc

func setFontLabel(var x,var y)
    setFont(x,y,FONT3,BLACK,0xD699);
endfunc

func setFontLabelAlert(var x,var y)
    setFont(x,y,FONT3,RED,0xD699);
endfunc

func setFontInfo(var x,var y)
    setFont(x,y,FONT2,WHITE,BLACK);
endfunc

func setFontMessage(var x,var y)
    setFont(x,y,FONT1,WHITE,BLACK);
endfunc

func updateMessage(var *_msg0,var *_msg1,var *_msg2)
    var offset;
    var len;
    len:=(str_Length(_msg0)*7) + (str_Length(_msg1)*7) + (str_Length(_msg2)*7);
    gfx_RectangleFilled(0, 214, 319, 224,BLACK); //Clear old Message
    if(WINDOW==W_SDCARD)
         gfx_TriangleFilled(299, 228, 288, 212,  310, 212, COLOURSEL_INDICATOR);
    else if(WINDOW==W_PRINTING_OPTION)
         gfx_TriangleFilled(299, 228, 288, 212,  310, 212, COLOURSEL_INDICATOR);
    endif
    offset:= ((MESSAGE_DIM*7) - len)/2; //Offset for Center String
    setFontMessage(offset, 217);
    printBuffer(_msg0);
    printBuffer(_msg1);
    printBuffer(_msg2);
endfunc

func updateBlankMessage()
    updateMessage(" "," "," ");
endfunc

func setTimerMessage(var time)
    sys_SetTimerEvent(TIMER0, updateBlankMessage);
    sys_SetTimer(TIMER0,time);
endfunc


func updateHotEnd0(var *_msg)
    var val;
    val := str2w(_msg);
    if(val > _ttH0 && _ttH0 != 0)
        setFontLabelAlert(240,104);
    else
        setFontLabel(240,104);
    endif
    printBuffer(_msg);
    updateImg(iGauge1,tempGauge(val,_ttH0,GAUGE_MAX_TEMP_H));
endfunc


func updateTHotEnd0(var *_msg)
    _ttH0:=str2w(_msg);
    if(_ttH0 == 0 )
        updateLedEx0(OFF);
    else
        updateLedEx0(ON);
    endif
    setFontLabel(280,104);
    printBuffer(_msg);
endfunc


func updateBed(var *_msg )
    var val;
    val := str2w(_msg);

    if(val > _ttB && _ttB != 0)
        setFontLabelAlert(240,164);
    else
        setFontLabel(240,164);
    endif
    #IF EXISTS SOUND_BED_NOTIFY
    if(val == _ttB && _ttB!=0) sound(ALERT); //sound when the bed has reached the temperature
    if(_ttB ==0 && val==OBJECT_RELEASE_TEMP) sound(ALERT);
    #ENDIF
    printBuffer(_msg);
    updateImg(iGauge3,tempGauge(str2w(_msg),_ttB,GAUGE_MAX_TEMP_B));
endfunc

func updateTBed(var *_msg)
    _ttB:=str2w(_msg);
    if(_ttB == 0 )
        updateLedBed(OFF);
    else
        updateLedBed(ON);
    endif

    setFontLabel(280,164);
    printBuffer(_msg);
endfunc

func updateTime(var *_msg)
    setFontInfo(49,232);
    printBuffer(_msg);
endfunc

func updateSDPerc(var *_msg)
    setFontInfo(242,232);
    printBuffer(_msg);
    if((str2w(_msg)<100) && (str2w(msg)> 0))
        PRINTING:= TRUE; else PRINTING := FALSE;

endfunc

func updateZpos(var *_msg)
    setFontInfo(129,232);
    printBuffer(_msg);
endfunc

func tempGauge(var current_val,var target,var max_temp)
    // val : target = x : GAUGE_TTEMP
    var ret;
    if(target!=0)
        ret := (current_val*GAUGE_TTEMP)/target;
    else
        ret := (current_val*GAUGE_TTEMP)/max_temp;
    endif
    if(ret>100)
        ret:=100;
    else if(ret <0)
        ret:=0;
    endif
    return ret;
endfunc

func updateLedEx0(var state)
    updateImg(iLed1,!state);
endfunc


func updateLedBed(var state)
    updateImg(iLed3,!state);
endfunc

func str2w(var *buffer)
    var p,ret;
    p:=str_Ptr(buffer);
    str_GetW(&buffer, &ret);
    return ret;
endfunc

func updateButtonExtrude(var state)
    updateImg(iWinbutton1,state);
endfunc

func updateButtonReverse(var state)
    updateImg(iWinbutton2,state);
endfunc

func updateButtonExOff(var state)
   updateImg(iWinbutton3,state);
endfunc

func updateButtonBedOff(var state)
    updateImg(iWinbutton4,state);
endfunc

func updateButtonExSet(var state)
    updateImg(iWinbutton5,state);
endfunc

func updateButtonBedSet(var state)
    updateImg(iWinbutton6,state);
endfunc

func updateFanONBtn(var state)
    updateImg(iFanONBtn,state);
endfunc

func updateMotorsOffBtn(var state)
    updateImg(iMotorsOffBtn,state);
endfunc

func updateFanOFFBtn(var state)
    updateImg(iFanOFFBtn,state);
endfunc

func updatePresetBtn(var state)
    updateImg(iPresetTempBtn,state);
endfunc


func updateExmm(var *value,var colour)
    setFont(63,188,FONT1,colour,0xD699);
    printBuffer(value);
endfunc

func updateExmm_min(var *value,var colour)
    setFont(63,202,FONT1,colour,0xD699);
    printBuffer(value);
endfunc

func updateExSetTemp(var *value,var colour)
    setFont(175,188,FONT1,colour,0xD699);
    printBuffer(value);
endfunc

func updateBedSetTemp(var *value,var colour)
    setFont(175,203,FONT1,colour,0xD699);
    printBuffer(value);
endfunc


func remove_currentTrackpad()
   if(WINDOW == EXTMM_ACT)
        gfx_TriangleFilled(71, 183, 60, 172,  82, 172, BLACK);
    else if(WINDOW == EXTMM_MIN_ACT)
        gfx_TriangleFilled(71, 198, 60, 172,  82, 172, BLACK);
    else if(WINDOW == EXTTEMP_ACT)
        gfx_TriangleFilled(183, 183, 172, 172,  194, 172, BLACK);
    else if(WINDOW == BEDTEMP_ACT)
        gfx_TriangleFilled(187, 199, 176, 172,  198, 172, BLACK);
    endif

    drawAxisMove();
    drawButtonControl();
endfunc

func initTrackbar(var type)
     gfx_Panel(PANEL_RAISED, 26, 140, 184, 36, COLOURSEL_INDICATOR); //TrackPad Container
    if(type == EXTMM_ACT)
        gfx_TriangleFilled(71, 183, 60, 172,  82, 172, COLOURSEL_INDICATOR);
        WINDOW := W_EXTMM;
    else if(type == EXTMM_MIN_ACT)
        gfx_TriangleFilled(71, 198, 60, 172,  82, 172, COLOURSEL_INDICATOR);
        WINDOW := W_EXTMM_MIN;
    else if(type == EXTTEMP_ACT)
        gfx_TriangleFilled(183, 183, 172, 172,  194, 172, COLOURSEL_INDICATOR);
        WINDOW := W_EXTTEMP;
    else if(type == BEDTEMP_ACT)
        gfx_TriangleFilled(187, 199, 176, 172,  198, 172, COLOURSEL_INDICATOR);
        WINDOW := W_BEDTEMP;
    endif
endfunc

func updateTrackbarStatus(var type)
    var max_value;
    var value;
    if(type == EXTMM_ACT)
        max_value:=TRACKPAD_MAX_EXTMM;
        value:=str2w(str_Ptr(ex_setmm));
        updateExmm(str_Ptr(ex_setmm),COLOURSEL); //also update the color selection
    else if(type == EXTMM_MIN_ACT)
        max_value:=TRACKPAD_MAX_EXTMM_MIN;
        value:=str2w(str_Ptr(ex_setmm_min));
        updateExmm_min(str_Ptr(ex_setmm_min),COLOURSEL); //also update the color selection
    else if(type == EXTTEMP_ACT)
         max_value:=TRACKPAD_MAX_EXTTEMP;
         value:=str2w(str_Ptr(ex_setTemp));
         updateExSetTemp(str_Ptr(ex_setTemp),COLOURSEL); //also update the color selection
    else if(type == BEDTEMP_ACT)
         max_value:=TRACKPAD_MAX_BEDTEMP;
         value:=str2w(str_Ptr(bed_setTemp));
         updateBedSetTemp(str_Ptr(bed_setTemp),COLOURSEL); //also update the color selection
    endif
    img_SetWord(hndl, iTrackbar1, IMAGE_INDEX,map(value,0,max_value,0,100));
    img_Show(hndl, iTrackbar1);

endfunc

func updateTrackbarEvent(var type,var x) // x coord.
    var max_value;
    var value,posn;
    posn := x - 74 ;                        // x - left - borderwidth
    if (posn < 0)
        posn := 0 ;
    else if (posn > 114)                    // width - 2*borderwidth - 8
        posn := 100 ;                       // maxvalue-minvalue
    else
        posn := 100 * posn / 114 ;    // (max-min) * posn / (width-2*borderwidth-8)
    endif
    if(type == EXTMM_ACT)
        max_value:=TRACKPAD_MAX_EXTMM;
        value:=map(posn,0,100,0,max_value);
        to(ex_setmm); putnum(DEC,value);
        updateExmm("   ",COLOURSEL);
        updateExmm(str_Ptr(ex_setmm),COLOURSEL);
    else if(type == EXTMM_MIN_ACT)
        max_value:=TRACKPAD_MAX_EXTMM_MIN;
        value:=map(posn,0,100,0,max_value);
        //SerialPrintlnNumber(value);
        to(ex_setmm_min); putnum(DEC,value);
        updateExmm_min("   ",COLOURSEL);
        updateExmm_min(str_Ptr(ex_setmm_min),COLOURSEL);
    else if(type == EXTTEMP_ACT)
         max_value:=TRACKPAD_MAX_EXTTEMP;
         value:=map(posn,0,100,0,max_value);
         to(ex_setTemp); putnum(DEC,value);
         updateExSetTemp("   ",COLOURSEL);
         updateExSetTemp(str_Ptr(ex_setTemp),COLOURSEL);
    else if(type == BEDTEMP_ACT)
         max_value:=TRACKPAD_MAX_BEDTEMP;
         value:=map(posn,0,100,0,max_value);
         to(bed_setTemp); putnum(DEC,value);
         updateBedSetTemp("   ",COLOURSEL);
         updateBedSetTemp(str_Ptr(bed_setTemp),COLOURSEL);
    endif
    img_SetWord(hndl, iTrackbar1, IMAGE_INDEX,posn);
    img_Show(hndl, iTrackbar1);

endfunc

func updateButtonFine(var state)
    updateImg(iWinbutton7,state);
    updateImg(iWinbutton8,state);
endfunc

func ButtonFinePlusAction()
   var value;
   if(WINDOW == EXTMM_ACT)
        value:=str2w(str_Ptr(ex_setmm));
        if(value < TRACKPAD_MAX_EXTMM)
            value++;
        endif
        to(ex_setmm); putnum(DEC,value);
    else if(WINDOW == EXTMM_MIN_ACT)
        value:=str2w(str_Ptr(ex_setmm_min));
        if(value < TRACKPAD_MAX_EXTMM_MIN)
            value++;
        endif
        to(ex_setmm_min); putnum(DEC,value);
    else if(WINDOW == EXTTEMP_ACT)
        value:=str2w(str_Ptr(ex_setTemp));
        if(value < TRACKPAD_MAX_EXTTEMP)
            value++;
        endif
        to(ex_setTemp); putnum(DEC,value);
    else if(WINDOW == BEDTEMP_ACT)
        value:=str2w(str_Ptr(bed_setTemp));
        if(value < TRACKPAD_MAX_BEDTEMP)
            value++;
        endif
        to(bed_setTemp); putnum(DEC,value);
    endif
    updateTrackbarStatus(WINDOW);

endfunc

func ButtonFineMinusAction()
   var value;
   if(WINDOW == EXTMM_ACT)
        value:=str2w(str_Ptr(ex_setmm));
        if(value > 0 )
            value--;
        endif
        to(ex_setmm); putnum(DEC,value);
    else if(WINDOW == EXTMM_MIN_ACT)
        value:=str2w(str_Ptr(ex_setmm_min));
        if(value > 0 )
            value--;
        endif
        to(ex_setmm_min); putnum(DEC,value);
    else if(WINDOW == EXTTEMP_ACT)
        value:=str2w(str_Ptr(ex_setTemp));
        if(value >0)
            value--;
        endif
        to(ex_setTemp); putnum(DEC,value);
    else if(WINDOW == BEDTEMP_ACT)
        value:=str2w(str_Ptr(bed_setTemp));
        if(value > 0 )
            value--;
        endif
        to(bed_setTemp); putnum(DEC,value);
    endif
    updateTrackbarStatus(WINDOW);

endfunc

func updateButtonFileList()
    var i,j,count;
    var STOP:=FALSE;
    count:=0;

    if(sd_current_page>sd_page_count)
        sd_current_page:=0;
    else if(sd_current_page<0)
        sd_current_page:=sd_page_count;
    endif
    count:=(sd_current_page)*24; //24 is max button file in one page
    updatePageFileIndex();
    for(i:=0; i<8 && STOP==FALSE; i++) // Button files is 8x3 Matrix
        for(j:=0; j<3 && STOP==FALSE; j++)
            if(count<file_count)
                     gfx_Button(1,BUTTON_FILES_X[j],BUTTON_FILES_Y[i],GRAY,WHITE,FONT1, 1, 1,files[count]);
                count++;
            else
                STOP:=TRUE;
            endif
        next
    next

endfunc


func updatePageFileIndex()

    if( sd_current_page <0 || file_count <0 || sd_page_count<0) // check if the variable is populated (error only IDE 4 ?? )
                                                                // why? already initialized in initVars() !!
         sd_current_page:=0;
         file_count:=0;
         sd_page_count:=0;
    endif
    gfx_RectangleFilled(34, 188, 280, 204, 0xD699);
    setFont(70,193,FONT1,BLACK,0xD699);
    putstr("page ");
    putnum(DEC,sd_current_page+1);
    putstr(" of ");
    putnum(DEC,sd_page_count+1);
    putstr(" (");
    putnum(DEC,file_count);
    putstr(" files)");
endfunc

func drawSDScreen()
    gfx_RectangleFilled(200, 200, 318, 221,BLACK);
    gfx_Panel(PANEL_RAISED, 0, 0, 320, 215, COLOURSEL_INDICATOR);
    gfx_TriangleFilled(299, 228, 288, 212,  310, 212, COLOURSEL_INDICATOR);
    gfx_Panel(PANEL_RAISED, 4, 4, 312, 207, 0xD699);
    updateButtonPagesLeft(OFF);
    updateButtonPagesRight(OFF);
    updatePageFileIndex();
endfunc

func updateButtonPagesLeft(var state)
    updateImg(iWinbutton13,state);
endfunc

func updateButtonPagesRight(var state)
    updateImg(iWinbutton14,state);
endfunc

func drawWinPrintingOption()
    gfx_Panel(PANEL_RAISED, 228, 130, 84, 86, COLOURSEL_INDICATOR);
    gfx_TriangleFilled(299, 228, 288, 212,  310, 212, COLOURSEL_INDICATOR);
    gfx_Panel(PANEL_RAISED, 232, 134, 76, 78, 0xD699);
    updatePauseButton(OFF);
    updateResumeButton(OFF);
    updateOpenFileButton(OFF);
endfunc

func updatePauseButton(var state)
    updateImg(iWinbutton16,state);
endfunc

func updateResumeButton(var state)
    updateImg(iWinbutton15,state);
endfunc

func updateOpenFileButton(var state)
    updateImg(iWinbutton17,state);
endfunc

func map(var x, var in_min,var in_max,var out_min,var out_max)
     return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
endfunc

func WinPrintConfirm(var index,var *_msg)
    var offset:=0;
    offset:= ((MAX_FILE_NAME*7) - ((str_Length(files[index])+1)*7))/2; //Offset for Center String
    gfx_Panel(PANEL_RAISED, 88, 68, 132, 69, COLOURSEL_INDICATOR);
    gfx_Panel(PANEL_RAISED, 91, 72, 126, 61, 0xD699);
    updateImg(iWinbutton11,OFF);
    updateImg(iWinbutton12,OFF);
    setFont(116,76,FONT1,BLACK,0xD699);
    putstr("Print file");
    setFont(106+offset,88,FONT1,BLACK,0xD699);
    str_Printf(&_msg,"%s ?");
endfunc

func drawWinZCalibration()
    var i;
    gfx_Panel(PANEL_RAISED, 36, 50, 190, 153, COLOURSEL_INDICATOR);
    gfx_TriangleFilled(141, 223, 128, 200,  154, 200, COLOURSEL_INDICATOR);
    gfx_Panel(PANEL_RAISED, 39, 54, 183, 147, 0xD699);
    for(i:=0; i<11; i++)
         updateButtonZCal(i,OFF);
    next
    setFont(137,92,FONT1,BLACK,0xD699);
    txt_Height(2);
    txt_Width(1);
    putstr(",");
    Font1x1();
endfunc

func setFontZCal(var x , var y)
    setFont(x,y,FONT1,BLACK,SILVER);
    txt_Height(2);
    txt_Width(2);
endfunc

func Font1x1()
    txt_Height(1);
    txt_Width(1);
endfunc

func updateButtonZCal(var type,var state)

    //setOffset
    if(type==Z_SET_OFFSET)
        updateImg(iWinbutton21,state);
    //Zprobe
    else if(type==Z_PROBE)
        updateImg(iWinbutton18,state);
    //Sign
    else if(type==Z_SIGN)
        gfx_Panel(PANEL_RAISED, 82, 80, 22, 30, SILVER) ;
        updateImg(iWinbutton30,state);
        setFontZCal(87,87);
        if(z_cal_sign>0)
            putstr("+");
        else
            putstr("-");
        endif
        Font1x1();
    //Int+
    else if(type==Z_INT_PLUS)
        gfx_Panel(PANEL_RAISED, 110, 80, 22, 30, SILVER) ;
        updateImg(iWinbutton19,state);
        setFontZCal(115,87);
        putnum(DEC,z_cal_int);
        Font1x1();
    //Int-
    else if(type==Z_INT_MINUS)
        gfx_Panel(PANEL_RAISED, 110, 80, 22, 30, SILVER);
        updateImg(iWinbutton26,state);
        setFontZCal(115,87);
        putnum(DEC,z_cal_int);
        Font1x1();
    //Dec1+
    else if(type==Z_DEC1_PLUS)
        gfx_Panel(PANEL_RAISED, 146, 80, 22, 30, SILVER) ;
        updateImg(iWinbutton20,state);
        setFontZCal(151,87);
        putnum(DEC,z_cal_dec1);
        Font1x1();
    //Dec1-
    else if(type==Z_DEC1_MINUS)
        gfx_Panel(PANEL_RAISED, 146, 80, 22, 30, SILVER) ;
        updateImg(iWinbutton27,state);
        setFontZCal(151,87);
        putnum(DEC,z_cal_dec1);
        Font1x1();
    //Dec2+
    else if(type==Z_DEC2_PLUS)
        gfx_Panel(PANEL_RAISED, 170, 80, 22, 30, SILVER);
        updateImg(iWinbutton22,state);
        setFontZCal(175,87);
        putnum(DEC,z_cal_dec2);
        Font1x1();
    //Dec2-
    else if(type==Z_DEC2_MINUS)
        gfx_Panel(PANEL_RAISED, 170, 80, 22, 30, SILVER);
        updateImg(iWinbutton28,state);
        setFontZCal(175,87);
        putnum(DEC,z_cal_dec2);
        Font1x1();
    //Dec3+
    else if(type==Z_DEC3_PLUS)
        gfx_Panel(PANEL_RAISED, 194, 80, 22, 30, SILVER) ;
        updateImg(iWinbutton23,state);
        setFontZCal(199,87);
        putnum(DEC,z_cal_dec3);
        Font1x1();
    //Dec3-
    else if(type==Z_DEC3_MINUS)
        gfx_Panel(PANEL_RAISED, 194, 80, 22, 30, SILVER) ;
        updateImg(iWinbutton29,state);
        setFontZCal(199,87);
        putnum(DEC,z_cal_dec3);
        Font1x1();
    endif
endfunc

func EnableAllTouchButtonImage()
    img_SetWord(hndl, iWinbutton1, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton1, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton2, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton2, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton3, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton3, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton4, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton4, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton5, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton5, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton6, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton6, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iTrackbar1, IMAGE_FLAGS, (img_GetWord(hndl, iTrackbar1, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton7, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton7, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton8, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton8, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton13, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton13, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton14, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton14, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton16, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton16, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton15, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton15, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton17, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton17, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton11, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton11, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton12, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton12, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);

    img_SetWord(hndl, iFanONBtn, IMAGE_FLAGS, (img_GetWord(hndl, iFanONBtn, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE); // set to enable touch, only need to do this once
    img_SetWord(hndl, iMotorsOffBtn, IMAGE_FLAGS, (img_GetWord(hndl, iMotorsOffBtn, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE); // set to enable touch, only need to do this once
    img_SetWord(hndl, iFanOFFBtn, IMAGE_FLAGS, (img_GetWord(hndl, iFanOFFBtn, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE); // set to enable touch, only need to do this once
    img_SetWord(hndl, iPresetTempBtn, IMAGE_FLAGS, (img_GetWord(hndl, iPresetTempBtn, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE); // set to enable touch, only need to do this once

endfunc

func updateImg(var img,var state)
    img_SetWord(hndl,img,IMAGE_INDEX,state);
    img_Show(hndl,img);
endfunc

func switchWinSDtoMain()
    if(FILE_START==TRUE)
        mem_Free(filenames); // Free!!! :)
        FILE_START:=FALSE;
        SD_READING:=FALSE;
    endif
    sd_page_count:=0;
    file_count:=0;
    sd_current_page:=0;
    file_count:=0;
    WINDOW:=W_MAIN;
    gfx_RectangleFilled(0, 167, 319, 229,BLACK);
    drawGfxInterface();
endfunc

func PopulateTemperatures(var ExTemp, var BedTemp)
   to(ex_setTemp); putnum(DEC,ExTemp);
         updateExSetTemp("   ",BLACK);
         updateExSetTemp(str_Ptr(ex_setTemp),BLACK);

    to(bed_setTemp); putnum(DEC,BedTemp);
         updateBedSetTemp("   ",BLACK);
         updateBedSetTemp(str_Ptr(bed_setTemp),BLACK);
endfunc
