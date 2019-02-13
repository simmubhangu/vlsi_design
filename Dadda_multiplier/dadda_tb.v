`include "dadda.v"

module dadda_tb();

    reg [7:0] a;
    reg [7:0] b;
    reg [15:0] acc;
    wire [16:0] p;

   reg	clk;
   
   integer i;

    dadda_8_bit_mul dadda_tb(
        .a(a),
        .b(b),
        .acc(acc),
        .p(p)
    );
    initial begin
       clk = 1'b0;
       forever clk = #1 ~clk;
    end	   

 always  begin
      {a,b,acc} = #1 {8'hff,8'hff,16'h0f0f};
 end
   
    initial begin
        
       $dumpfile("out.vcd");
       $dumpvars(0,a,b,acc,p);
       #1000  $display("%b*%b+%b=\n %b",a,b,acc,p);
     $finish;
   end
endmodule