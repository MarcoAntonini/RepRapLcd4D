/*
 this file is part of ReprapLcd4D Project

 Original File: Marco Antonini
 Amended by Alan D. Ryder 6th March 2013

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

var __X;
var __Y;
var touched;
var file_selected;

func TouchEvent(var x,var y)
     var i;
    __X:=x;
    __Y:=y;

    touched:=img_Touched(hndl,-1);

    if(WINDOW==W_MAIN)  //Window Main TouchEvent
        if( checkRegion( @ TOUCH_AXIS_IMAGE_REGION)) //Axis Move
            if(PRINTING==FALSE)
                for(i:=0; i<sizeof(AXIS_MOVE_TOUCH_REGION); i++)
                    if( checkRegion( @ AXIS_MOVE_TOUCH_REGION[i] ) ) //Moves the axes depending on the region Touched
                        SerialPrintlnBuffer("G91");
                        pause(5);
                        SerialPrintlnBuffer(AXIS_MOVE_TOUCH_ACTION[i]);
                        pause(5);
                        SerialPrintlnBuffer("G90");
                        if(i==HOMING_ACTION_INDEX)
                            updateMessage(MSG_HOMING," "," ");
                            setTimerMessage(4500);
                        endif
                        pause(50);
                        break;
                    endif
                next
            else
                updateMessage( MSG_OP_NOT_PERMITTED," "," ");
                setTimerMessage(3000);
            endif
        else if(touched==iImage3) //SD Card TouchEvent
            WINDOW:=W_PRINTING_OPTION;
            drawWinPrintingOption();
        else if(touched==iWinbutton1) //Extrude Button

                if(PRINTING==FALSE)
                     if (str2w(str_Ptr(tH0))>= EXTRUDE_MINTEMP)
                        updateButtonExtrude(ON);
                        //Send Gcode
                        SerialPrintBuffer("G1 E");
                        SerialPrintNumber(str2w(str_Ptr(ex_setmm)));
                        SerialPrintBuffer(" F");
                        SerialPrintlnNumber(str2w(str_Ptr(ex_setmm_min)));
                        SerialPrintlnBuffer("G90");
                        updateMessage("Extrude ",str_Ptr(ex_setmm),MSG_MM_OF_FILAMENT);
                        setTimerMessage(3000);
                      else
                         updateMessage(MSG_COLD_EXTR_PREVENT," "," ");
                         setTimerMessage(3000);
                    endif
                else
                    updateMessage(MSG_OP_NOT_PERMITTED," "," ");
                    setTimerMessage(3000);
                endif
        else if(touched==iWinbutton2) //Reverse Button

                if(PRINTING==FALSE)
                      if (str2w(str_Ptr(tH0))>= EXTRUDE_MINTEMP)
                        updateButtonReverse(ON);
                       //Send Gcode
                        SerialPrintBuffer("G1 E-");
                        SerialPrintNumber(str2w(str_Ptr(ex_setmm)));
                        SerialPrintBuffer(" F");
                        SerialPrintlnNumber(str2w(str_Ptr(ex_setmm_min)));
                        SerialPrintlnBuffer("G90");
                        updateMessage("Reverse ",str_Ptr(ex_setmm),MSG_MM_OF_FILAMENT);
                        setTimerMessage(3000);
                      else
                         updateMessage(MSG_COLD_EXTR_PREVENT," "," ");
                         setTimerMessage(3000);
                    endif
                else
                    updateMessage(MSG_OP_NOT_PERMITTED," "," ");
                    setTimerMessage(3000);
                endif
        else if(touched==iWinbutton3) //Extruder Off
            updateButtonExOff(ON);
            //Send Gcode
            SerialPrintBuffer("M104 S0");
            SerialPrintBuffer("\n");
            updateMessage(MSG_HEATER_SHUTDOWN," "," ");
            setTimerMessage(3000);

        else if(touched==iWinbutton4) //Bed Off
            updateButtonBedOff(ON);
            //Send Gcode
            SerialPrintlnBuffer("M140 S0");
            updateMessage(MSG_BED_SHUTDOWN," "," ");
            setTimerMessage(3000);
        else if(touched==iWinbutton5) //Extruder Set
            updateButtonExSet(ON);
            //Send Gcode
            SerialPrintBuffer("M104 S");
            SerialPrintNumber(str2w(str_Ptr(ex_setTemp)));
            SerialPrintBuffer("\n");
            updateMessage(MSG_SET_HEATER,str_Ptr(ex_setTemp),MSG_CENT);
            setTimerMessage(3000);

         else if (touched==iFanONBtn) // Turn on cooling fan
                 //Send Gcode
                 SerialPrintlnBuffer("M106");
                 updateMessage(MSG_FanON," "," ");
                 setTimerMessage(3000);

         else if (touched==iFanOFFBtn) // Turn off cooling fan
                 //Send Gcode
                 SerialPrintlnBuffer("M107");
                 updateMessage(MSG_FanOFF," "," ");
                 setTimerMessage(3000);

         else if (touched==iMotorsOffBtn) // Deactivate motors
               if(PRINTING==FALSE)
                  //Send Gcode
                  SerialPrintlnBuffer("M84");
                  updateMessage(MSG_MotorsOff," "," ");
                  setTimerMessage(3000);
               else
                  updateMessage(MSG_OP_NOT_PERMITTED," "," ");
                  setTimerMessage(3000);
               endif

         else if(touched==iWinbutton6) //Bed Set
            updateButtonBedSet(ON);
            //Send Gcode
            SerialPrintBuffer("M140 S");
            SerialPrintlnNumber(str2w(str_Ptr(bed_setTemp)));
            updateMessage(MSG_SET_BED,str_Ptr(bed_setTemp),MSG_CENT);
            setTimerMessage(3000);

         else if(touched==iPresetTempBtn) //Preset temperature button
                if(PRINTING==FALSE)
                    if (PresetTempState == ABStyrene) //Currently showing ABS
                          updatePresetBtn(PLA); //Now show PLA
                          PresetTempState := PLA;
                          PopulateTemperatures(PLAExtrude,PLABed);
                    else
                          updatePresetBtn(ABStyrene); //Now show ABS
                          PresetTempState := ABStyrene;
                          PopulateTemperatures(ABSExtrude,ABSBed);
                    endif
                 else updateMessage(MSG_OP_NOT_PERMITTED," "," ");

           else if(checkRegion( @ BUTTON_Z_CAL_TOUCH_REGION))
                WINDOW:=W_Z_CALIBRATION;
                drawWinZCalibration();
                else  //ALL "Button Set NUMBER"
                  for(i:=0; i<sizeof(BUTTON_SET_NUMBER); i++)
                       if(checkRegion( @ BUTTON_SET_NUMBER[i]))
                             initTrackbar(i);
                        updateTrackbarStatus(i);
                        updateButtonFine(FALSE);
                        break;
                       endif
                  next
                 endif

           else if(WINDOW==W_EXTMM || WINDOW==W_EXTMM_MIN || WINDOW==W_EXTTEMP || WINDOW==W_BEDTEMP) //Window Button Set Number TouchEvent
                    if(touched==iTrackbar1)
                      updateTrackbarEvent(WINDOW,x);
                      EN_TOUCH_MOVING:=TRUE;

                    else if(touched==iWinbutton7) //Fine Plus
                            ButtonFinePlusAction();
                            pause(70);

            else if(touched==iWinbutton8) //Fine Minus
                   ButtonFineMinusAction();
            pause(70);

           else if(!checkRegion( @ TRACKPAD_CONTAINER))
                    remove_currentTrackpad();
                    EN_TOUCH_MOVING:=FALSE;
                    WINDOW:=W_MAIN; //Return to Windows Main
                 endif

    else if(WINDOW==W_SDCARD) //Window SDCard Touch event
        if(touched==iWinbutton14 && sd_page_count!=0) //left button
            updateButtonPagesLeft(ON);
            sd_current_page++;
            drawSDScreen();
            updateButtonFileList();
        else if(touched==iWinbutton13 && sd_page_count!=0) //right button
            updateButtonPagesRight(ON);
            sd_current_page--;
            drawSDScreen();
            updateButtonFileList();
        else if(checkRegion( @ WIN_SDCARD_CONTAINER))
            var j;
            var STOP:=FALSE;
            file_selected:=sd_current_page*24; //24 is max file name for one page
            for(i:=0; i<8 && STOP==FALSE; i++) // Button files is 8x3 Matrix
                for(j:=0; j<3 && STOP==FALSE; j++)
                    if(file_selected<file_count)
                        if(checkRegion(BUTTON_FILES_X[j],BUTTON_FILES_Y[i],
                                       BUTTON_FILES_X[j]+BUTTON_FILE_WIDTH,BUTTON_FILES_Y[i]+BUTTON_FILE_HEIGHT))
                            WINDOW:=W_PRINT_CONFIRM;
                            //SerialPrintlnBuffer(files[file_selected]); //For DEBUG
                            WinPrintConfirm(file_selected,files[file_selected]);
                            STOP:=TRUE;
                            break;
                        endif
                        file_selected++;
                    endif
                next
            next
        else //Exit SD Card Windows
             switchWinSDtoMain();
        endif
    else if(WINDOW==W_PRINT_CONFIRM)
        if(touched==iWinbutton11) //Yes Confirm
             //Send Gcode
            SerialPrintBuffer("M23 "); // Print file
            SerialPrintlnBuffer(files[file_selected]);
            pause(200);
            updateMessage("Printing file ",files[file_selected]," ");
            //setTimerMessage(3000);
            SerialPrintlnBuffer("M24");
            PRINTING:=TRUE;
            //updateMessage(files[file_selected]);
            switchWinSDtoMain();
        else if(touched==iWinbutton12) //No Confirm
             WINDOW:=W_SDCARD;
             drawSDScreen();
             updateButtonFileList();
        endif
    else if(WINDOW==W_PRINTING_OPTION)
        if(touched==iWinbutton15) //Resume Print Button
             updateResumeButton(ON);
             //Send Gcode
             SerialPrintBuffer("M24\n");
             PRINTING:=TRUE;
        else if(touched==iWinbutton16) //Pause Button
             updatePauseButton(ON);
             //Send Gcode
             SerialPrintBuffer("M25\n");
             PRINTING:=FALSE;
        else if(touched==iWinbutton17) //Open File Button
            updateOpenFileButton(ON);
            WINDOW:=W_SDCARD;
            SD_READING:=TRUE;
            //Send Gcode
            SerialPrintBuffer("M21\nM20\n");
            drawSDScreen();
        else if(!checkRegion( @ PRINTING_OPTION_TOUCH_REGION)) //out of Window, return to Main
            WINDOW:=W_MAIN;
            switchWinSDtoMain();
        endif
    else if(WINDOW==W_Z_CALIBRATION)
        if(checkRegion(@ BUTTON_Z_OFFSET_TOUCH_REGION)) //setOffset
             updateButtonZCal(Z_SET_OFFSET,ON);
             //Send Gcode
             SerialPrintBuffer("M206 Z");
             if(z_cal_sign>0)
                SerialPrintBuffer("+");
             else
                SerialPrintBuffer("-");
             endif
             SerialPrintNumber(z_cal_int);
             SerialPrintBuffer(".");
             SerialPrintNumber(z_cal_dec1);
             SerialPrintNumber(z_cal_dec2);
             SerialPrintlnNumber(z_cal_dec3);
             SerialPrintlnBuffer(HOMING_ACT);

        else if(checkRegion(@ BUTTON_Z_PROBE_TOUCH_REGION)) //Zprobe
            updateButtonZCal(Z_PROBE,ON);
            //Send Gcode
            SerialPrintBuffer("M510\nG32\n");
        else if(checkRegion(@BUTTON_Z_SIGN_TOUCH_REGION)) //Sign
             if(z_cal_sign>0)
                z_cal_sign:=-1;
             else
                z_cal_sign:=1;
             endif
             updateButtonZCal(Z_SIGN,ON);
        else if(checkRegion( @ BUTTON_Z_INT_PLUS_TOUCH_REGION)) //Int+
             z_cal_int++;
             z_cal_int:=z_cal_numb_limit(z_cal_int);
             updateButtonZCal(Z_INT_PLUS,ON);
        else if(checkRegion( @ BUTTON_Z_INT_MINUS_TOUCH_REGION)) //Int-
             z_cal_int--;
             z_cal_int:=z_cal_numb_limit(z_cal_int);
             updateButtonZCal(Z_INT_MINUS,ON);
        else if(checkRegion( @ BUTTON_Z_DEC1_PLUS_TOUCH_REGION)) //Dec1+
             z_cal_dec1++;
             z_cal_dec1:=z_cal_numb_limit(z_cal_dec1);
             updateButtonZCal(Z_DEC1_PLUS,ON);
        else if(checkRegion( @ BUTTON_Z_DEC1_MINUS_TOUCH_REGION)) //Dec1-
             z_cal_dec1--;
             z_cal_dec1:=z_cal_numb_limit(z_cal_dec1);
             updateButtonZCal(Z_DEC1_MINUS,ON);
        else if(checkRegion( @ BUTTON_Z_DEC2_PLUS_TOUCH_REGION)) //Dec2+
             z_cal_dec2++;
             z_cal_dec2:=z_cal_numb_limit(z_cal_dec2);
             updateButtonZCal(Z_DEC2_PLUS,ON);
        else if(checkRegion( @ BUTTON_Z_DEC2_MINUS_TOUCH_REGION)) //Dec2-
             z_cal_dec2--;
             z_cal_dec2:=z_cal_numb_limit(z_cal_dec2);
             updateButtonZCal(Z_DEC2_MINUS,ON);
        else if(checkRegion( @ BUTTON_Z_DEC3_PLUS_TOUCH_REGION)) //Dec3+
             z_cal_dec3++;
             z_cal_dec3:=z_cal_numb_limit(z_cal_dec3);
             updateButtonZCal(Z_DEC3_PLUS,ON);
        else if(checkRegion( @ BUTTON_Z_DEC3_MINUS_TOUCH_REGION)) //Dec3-
             z_cal_dec3--;
             z_cal_dec3:=z_cal_numb_limit(z_cal_dec3);
             updateButtonZCal(Z_DEC3_MINUS,ON);
        else if(!checkRegion( @ WIN_Z_CAL_TOUCH_REGION)) //out of Window, return to Main
            WINDOW:=W_MAIN;
            gfx_RectangleFilled(0, 176, 319, 224, BLACK);
            drawGfxInterface();
        endif
    endif
endfunc

/* Release Event only for Gfx interface Button*/
func TouchReleasedEvent()
       if(touched==iWinbutton1 && WINDOW==W_MAIN) //Extrude Button
            updateButtonExtrude(OFF);
        else if(touched==iWinbutton2 && WINDOW==W_MAIN) //Reverse Button
            updateButtonReverse(OFF);
        else if(touched==iWinbutton3 && WINDOW==W_MAIN) //Extruder Off
            updateButtonExOff(OFF);
        else if(touched==iWinbutton4 && WINDOW==W_MAIN) //Bed Off
            updateButtonBedOff(OFF);
        else if(touched==iWinbutton5 && WINDOW==W_MAIN) //Extruder Set
            updateButtonExSet(OFF);
        else if(touched==iWinbutton6 && WINDOW==W_MAIN) //Bed Set
            updateButtonBedSet(OFF);
        else if(touched==iWinbutton15 && WINDOW==W_PRINTING_OPTION) //Resume Print
            updateResumeButton(OFF);
        else if(touched==iWinbutton16 && WINDOW==W_PRINTING_OPTION) //Pause
            updatePauseButton(OFF);
        else if(touched==iWinbutton6 && WINDOW==W_PRINTING_OPTION) //Open File
            updateOpenFileButton(OFF);
        else if(checkRegion(@ BUTTON_Z_OFFSET_TOUCH_REGION) && WINDOW==W_Z_CALIBRATION) //setOffset
             updateButtonZCal(Z_SET_OFFSET,OFF);
        else if(checkRegion(@ BUTTON_Z_PROBE_TOUCH_REGION) && WINDOW==W_Z_CALIBRATION) //Zprobe
            updateButtonZCal(Z_PROBE,OFF);
        else if(checkRegion( @ BUTTON_Z_SIGN_TOUCH_REGION) && WINDOW==W_Z_CALIBRATION) //Sign
             updateButtonZCal(Z_SIGN,OFF);
        else if(checkRegion( @ BUTTON_Z_INT_PLUS_TOUCH_REGION) && WINDOW==W_Z_CALIBRATION) //Int+
             updateButtonZCal(Z_INT_PLUS,OFF);
        else if(checkRegion( @ BUTTON_Z_INT_MINUS_TOUCH_REGION) && WINDOW==W_Z_CALIBRATION) //Int-
             updateButtonZCal(Z_INT_MINUS,OFF);
        else if(checkRegion( @ BUTTON_Z_DEC1_PLUS_TOUCH_REGION )&& WINDOW==W_Z_CALIBRATION) //Dec1+
             updateButtonZCal(Z_DEC1_PLUS,OFF);
        else if(checkRegion( @ BUTTON_Z_DEC1_MINUS_TOUCH_REGION)&& WINDOW==W_Z_CALIBRATION) //Dec1-
             updateButtonZCal(Z_DEC1_MINUS,OFF);
        else if(checkRegion( @ BUTTON_Z_DEC2_PLUS_TOUCH_REGION)&& WINDOW==W_Z_CALIBRATION) //Dec2+
             updateButtonZCal(Z_DEC2_PLUS,OFF);
        else if(checkRegion( @ BUTTON_Z_DEC2_MINUS_TOUCH_REGION)&& WINDOW==W_Z_CALIBRATION) //Dec2-
             updateButtonZCal(Z_DEC2_MINUS,OFF);
        else if(checkRegion( @ BUTTON_Z_DEC3_PLUS_TOUCH_REGION)&& WINDOW==W_Z_CALIBRATION) //Dec3+
             updateButtonZCal(Z_DEC3_PLUS,OFF);
        else if(checkRegion( @ BUTTON_Z_DEC3_MINUS_TOUCH_REGION)&& WINDOW==W_Z_CALIBRATION) //Dec3-
             updateButtonZCal(Z_DEC3_MINUS,OFF);
        endif
endfunc

func checkRegion(var p1x,var p1y ,var p2x,var p2y)
    var ret := FALSE;
    if( __X >= p1x && __X <= p2x && __Y >= p1y && __Y <= p2y)
        ret := TRUE;
    endif
    return ret;
endfunc

func z_cal_numb_limit(var type)
    var ret:=0;
    if(type>9)
        ret:=0;
    else if(type<0)
        ret:=9;
    else
        ret:=type;
    endif
    return ret;
endfunc
