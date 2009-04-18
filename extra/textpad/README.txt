This will tell you how to add asm synatx hilighting to textpad, and how to add
the assembler and disassembler to textpad as tools.


HILIGHTING

Place asm.syn in your Program Files/Textpad5/system folder. Follow TextPad's 
instructions to add a new document class 
(http://www.textpad.com/add-ons/syna2g.html#instructions)


ASSEMBLER TOOL

This will assemble the currently-being-edited asm file and put 
the bin in the <root>/bin/ecubin folder assuming you are editing from the 
<root>/src/features dir. If there are assembler errors, it'll let you jump to 
the error line based on the asm.exe's output (thats what the regex is for).

Goto TextPad's Configure->Preferences... menu. Find and click 'Tools' in the 
left pane. Click the 'Add...' button in the right pane, choose 'Program' then 
find the asm.exe file. Click 'Apply'. Now expand the 'Tools' item in the left 
pane. Click 'Asm'. Now enter the following into the fields:

Command:   C:\path\to\asm.exe
Parameters:    $File bin\$BaseName.bin
Initial folder: $FileDir

regex: ^\([A-Za-z]+:[A-Za-z0-9 \\]+.asm\)\( line \)\([0-9]+\):

file: 1, line: 3, column: BLANK


DISASSEMBLER TOOL

Open a bin, then run this tool and it will create a '<yourBinName>DASM.asm' 
file into the same dir.

Goto TextPad's Configure->Preferences... menu. Find and click 'Tools' in the 
left pane. Click the 'Add...' button in the right pane, choose 'Program' then 
find the dasm.exe file. Click 'Apply'. Now expand the 'Tools' item in the left 
pane. Click 'Dasm'. Now enter the following into the fields:

Command:   C:\path\to\dasm.exe
Parameters:    $File $(BaseName)DASM.asm 0 0
Initial folder: $FileDir