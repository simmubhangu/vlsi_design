iverilog -o my_design *.v

#complie the code

vvp my_design


#run the gtkwave

gtkwave out.vcd

rm -rf my_design
