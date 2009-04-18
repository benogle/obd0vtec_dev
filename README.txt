The directories contained within have all the materials you shall need to 
develop code for your OBD0 VTEC ECU.


THE DIRECTORIES

src/         - Contains actual ECU assembly code.

src/stock    - Contains disassemblies of stock PR3 and PW0 ROMS.

src/features - Contains stock ROMS with some extra feature added to the code
               such as datalogging, boost, etc. If you want to develop a new
               feature, put your code here.
               
doc/         - Contains files that will help you learn about how the processor
               works and about the code in general. See the README in doc/ for
               more info.

bin/         - Contains the assembler and disassembler.

extra/       - Contains extra things you may want to use for ECU dev such as
               textpad syntax hilighting.


STUFF YOU SHOULD KNOW ABOUT THE ECU

OBD0 VTEC ECUs use the 66301 processor. This is a very obscure 66k variant
and there is virtually no information about it. Fortunately, it is similar
to OBD1's 66201 processor which does have a decent amount of info available

