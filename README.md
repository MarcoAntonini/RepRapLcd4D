# RepRap LCD 4D Firmware

**This project is designed to work on board a Touch TFT LCD model uLCD-32PT**

Wiki: (http://www.marcoantonini.eu/doku.php?id=reprap:lcd4d)

Another LCD for Marlin firmware? 
Yes, my Melzi board is equipped with a atmega1284P, the only free pins (with 2 extruders) are TX1 and RX1.
This is perfect for a serial LCD like 4D-Systems uLCD-32PT.

This LCD works in standalone mode, it has an internal PICASO microcontroller. 
The entire Graphics interface is not managed by Marlin Firmware but the PICASO micro. 
My PICASO firmware send commands through the GCODE protocol to RepRap main board. 
The communication is done by a second serial port.

This be considered a beta version, I tested on the 4D Workshop IDE with a uLCD-32PT and works well.


**Features:**
  * Work in standalone mode, no PC is required
  * Intuitive Touch Interface, no external button is required
  * Graphical interface "Pronterface" style
  * Show SD card file content, print the selected file,Pause/Resume.
  * Move X,Y,Z axis with a touch
  * Show Temperature and Target Temp up to two Extruder
  * Extrude/Reverse Filament functionality (Settings mm and mm/min)
  * Set HotEnd Temp and Target Temp
  * Set Bed Temp and Target Temp
  * Zprobe and Z offset functionality
  * Wav Sound to notify the end of print
  * Only two pin for communication (TX1,RX1) ,perfect for Melzi/Sanguino board
  * Working with my Marlin branch
  
**What you need to start?**

  * a 4D-Systems Display uLCD-32PT
  * a microSD card for display formatted with FAT16 (256Mb is fine)
  * a FTDI usb to serial converter (or equivalent)
  * a 4D Workshop3 IDE Tool
  
 **Upload the Firmware**

  * Download and install the 4D Workshop3 IDE Tool.
  * Connect your LCD using the FTDI cable to the PC.
  * Clone RepRapLCD4D Project
  * Copy the entire contents of the directory CopyToSD in the microSD. 
    This is a precompiled image control database, if there are no changes to the graphical interface you can use these precompiled files.
  * Plug the microSD in the Display.
  * Open the 4D Workshop software and set the Displat Serial port.
  * In the workshop open the file Main.4dg located in the root directory of my project, press the Compile & Download button.

**At the end of the upload the mini pronterface graphical interface appears in the display. 
The display is ready to work!**

if the Graphical interface does not appear correctly, the problem can be caused by microSD. 
Try to reformat or use the 4D-Systems Removable Media Partition Edit Tool

**Dev note**
Changes to be made:

1) In the new IDE 4 button "switch Extruder" does not appear correctly
2) move Gfx Interface function in the micro sd to free up space on the Picaso flash.
3) Add Print-STOP and sd card eject buttons (in menu SD-card)
4) Add Fan menu (ON,OFF,speed)
5) Add Enable/Disable motor buttons
