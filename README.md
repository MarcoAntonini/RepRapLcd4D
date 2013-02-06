# RepRap LCD 4D Firmware

**This project is designed to work on board a Touch TFT LCD model uLCD-32PTU**

Wiki: (http://www.marcoantonini.eu/doku.php?id=reprap:lcd4d)

Another LCD for Marlin firmware? 
Yes - the code here is designed to enable connection of the 4D-Systems uLCD-32PTU LCD board to a MELZI or Sanguinololu board using TX1 and RX1 - found on the expansion pins.

The target printer for the code here is any single extruder RepRap machine although it depends on appropriate MARLIN firmware. (Marco has developed MARLIN code for the RepRapPro machine which works well with their Huxley machine).

This LCD works in standalone mode, it has an internal PICASO microcontroller. 
The entire Graphics interface is not managed by Marlin Firmware but the PICASO micro. 
The PICASO firmware sends commands through the GCODE protocol to RepRap main board. 
The communication is done by a second serial port.

This should be considered as a beta version but has been tested on the 4D Workshop IDE with an uLCD-32PTU. It works well.

Note that if using a 19V power supply and are powering the LCD from the MELZI/Sanguinololu 7805 voltage regulator, you will need some form of heatsink. I am currently looking into powering the LCD using a switching voltage regulator powered from the controller board terminals marked 12V.  


**Features:**
  * Work in standalone mode, no PC is required
  * Intuitive Touch Interface, no external button is required
  * Graphical interface "Pronterface" style
  * Show SD card file content, print the selected file,Pause/Resume.
  * Move X,Y,Z axis with a touch
  * Show Temperature and Target Temp of the bed and extruder
  * Extrude/Reverse Filament functionality (Settings mm and mm/min)
  * Set HotEnd Temp and Target Temp
  * Set Bed Temp and Target Temp
  * Zprobe and Z offset functionality
  * Wav Sound to notify the end of print
  * Only two pins are needed for communication (TX1,RX1) ,perfect for Melzi/Sanguino board
  * Works with Marco Antonini's Marlin branch of the RRP firmware
  
**What you need to start?**

  * a 4D-Systems Display uLCD-32PTU
  * a microSD card for display formatted with FAT16 (256Mb is fine)
  * a FTDI usb to serial converter (or equivalent)
  * a 4D Workshop3 IDE Tool
  
**Upload the Firmware**

  * Download and install the 4D Workshop IDE Tool.
  * Connect your LCD using the FTDI cable to the PC.
  * Clone RepRapLCD4D Project
  * Copy the entire contents of the directory CopyToSD in the microSD. 
    This is a precompiled image control database, if there are no changes to the graphical interface you can use these precompiled files.
  * Plug the microSD in the Display.
  * Open the 4D Workshop software and set the Displat Serial port.
  * In the workshop open the file Main.4dg located in the root directory of my project, press the Compile & Download button. (Make sure that you have the target as 'FLASH' in the Project tab.

**At the end of the upload the mini pronterface graphical interface appears in the display. 
The display is ready to work!**

if the Graphical interface does not appear correctly, the problem can be caused by microSD. 
Try to reformat or use the 4D-Systems Removable Media Partition Edit Tool

**Dev note**

Changes to be made:

** move Gfx Interface function in the micro sd to free up space on the Picaso flash.
** Add Print-STOP and sd card eject buttons (in menu SD-card)
