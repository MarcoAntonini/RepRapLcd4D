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
    updateMessage(str_Ptr(msg),"","");
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
    initButtonExtrude();
    updateButtonExtrude(FALSE);
    setFontMessage(92, 188);
    printBuffer("mm");

    initButtonReverse();
    updateButtonReverse(FALSE);
    setFontMessage(92,204);
    printBuffer("mm/min");

    gfx_Panel(PANEL_RAISED, 60, 184, 27, 14, 0xD699); // panel Ex mm
    updateExmm(str_Ptr(ex_setmm),BLACK);
    gfx_Panel(PANEL_RAISED, 60, 199, 27, 14, 0xD699); // pnael Ex mm/min
    updateExmm_min(str_Ptr(ex_setmm_min),BLACK);

    //draw Button Temp Extruder Set
    initButtonExOff();
    updateButtonExOff(FALSE);

    initButtonBedOff();
    updateButtonBedOff(FALSE);

    gfx_Panel(PANEL_RAISED, 172, 184, 27, 14, 0xD699); // panel Ex Temp
    gfx_Panel(PANEL_RAISED, 172, 199, 27, 14, 0xD699); // panel Bed Temp

    setFontMessage(202, 188);
    printBuffer("C");
    setFontMessage(202, 204);
    printBuffer("C");

    updateExSetTemp(str_Ptr(ex_setTemp),BLACK);
    updateBedSetTemp(str_Ptr(bed_setTemp),BLACK);

    initButtonExSet();
    updateButtonExSet(FALSE);

    initButtonBedSet();
    updateButtonBedSet(FALSE);

    updateButtonSwitchEx(UPDATE);
endfunc

func drawTempIndicator()
    //draw Extruder0
    gfx_Panel(PANEL_RAISED, 230, 0, 90, 61, 0xD699) ; //Panel Container
    setFontLabel(268,44);
    putstr("/");
    updateHotEnd0(str_Ptr(tH0));
    updateTHotEnd0(str_Ptr(ttH0));

    //draw Extruder1
    gfx_Panel(PANEL_RAISED, 230, 60, 90, 61, 0xD699) ; //Panel Container
    setFontLabel(268,104);
    putstr("/");
    updateHotEnd1(str_Ptr(tH1));
    updateTHotEnd1(str_Ptr(ttH1));

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
    printBuffer("cm");
    updateZpos(str_Ptr(zPos));

    //draw SDPerc
    setFontInfo(216,232);
    printBuffer("SD:");
    setFontInfo(272,232);
    printBuffer("%");
    updateSDPerc(str_Ptr(sdPerc));
endfunc

func setFontLabel(var x,var y)
    txt_Set(FONT_ID,FONT3);
    txt_FGcolour(BLACK);
    txt_BGcolour(0xD699);
    gfx_MoveTo(x,y);
endfunc

func setFontLabelAlert(var x,var y)
    txt_Set(FONT_ID,FONT3);
    txt_FGcolour(RED);
    txt_BGcolour(0xD699);
    gfx_MoveTo(x,y);
endfunc

func setFontInfo(var x,var y)
    txt_Set(FONT_ID,FONT2);
    txt_FGcolour(WHITE);
    txt_BGcolour(BLACK);
    gfx_MoveTo(x,y);
endfunc

func setFontMessage(var x,var y)
    txt_Set(FONT_ID,FONT1);
    txt_FGcolour(WHITE);
    txt_BGcolour(BLACK);
    gfx_MoveTo(x,y);
endfunc

func updateMessage(var *_msg0,var *_msg1,var *_msg2)
    var offset;
    var len;
    len:=(str_Length(_msg0)*7) + (str_Length(_msg1)*7) + (str_Length(_msg2)*7);
    gfx_RectangleFilled(0, 214, 319, 224,BLACK); //Clear old Message
    if(WINDOW==W_SDCARD)
         gfx_TriangleFilled(299, 228, 288, 212,  310, 212, 0x8D9C);
    else if(WINDOW==W_PRINTING_OPTION)
         gfx_TriangleFilled(299, 228, 288, 212,  310, 212, 0x8D9C);
    endif
    offset:= ((MESSAGE_DIM*7) - len)/2; //Offset for Center String
    setFontMessage(offset, 217);
    printBuffer(_msg0);
    printBuffer(_msg1);
    printBuffer(_msg2);
    //sys_SetTimerEvent(TIMER0, returnToMain);
endfunc

func updateBlankMessage()
    updateMessage("","","");
endfunc

func setTimerMessage(var time)
    sys_SetTimerEvent(TIMER0, updateBlankMessage);
    sys_SetTimer(TIMER0,time);
endfunc


func updateHotEnd0(var *_msg)
    var val;
    val := str2w(_msg);
    if(val > _ttH0 && _ttH0 != 0)
        setFontLabelAlert(240,44);
    else
        setFontLabel(240,44);
    endif
    printBuffer(_msg);
    img_SetWord(hndl, iGauge1, IMAGE_INDEX, tempGauge(val,_ttH0,GAUGE_MAX_TEMP_H));
    img_Show(hndl,iGauge1);
endfunc

func updateHotEnd1(var *_msg)
    var val;
    val := str2w(_msg);
    if(val > _ttH1 && _ttH1 != 0)
         setFontLabelAlert(240,104);
    else
        setFontLabel(240,104);
    endif
    printBuffer(_msg);
    img_SetWord(hndl, iGauge2, IMAGE_INDEX, tempGauge(val,_ttH1,GAUGE_MAX_TEMP_H));
    img_Show(hndl,iGauge2) ;
endfunc

func updateTHotEnd0(var *_msg)
    _ttH0:=str2w(_msg);
    if(_ttH0 == 0 )
        updateLedEx0(OFF);
    else
        updateLedEx0(ON);
    endif
    setFontLabel(280,44);
    printBuffer(_msg);
endfunc

func updateTHotEnd1(var *_msg)
    _ttH1:=str2w(_msg);
    if(_ttH1 == 0 )
        updateLedEx1(OFF);
    else
        updateLedEx1(ON);
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
    printBuffer(_msg);
    img_SetWord(hndl, iGauge3, IMAGE_INDEX, tempGauge(str2w(_msg),_ttB,GAUGE_MAX_TEMP_B));
    img_Show(hndl,iGauge3);
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
    if(str2w(_msg)==100)
        PRINTING:=FALSE;
    endif
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
    img_Show(hndl,iLed1);
    img_SetWord(hndl, iLed1, IMAGE_INDEX,!state);
    img_Show(hndl,iLed1);
endfunc

func updateLedEx1(var state)
    img_Show(hndl,iLed2);
    img_SetWord(hndl, iLed2, IMAGE_INDEX,!state);
    img_Show(hndl,iLed2);
endfunc

func updateLedBed(var state)
    img_Show(hndl,iLed3);
    img_SetWord(hndl, iLed3, IMAGE_INDEX,!state);
    img_Show(hndl,iLed3);
endfunc

func str2w(var *buffer)
    var p,ret;
    p:=str_Ptr(buffer);
    str_GetW(&buffer, &ret);
    return ret;
endfunc


func initButtonExtrude()
    img_SetWord(hndl, iWinbutton1, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton1, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton1);
endfunc

func updateButtonExtrude(var state)
    img_SetWord(hndl, iWinbutton1, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton1) ;
endfunc

func initButtonReverse()
    img_SetWord(hndl, iWinbutton2, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton2, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton2);
endfunc

func updateButtonReverse(var state)
    img_SetWord(hndl, iWinbutton2, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton2) ;
endfunc

func initButtonExOff()
    img_SetWord(hndl, iWinbutton3, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton3, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton3);
endfunc

func updateButtonExOff(var state)
   img_SetWord(hndl, iWinbutton3, IMAGE_INDEX, state);
   img_Show(hndl,iWinbutton3) ;
endfunc

func initButtonBedOff()
    img_SetWord(hndl, iWinbutton4, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton4, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton4);
endfunc

func updateButtonBedOff(var state)
    img_SetWord(hndl, iWinbutton4, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton4) ;
endfunc

func initButtonExSet()
    img_SetWord(hndl, iWinbutton5, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton5, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton5);
endfunc

func updateButtonExSet(var state)
    img_SetWord(hndl, iWinbutton5, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton5) ;
endfunc


func initButtonBedSet()
    img_SetWord(hndl, iWinbutton6, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton6, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton6);
endfunc

func updateButtonBedSet(var state)
    img_SetWord(hndl, iWinbutton6, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton6) ;
endfunc

func updateExmm(var *value,var colour)
    txt_Set(FONT_ID,FONT1);
    txt_FGcolour(colour);
    txt_BGcolour(0xD699);
    gfx_MoveTo(63, 188);
    printBuffer(value);
endfunc

func updateExmm_min(var *value,var colour)
    txt_Set(FONT_ID,FONT1);
    txt_FGcolour(colour);
    txt_BGcolour(0xD699);
    gfx_MoveTo(63, 202);
    printBuffer(value);
endfunc

func updateExSetTemp(var *value,var colour)
    txt_Set(FONT_ID,FONT1);
    txt_FGcolour(colour);
    txt_BGcolour(0xD699);
    gfx_MoveTo(175, 188);
    printBuffer(value);
endfunc

func updateBedSetTemp(var *value,var colour)
    txt_Set(FONT_ID,FONT1);
    txt_FGcolour(colour);
    txt_BGcolour(0xD699);
    gfx_MoveTo(175, 203);
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
     gfx_Panel(PANEL_RAISED, 26, 140, 184, 36, COLOUR_TRACKPAD); //TrackPad Container
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
    img_Show(hndl,iTrackbar1);
    img_SetWord(hndl, iTrackbar1, IMAGE_FLAGS, (img_GetWord(hndl, iTrackbar1, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
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

func initButtonFine()
    img_SetWord(hndl, iWinbutton7, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton7, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton7);
    img_SetWord(hndl, iWinbutton8, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton8, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton8);
endfunc

func updateButtonFine(var state)
    img_SetWord(hndl, iWinbutton7, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton7);
    img_SetWord(hndl, iWinbutton8, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton8);
endfunc

func ButtonFinePlusAction()
   var value;
   if(WINDOW == EXTMM_ACT)
        value:=str2w(str_Ptr(ex_setmm));
        value++;
        to(ex_setmm); putnum(DEC,value);
    else if(WINDOW == EXTMM_MIN_ACT)
        value:=str2w(str_Ptr(ex_setmm_min));
        value++;
        to(ex_setmm_min); putnum(DEC,value);
    else if(WINDOW == EXTTEMP_ACT)
        value:=str2w(str_Ptr(ex_setTemp));
        value++;
        to(ex_setTemp); putnum(DEC,value);
    else if(WINDOW == BEDTEMP_ACT)
        value:=str2w(str_Ptr(bed_setTemp));
        value++;
        to(bed_setTemp); putnum(DEC,value);
    endif
    updateTrackbarStatus(WINDOW);

endfunc

func ButtonFineMinusAction()
   var value;
   if(WINDOW == EXTMM_ACT)
        value:=str2w(str_Ptr(ex_setmm));
        value--;
        to(ex_setmm); putnum(DEC,value);
    else if(WINDOW == EXTMM_MIN_ACT)
        value:=str2w(str_Ptr(ex_setmm_min));
        value--;
        to(ex_setmm_min); putnum(DEC,value);
    else if(WINDOW == EXTTEMP_ACT)
        value:=str2w(str_Ptr(ex_setTemp));
        value--;
        to(ex_setTemp); putnum(DEC,value);
    else if(WINDOW == BEDTEMP_ACT)
        value:=str2w(str_Ptr(bed_setTemp));
        value--;
        to(bed_setTemp); putnum(DEC,value);
    endif
    updateTrackbarStatus(WINDOW);

endfunc

func updateButtonSwitchEx(var type)
    if(type==EVENT)
        current_extruder:=!current_extruder;
    endif
    if(current_extruder==0)
        img_SetWord(hndl, iWinbutton9, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton9, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
        img_Show(hndl, iWinbutton9);
        img_SetWord(hndl, iWinbutton9, IMAGE_INDEX,current_extruder);
        img_Show(hndl,iWinbutton9);
    else
        img_SetWord(hndl, iWinbutton10, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton10, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
        img_Show(hndl, iWinbutton10);
        img_SetWord(hndl, iWinbutton10, IMAGE_INDEX,current_extruder);
        img_Show(hndl,iWinbutton10);
    endif
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
    count:=(sd_current_page)*24;
    updatePageFileIndex();
    for(i:=0; i<8 && STOP==FALSE; i++) // Button files is 8x3 Matrix
        for(j:=0; j<3 && STOP==FALSE; j++)
            if(count<file_count)
                     gfx_Button(1,BUTTON_FILES_X[j],BUTTON_FILES_Y[i],GRAY,WHITE,FONT1, 1, 1,files[count]);
                     //drawSingleButtonFile(BUTTON_FILES_X[j],BUTTON_FILES_Y[i],count,files[count]);
                count++;
            else
                STOP:=FALSE;
            endif
        next
    next

endfunc

/*
func drawSingleButtonFile(var x,var y,var index,var *_msg)
    var str;
    var i,len;
    len:=str_Length(files[index]);
    if(len>MAX_FILE_NAME)
        for(i:=0; i<MAX_FILE_NAME-len; i++)
            if(i==0)to(str);
            if(i>0)to(APPEND);
            print(" ");
            if(i==(MAX_FILE_NAME-len-1))
                to(APPEND);
                str_Printf(&_msg,"%s");
            endif
        next
    endif
    gfx_Button(1,x,y,GRAY,WHITE,FONT1, 1, 1,str);

endfunc
*/

func updatePageFileIndex()
    gfx_RectangleFilled(34, 188, 280, 204, 0xD699) ;
    txt_Set(FONT_ID,FONT1);
    txt_FGcolour(BLACK) ;
    txt_BGcolour(0xD699) ;
    gfx_MoveTo(70, 193) ;
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
    //draw Button Left,Right
    img_SetWord(hndl, iWinbutton13, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton13, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton13);
    img_SetWord(hndl, iWinbutton13, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton13) ;
endfunc

func updateButtonPagesRight(var state)
    img_SetWord(hndl, iWinbutton14, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton14, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton14);
    img_SetWord(hndl, iWinbutton14, IMAGE_INDEX, state);
    img_Show(hndl,iWinbutton14);
endfunc

func drawWinPrintingOption()
    gfx_Panel(PANEL_RAISED, 228, 130, 84, 86, 0x8D9C);
    gfx_TriangleFilled(299, 228, 288, 212,  310, 212, 0x8D9C);
    gfx_Panel(PANEL_RAISED, 232, 134, 76, 78, 0xD699);
    updatePauseButton(OFF);
    updateResumeButton(OFF);
    updateOpenFileButton(OFF);
endfunc

func updatePauseButton(var state)
    img_SetWord(hndl, iWinbutton16, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton16, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton16);
    img_SetWord(hndl, iWinbutton16, IMAGE_INDEX,state);
    img_Show(hndl,iWinbutton16);
endfunc

func updateResumeButton(var state)
    img_SetWord(hndl, iWinbutton15, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton15, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton15);
    img_SetWord(hndl, iWinbutton15, IMAGE_INDEX,state);
    img_Show(hndl,iWinbutton15);
endfunc

func updateOpenFileButton(var state)
    img_SetWord(hndl, iWinbutton17, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton17, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton17);
    img_SetWord(hndl, iWinbutton17, IMAGE_INDEX,state);
    img_Show(hndl,iWinbutton17);
endfunc

func map(var x, var in_min,var in_max,var out_min,var out_max)
     return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
endfunc

func WinPrintConfirm(var index,var *_msg)
    var offset:=0;
    offset:= ((MAX_FILE_NAME*7) - ((str_Length(files[index])+1)*7))/2; //Offset for Center String
    gfx_Panel(PANEL_RAISED, 88, 68, 132, 69, 0x8D9C);
    gfx_Panel(PANEL_RAISED, 91, 72, 126, 61, 0xD699) ;
    img_SetWord(hndl, iWinbutton11, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton11, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_Show(hndl, iWinbutton11);
    img_SetWord(hndl, iWinbutton11, IMAGE_INDEX,OFF);
    img_Show(hndl,iWinbutton11) ;
    img_SetWord(hndl, iWinbutton12, IMAGE_FLAGS, (img_GetWord(hndl, iWinbutton12, IMAGE_FLAGS) | I_STAYONTOP) & ~I_TOUCH_DISABLE);
    img_SetWord(hndl, iWinbutton12, IMAGE_INDEX,OFF);
    img_Show(hndl,iWinbutton12) ;
    txt_FGcolour(BLACK);
    txt_BGcolour(0xD699);
    gfx_MoveTo(116, 76);
    putstr("Print file");
    txt_BGcolour(0xD699);
    gfx_MoveTo(106+offset, 88);
    str_Printf(&_msg,"%s ?");
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

