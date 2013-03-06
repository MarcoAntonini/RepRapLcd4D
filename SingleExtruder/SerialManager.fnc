/*
 this file is part of ReprapLcd4D Project

 Original File: Marco Antonini
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

var cmd_buff[BUFF_LEN];
var buff_index :=0;
var __COMBUFF[COMBUFF_LEN];


//Function
func SerialInit()
     com_Init(__COMBUFF, COMBUFF_LEN, 0 );
     com_SetBaud(COM0, 11520);
endfunc

func SerialEvent()
     var char;
     char:=serin();
     if(char >= 0 )  // is valid char
        cmd_buff[buff_index]:=char;
        if(cmd_buff[buff_index] == '\n')
            cmd_buff[buff_index]:='\0';
            if(WINDOW!=W_SDCARD || SD_READING==FALSE)
                parseCmd(cmd_buff,buff_index);
            else if(WINDOW==W_SDCARD)
                parseSDFile(cmd_buff,buff_index);
            endif
            buff_index:=0;
        else
            buff_index++;
        endif
        if(buff_index >= BUFF_LEN)
            buff_index:=BUFF_LEN-1;
        endif
     endif
endfunc

func parseCmd(var *buffer,var n)
     var i;
     var cmd_id[3],cmd_val[BUFF_LEN],index_val;
     var parsing_val:=FALSE;
     var cmd_val_buff[BUFF_LEN];
     var p_cmd_val;
     for( i:=0; i<n; i++)
        if(parsing_val==TRUE) //Cmd Val
            cmd_val[i-index_val-1]:=buffer[i];
        else if(buffer[i]==':')
            parsing_val:=TRUE;
            index_val:=i;
        else if(i<3) //Cmd Id
            cmd_id[i]:=buffer[i];
        endif
     next

    buff2str(cmd_val,n-index_val-1,cmd_val_buff);
    p_cmd_val := str_Ptr(cmd_val_buff);

    if( cmd_id[0] == MESSAGE_ID )
        updateMessage(p_cmd_val," "," ");
        to(msg); printBuffer(p_cmd_val);
    else if( cmd_id[0] == HOTEND_ID )

            if(WINDOW!=W_SDCARD && WINDOW !=W_PRINT_CONFIRM) updateHotEnd0(p_cmd_val);
            to(tH0); printBuffer(p_cmd_val);
      
    else if( cmd_id[0] == TARGETT_ID )
        if(cmd_id[1]=='0')
            if(WINDOW!=W_SDCARD && WINDOW !=W_PRINT_CONFIRM)
                updateTHotEnd0(p_cmd_val);
                updateHotEnd0(str_Ptr(tH0));
            endif
            to(ttH0); printBuffer(p_cmd_val);

        else if(cmd_id[1]=='B')
            if(WINDOW!=W_SDCARD && WINDOW!=W_PRINTING_OPTION && WINDOW !=W_PRINT_CONFIRM)
                updateTBed(p_cmd_val);
                updateBed(str_Ptr(tB));
            endif
            to(ttB); printBuffer(p_cmd_val);
        endif
    else if( cmd_id[0] == BED_ID )
         if(WINDOW!=W_SDCARD && WINDOW!=W_PRINTING_OPTION && WINDOW !=W_PRINT_CONFIRM)
            updateBed(p_cmd_val);
         endif
         to(tB); printBuffer(p_cmd_val);
    else if( cmd_id[0] == TIME_ID )
         updateTime(p_cmd_val);
         to(timePrint); printBuffer(p_cmd_val);
    else if( cmd_id[0] == ZPOS_ID )
         updateZpos(p_cmd_val);
         to(zPos); printBuffer(p_cmd_val);
    else if( cmd_id[0] == SDPERCENT_ID )
         updateSDPerc(p_cmd_val);
         to(sdPerc); printBuffer(p_cmd_val);
    else if( cmd_id[0] == SOUND_ID )
         sound(FINISH);
    else if(cmd_id[0] == DEBUG_SHOW_MEM_ID)
         to(COM0); print("Memory available = ",mem_Heap(),"\n");
    endif

endfunc

//SD_MAX_FILE
func parseSDFile(var *buffer,var n)
    var p,i;
    var val[BUFF_LEN];

    buff2str(buffer,n,val);
    p:=str_Ptr(val);

    if(file_count>MAX_FILE)
        file_count:=MAX_FILE;
        return;
    endif
    if(str_Match(&p,"Begin file list") && FILE_START==FALSE) //FILESTART: avoid it a double malloc
        FILE_START:=TRUE;
        file_count:=0;
        sd_current_page:=0;
        filenames := mem_AllocZ(MAX_FILE*(MAX_FILE_NAME+2));
        p_filenames := str_Ptr(filenames);
        // allocate a buffer for the filenames
        if(!filenames)
            updateMessage("LCD ERRORR: Out of memory !\n"," "," ");
            //Reset...
         endif
    else if(str_Match(&p,"End file list"))
        //for(i:=0; i<file_count; i++)   //for DEBUG
        //   to(COM0); str_Printf(&files[i],"%s\n"); //for DEBUG
        //next //for DEBUG
        //SerialPrintNumber(file_count); //for DEBUG
        SD_READING:=FALSE;
        if(file_count>0)
            sd_page_count:=file_count/24;
            updateButtonFileList();
        endif

    else if(FILE_START) //FILESTART semaphore
         if(str_Find(&p,".G") || str_Find(&p,".g")) //if is GCODE file
            files[file_count]:=p_filenames;
            file_count++;
            for(i:=0; i<n; i++)
                str_PutByte(p_filenames,tolower(buffer[i]));
                p_filenames++;
            next
            str_PutByte(p_filenames,'\0');
            p_filenames++;
        endif
    endif


endfunc

func SerialPrintBuffer(var *buffer)
    to(COM0); str_Printf(&buffer, "%s");
endfunc

func SerialPrintlnBuffer(var *buffer)
    to(COM0); str_Printf(&buffer, "%s\n");
endfunc

func SerialPrintNumber(var numb)
    to(COM0); putnum(DEC,numb);
endfunc

func SerialPrintlnNumber(var numb)
    to(COM0); putnum(DEC,numb);
    to(COM0); print("\n");
endfunc

func printBuffer(var *buffer)
    str_Printf (&buffer, "%s");
endfunc

func buff2str(var *buffer,var buffer_count,var *buff_out)
        var i:=0;
        for(i:=0; i<buffer_count; i++)
            if(i==0) to(buff_out);
            if(i>0) to(APPEND);
            print([CHR]buffer[i]);
        next
endfunc

func SerialErrorWatchDog()
     if(com_Error()) // if there were low level comms errors,
        //SystemReset();
        SerialInit();
    endif
endfunc
