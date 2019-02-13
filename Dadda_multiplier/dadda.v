`timescale 1 ps / 1 fs

module FA(output sum, cout, input a, b, cin);
  wire w0, w1, w2;
  xor (w0, a, b);
  xor #(120) (sum, w0, cin);
  and (w1, w0, cin);
  and  (w2, a, b);
  or #(80) (cout, w1, w2);
endmodule

module HA( 
	output hs, hcout,
  input hx1, hx2 
  );  
  //wire a1;
  
 xor #(70) u1(hs,hx1,hx2);
 and #(40) u2(hcout,hx1,hx2);

endmodule

module m_2_1_2(output y, input i0, i1, s);

  wire e0, e1;
  not (sn, s);
  and  (e0, i0, sn);
  and  (e1, i1, s);
  or  #(50)(y, e0, e1);
  
endmodule

module m_2_1_4(output [3:0] y, input [3:0] i0, i1, input s);

  wire [3:0] e0, e1;
  not  (sn, s);
  
  and  (e0[0], i0[0], sn);
  and  (e0[1], i0[1], sn);
  and  (e0[2], i0[2], sn);
  and  (e0[3], i0[3], sn);
      
  and  (e1[0], i1[0], s);
  and  (e1[1], i1[1], s);
  and  (e1[2], i1[2], s);
  and  (e1[3], i1[3], s);
  
  or #(50) (y[0], e0[0], e1[0]);
  or #(50) (y[1], e0[1], e1[1]);
  or  #(50)(y[2], e0[2], e1[2]);
  or #(50) (y[3], e0[3], e1[3]);
  
endmodule

module ripple_carry(output [3:0] sum, output cout, input [3:0] a, b, input cin);
  
  wire [3:1] c;
  FA fa0(sum[0], c[1], a[0], b[0], cin);
  FA fa[2:1](sum[2:1], c[3:2], a[2:1], b[2:1], c[2:1]);
  FA fa31(sum[3], cout, a[3], b[3], c[3]);
  
endmodule

// Carry Select Adder - 16 bits
module carry_select(output [15:0] sum, output cout, input [15:0] a, b);

  wire [15:0] sum0, sum1;
  wire c1, c2, c3;

  ripple_carry rp0_0(sum0[3:0], cout0_0, a[3:0], b[3:0], 1'b0);
  ripple_carry rp0_1(sum1[3:0], cout0_1, a[3:0], b[3:0], 1);
  m_2_1_4 mux0_sum(sum[3:0], sum0[3:0], sum1[3:0], 0);
  m_2_1_2 mux0_cout(c1, cout0_0, cout0_1, 0);

  ripple_carry rp1_0(sum0[7:4], cout1_0, a[7:4], b[7:4], 0);
  ripple_carry rp1_1(sum1[7:4], cout1_1, a[7:4], b[7:4], 1);
  m_2_1_4 mux1_sum(sum[7:4], sum0[7:4], sum1[7:4], c1);
  m_2_1_2 mux1_cout(c2, cout1_0, cout1_1, c1);
  
  ripple_carry rp2_0(sum0[11:8], cout2_0, a[11:8], b[11:8], 0);
  ripple_carry rp2_1(sum1[11:8], cout2_1, a[11:8], b[11:8], 1);
  m_2_1_4 mux2_sum(sum[11:8], sum0[11:8], sum1[11:8], c2);
  m_2_1_2 mux2_cout(c3, cout2_0, cout2_1, c1);

  ripple_carry rp3_0(sum0[15:12], cout3_0, a[15:12], b[15:12], 0);
  ripple_carry rp3_1(sum1[15:12], cout3_1, a[15:12], b[15:12], 1);
  m_2_1_4 mux3_sum(sum[15:12], sum0[15:12], sum1[15:12], c3);
  m_2_1_2 mux3_cout(cout, cout3_0, cout3_1, c1);

endmodule


  module dadda_8_bit_mul 
 (
   input    [  7 : 0 ]   a            , // Operand A 
   input    [  7 : 0 ]   b            , // Operand B 
   output   [ 16 : 0 ]   p            ,  // Product 
	input   [ 15 : 0 ]   acc              // accumulator 
 ) ;

   //
   // Internal signals 
   //
   // The stage outputs are aligned
   // The first matrix coming out from the AND gates (9 rows)
   wire     [ 15 : 0 ]   row_00_st_0  ; // Row  0 of stage 0
   wire     [ 15 : 0 ]   row_01_st_0  ; // Row  1 of stage 0
   wire     [ 15 : 0 ]   row_02_st_0  ; // Row  2 of stage 0
   wire     [ 15 : 0 ]   row_03_st_0  ; // Row  3 of stage 0
   wire     [ 15 : 0 ]   row_04_st_0  ; // Row  4 of stage 0
   wire     [ 15 : 0 ]   row_05_st_0  ; // Row  5 of stage 0
   wire     [ 15 : 0 ]   row_06_st_0  ; // Row  6 of stage 0
   wire     [ 15 : 0 ]   row_07_st_0  ; // Row  7 of stage 0
	wire     [ 15 : 0 ]   row_08_st_0  ; // Row  7 of stage 0
   // Output of reduction stage 1 (6 rows) 
   wire     [ 15 : 0 ]   row_00_st_1  ; // Row  0 of stage 1
   wire     [ 15 : 0 ]   row_01_st_1  ; // Row  1 of stage 1
   wire     [ 15 : 0 ]   row_02_st_1  ; // Row  2 of stage 1
   wire     [ 15 : 0 ]   row_03_st_1  ; // Row  3 of stage 1
   wire     [ 15 : 0 ]   row_04_st_1  ; // Row  4 of stage 1
   wire     [ 15 : 0 ]   row_05_st_1  ; // Row  5 of stage 1
   // Output of reduction stage 2 (4 rows) 
   wire     [ 15 : 0 ]   row_00_st_2  ; // Row  0 of stage 2
   wire     [ 15 : 0 ]   row_01_st_2  ; // Row  1 of stage 2
   wire     [ 15 : 0 ]   row_02_st_2  ; // Row  2 of stage 2
   wire     [ 15 : 0 ]   row_03_st_2  ; // Row  3 of stage 2
   // Output of reduction stage 3 (3 rows) 
   wire     [ 15 : 0 ]   row_00_st_3  ; // Row  0 of stage 3
   wire     [ 15 : 0 ]   row_01_st_3  ; // Row  1 of stage 3
   wire     [ 15 : 0 ]   row_02_st_3  ; // Row  2 of stage 3
   // Output of reduction stage 4 (2 rows) 
   wire     [ 15 : 0 ]   row_00_st_4  ; // Row  0 of stage 4
   wire     [ 15 : 0 ]   row_01_st_4  ; // Row  1 of stage 4

   //
   // AND's
   // 
   assign row_00_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  0 ] } } )       ;  
   assign row_01_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  1 ] } } ) <<  1 ;  
   assign row_02_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  2 ] } } ) <<  2 ;  
   assign row_03_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  3 ] } } ) <<  3 ;  
   assign row_04_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  4 ] } } ) <<  4 ;  
   assign row_05_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  5 ] } } ) <<  5 ;  
   assign row_06_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  6 ] } } ) <<  6 ;  
   assign row_07_st_0 = ( { {  8 { 1'b0 } } , a } & { 16 { b [  7 ] } } ) <<  7 ;  
	assign row_08_st_0 = acc;
   //
   // Stage 1
   //
  wire [ 1 : 0 ] fa_00_st_1 ;
  wire [ 1 : 0 ] fa_01_st_1 ;
  wire [ 1 : 0 ] fa_02_st_1 ;
  wire [ 1 : 0 ] fa_03_st_1 ;
  wire [ 1 : 0 ] fa_04_st_1 ;
  wire [ 1 : 0 ] fa_05_st_1 ;
  wire [ 1 : 0 ] fa_06_st_1 ;
  wire [ 1 : 0 ] fa_07_st_1 ;
  
  wire [ 1 : 0 ] ha_00_st_1;
  wire [ 1 : 0 ] ha_01_st_1;
  wire [ 1 : 0 ] ha_02_st_1;
  wire [ 1 : 0 ] ha_03_st_1;
  
  
   FA fa0(fa_00_st_1[0], fa_00_st_1[1], row_02_st_0 [  9 ], row_03_st_0 [  9 ], row_04_st_0 [  9 ]);

   //wire [ 1 : 0 ] fa_00_st_1 = row_02_st_0 [  9 ] + row_03_st_0 [  9 ] + row_04_st_0 [  9 ] ;
   FA fa0_1 (fa_01_st_1[0],fa_01_st_1[1],row_01_st_0 [  8 ] , row_02_st_0 [  8 ] , row_03_st_0 [  8 ]) ;
	FA fa0_2 (fa_02_st_1[0],fa_02_st_1[1],row_00_st_0 [  7 ] , row_01_st_0 [  7 ] , row_02_st_0 [  7 ]) ;
	FA fa0_3 (fa_03_st_1[0],fa_03_st_1[1],row_00_st_0 [  6 ] , row_01_st_0 [  6 ] , row_02_st_0 [  6 ]) ;
	FA fa0_4 (fa_04_st_1[0],fa_04_st_1[1],row_03_st_0 [  10 ] , row_04_st_0 [  10 ] , row_05_st_0 [  10 ]) ;
	FA fa0_5 (fa_05_st_1[0],fa_05_st_1[1],row_05_st_0 [  9 ] , row_06_st_0 [  9 ] , row_07_st_0 [  9 ]) ;
	FA fa0_6 (fa_06_st_1[0],fa_06_st_1[1],row_04_st_0 [  8 ] , row_05_st_0 [  8 ] , row_06_st_0 [  8 ]) ;
	FA fa0_7 (fa_07_st_1[0],fa_07_st_1[1],row_03_st_0 [  7 ] , row_04_st_0 [  7 ] , row_05_st_0 [  7 ]) ;
	
   //wire [ 1 : 0 ] fa_02_st_1 = row_00_st_0 [  7 ] + row_01_st_0 [  7 ] + row_02_st_0 [  7 ] ;
	//wire [ 1 : 0 ] fa_03_st_1 = row_00_st_0 [  6 ] + row_01_st_0 [  6 ] + row_02_st_0 [  6 ] ;
	//wire [ 1 : 0 ] fa_04_st_1 = row_03_st_0 [  10 ] + row_04_st_0 [  10 ] + row_05_st_0 [  10 ] ;
	
	//wire [ 1 : 0 ] fa_05_st_1 = row_05_st_0 [  9 ] + row_06_st_0 [  9 ] + row_07_st_0 [  9 ] ; //9_2
	//wire [ 1 : 0 ] fa_06_st_1 = row_04_st_0 [  8 ] + row_05_st_0 [  8 ] + row_06_st_0 [  8 ] ; //8_2
	//wire [ 1 : 0 ] fa_07_st_1 = row_03_st_0 [  7 ] + row_04_st_0 [  7 ] + row_05_st_0 [  7 ] ; //7_2
	
	HA ha_00 (ha_00_st_1[0],ha_00_st_1[1],row_00_st_0 [  5 ] , row_01_st_0 [  5 ] );
	HA ha_01 (ha_01_st_1[0],ha_01_st_1[1],row_03_st_0 [  6 ] , row_04_st_0 [  6 ] );
	HA ha_02 (ha_02_st_1[0],ha_02_st_1[1],row_06_st_0 [  7 ] , row_07_st_0 [  7 ] );
	HA ha_03 (ha_03_st_1[0],ha_03_st_1[1],row_07_st_0 [  8 ] , row_08_st_0 [  8 ] );
	
   
	//wire [ 1 : 0 ] ha_00_st_1 = row_00_st_0 [  5 ] + row_01_st_0 [  5 ] ;     //half adder5                
	//wire [ 1 : 0 ] ha_01_st_1 = row_03_st_0 [  6 ] + row_04_st_0 [  6 ]  ;    //half adder6                
   //wire [ 1 : 0 ] ha_02_st_1 = row_07_st_0 [  8 ] + row_08_st_0 [  8 ]   ;   // half adder 8                
   //wire [ 1 : 0 ] ha_03_st_1 = row_06_st_0 [  7 ] + row_07_st_0 [  7 ]    ;  //-half adder 7      


   assign row_00_st_1 = { 
                          row_08_st_0 [ 15 : 11 ] , 
                          fa_04_st_1 [ 0 ] , //10
                          fa_00_st_1 [ 0 ] , //9
                          fa_01_st_1 [ 0 ] , //8
                          fa_02_st_1 [ 0 ] , //need to be added	7	
                          fa_03_st_1 [ 0 ] , //need to be added	6												
                          ha_00_st_1 [ 0 ] , //5
                          row_00_st_0 [  4 :  0 ]   
                        } ;

   assign row_01_st_1 = { 
                          row_07_st_0 [ 15 : 12 ] , 
                          fa_04_st_1 [ 1 ] , //11
                          fa_00_st_1 [ 1 ] , //10
                          fa_01_st_1 [ 1 ] , //9
                          fa_02_st_1 [ 1 ] , //8
                          fa_03_st_1 [ 1 ] , //7
                          ha_00_st_1 [ 1 ] , //5 
                          row_02_st_0 [ 5 ] , //5
                          row_01_st_0 [4 : 1] ,
                          row_08_st_0 [0] 
                        } ;


   assign row_02_st_1 = { 
                          row_06_st_0 [15 : 10] , 
                          fa_05_st_1 [0],
                          fa_06_st_1 [0],
                          fa_07_st_1 [0],
                          ha_01_st_1 [ 0 ] , 
                          row_03_st_0 [ 5 ] , 
                          row_02_st_0 [4 : 2],
                          row_08_st_0 [1],
                          row_02_st_0 [0 ]								  
                        } ;

   assign row_03_st_1 = { 
                          row_05_st_0 [15 : 11] , 
                          fa_05_st_1 [1],
                          fa_06_st_1 [1],
                          fa_07_st_1 [1],
                          ha_01_st_1 [1] , 
                          row_05_st_0 [6] , 
                          row_04_st_0 [5] , 
                          row_03_st_0 [4:3],
                          row_08_st_0 [2],
                          row_03_st_0 [1:0]								  
                        } ;

   assign row_04_st_1 = { 
                          row_02_st_0 [15:12],
                          row_07_st_0 [11], 
                          row_08_st_0 [10 ],
                          row_08_st_0 [9 ],

                          ha_03_st_1 [ 0 ],
                          ha_02_st_1 [ 0 ],
                          row_06_st_0 [6] , 
                          row_05_st_0 [5] , 
                          row_04_st_0 [4],   
                          row_08_st_0 [3],
		        						  row_04_st_0 [2:0]
                        } ;
   assign row_05_st_1 = { 
                          row_02_st_0 [15:12] , 
                          row_04_st_0 [11] , 
                          row_06_st_0 [10] , 


                          ha_03_st_1 [ 1 ],
                          ha_02_st_1 [ 1 ],
                          row_08_st_0 [7] , 
                          row_08_st_0 [6] , 
                          row_08_st_0 [5] ,
                          row_08_st_0 [4] ,								  
                          row_05_st_0 [3:0]   
                        } ;

   //
   // Stage 2
   //
	
  wire [ 1 : 0 ] fa_00_st_2 ;
  wire [ 1 : 0 ] fa_01_st_2 ;
  wire [ 1 : 0 ] fa_02_st_2 ;
  wire [ 1 : 0 ] fa_03_st_2 ;
  wire [ 1 : 0 ] fa_04_st_2 ;
  wire [ 1 : 0 ] fa_05_st_2 ;
  wire [ 1 : 0 ] fa_06_st_2 ;
  wire [ 1 : 0 ] fa_07_st_2 ;
  wire [ 1 : 0 ] fa_08_st_2 ;
  wire [ 1 : 0 ] fa_09_st_2 ;
  wire [ 1 : 0 ] fa_10_st_2 ;
  wire [ 1 : 0 ] fa_11_st_2 ;
  wire [ 1 : 0 ] fa_12_st_2 ;
  wire [ 1 : 0 ] fa_13_st_2 ;
  wire [ 1 : 0 ] fa_14_st_2 ;
  wire [ 1 : 0 ] fa_15_st_2 ;

  wire [ 1 : 0 ] ha_00_st_2;
  wire [ 1 : 0 ] ha_01_st_2;
	
	
	FA fa0_0_s2(fa_00_st_2[0], fa_00_st_2[1], row_00_st_1 [  4 ], row_01_st_1 [  4 ], row_02_st_1 [  4 ]);
	FA fa0_1_s2(fa_01_st_2[0], fa_01_st_2[1], row_00_st_1 [  5 ], row_01_st_1 [  5 ], row_02_st_1 [  5 ]);
	FA fa0_2_s2(fa_02_st_2[0], fa_02_st_2[1], row_00_st_1 [  6 ], row_01_st_1 [  6 ], row_02_st_1 [  6 ]);
	FA fa0_3_s2(fa_03_st_2[0], fa_03_st_2[1], row_00_st_1 [  7 ], row_01_st_1 [  7 ], row_02_st_1 [  7 ]);
	FA fa0_4_s2(fa_04_st_2[0], fa_04_st_2[1], row_00_st_1 [  8 ], row_01_st_1 [  8 ], row_02_st_1 [  8 ]);
	FA fa0_5_s2(fa_05_st_2[0], fa_05_st_2[1], row_00_st_1 [  9 ], row_01_st_1 [  9 ], row_02_st_1 [  9 ]);
	FA fa0_6_s2(fa_06_st_2[0], fa_06_st_2[1], row_00_st_1 [  10 ], row_01_st_1 [  10 ], row_02_st_1 [  10 ]);
	FA fa0_7_s2(fa_07_st_2[0], fa_07_st_2[1], row_00_st_1 [  11 ], row_01_st_1 [  11 ], row_02_st_1 [  11 ]);
	FA fa0_8_s2(fa_08_st_2[0], fa_08_st_2[1], row_00_st_1 [  12 ], row_01_st_1 [  12 ], row_02_st_1 [  12 ]);
	
	FA fa0_9_s2(fa_09_st_2[0], fa_09_st_2[1], row_03_st_1 [  5 ], row_04_st_1 [  5 ], row_05_st_1 [  5 ]);
	FA fa0_10_s2(fa_10_st_2[0], fa_10_st_2[1], row_03_st_1 [  6 ], row_04_st_1 [  6 ], row_05_st_1 [  6 ]);
	FA fa0_11_s2(fa_11_st_2[0], fa_11_st_2[1], row_03_st_1 [  7 ], row_04_st_1 [  7 ], row_05_st_1 [  7 ]);
	FA fa0_12_s2(fa_12_st_2[0], fa_12_st_2[1], row_03_st_1 [  8 ], row_04_st_1 [  8 ], row_05_st_1 [  8 ]);
	FA fa0_13_s2(fa_13_st_2[0], fa_13_st_2[1], row_03_st_1 [  9 ], row_04_st_1 [  9 ], row_05_st_1 [  9 ]);
	FA fa0_14_s2(fa_14_st_2[0], fa_14_st_2[1], row_03_st_1 [  10 ], row_04_st_1 [  10 ], row_05_st_1 [  10 ]);
	FA fa0_15_s2(fa_15_st_2[0], fa_15_st_2[1], row_03_st_1 [  11 ], row_04_st_1 [  11 ], row_05_st_1 [  11 ]);
	
	HA ha_00_s2 (ha_00_st_2[0],ha_00_st_2[1],row_00_st_1 [  3 ] , row_01_st_1 [  3 ] );
	HA ha_01_s2 (ha_01_st_2[0],ha_01_st_2[1],row_03_st_1 [  4 ] , row_04_st_1 [  4 ] );
		

	
   assign row_00_st_2 = { 
                          row_00_st_1 [ 15 : 13 ] , 
                          fa_08_st_2 [ 0 ] , 
                          fa_07_st_2 [ 0 ] , 
                          fa_06_st_2 [ 0 ] , 
                          fa_05_st_2 [ 0 ] , 
                          fa_04_st_2 [ 0 ] , 
                          fa_03_st_2 [ 0 ] , 
                          fa_02_st_2 [ 0 ] , 
                          fa_01_st_2 [ 0 ] , 
                          fa_00_st_2 [ 0 ] , 
                          ha_00_st_2 [ 0 ] , 
                          row_00_st_1 [  2 :  0 ]   
                        } ;

   assign row_01_st_2 = { 
                          row_01_st_1 [ 15 : 14 ] , 
                          fa_08_st_2 [ 1 ] , 
                          fa_07_st_2 [ 1 ] , 
                          fa_06_st_2 [ 1 ] , 
                          fa_05_st_2 [ 1 ] , 
                          fa_04_st_2 [ 1 ] , 
                          fa_03_st_2 [ 1 ] , 
                          fa_02_st_2 [ 1 ] , 
                          fa_01_st_2 [ 1 ] , 
                          fa_00_st_2 [ 1 ] , 
                          ha_00_st_2 [ 1 ] ,
                          row_02_st_1 [  3      ] , 
                          row_01_st_1 [  2 :  0 ]   
                        } ;

   assign row_02_st_2 = { 
                          row_02_st_1 [ 15 : 13 ] , 
                          row_03_st_1 [ 12      ] , 
                          fa_15_st_2 [ 0 ] , 
                          fa_14_st_2 [ 0 ] , 
                          fa_13_st_2 [ 0 ] , 
                          fa_12_st_2 [ 0 ] , 
                          fa_11_st_2 [ 0 ] , 
                          fa_10_st_2 [ 0 ] , 
                          fa_09_st_2 [ 0 ] , 
                          ha_01_st_2 [ 0 ] , 
                          row_03_st_1 [  3      ] , 
                          row_02_st_1 [  2 :  0 ]   
                        } ;

   assign row_03_st_2 = { 
                          row_04_st_1 [ 15 : 14 ] ,
                          row_02_st_1 [ 13 ],	
                          fa_15_st_2 [ 1 ] , 
                          fa_14_st_2 [ 1 ] , 
                          fa_13_st_2 [ 1 ] , 
                          fa_12_st_2 [ 1 ] , 
                          fa_11_st_2 [ 1 ] , 
                          fa_10_st_2 [ 1 ] , 
                          fa_09_st_2 [ 1 ] , 
                          ha_01_st_2 [ 1 ] , 
                          row_05_st_1 [  4      ] , 
                          row_04_st_1 [  3      ] , 
                          row_03_st_1 [  2 :  0 ]   
                        } ;

   //
   // Stage 3
   //
	
  wire [ 1 : 0 ] fa_00_st_3 ;
  wire [ 1 : 0 ] fa_01_st_3 ;
  wire [ 1 : 0 ] fa_02_st_3 ;
  wire [ 1 : 0 ] fa_03_st_3 ;
  wire [ 1 : 0 ] fa_04_st_3 ;
  wire [ 1 : 0 ] fa_05_st_3 ;
  wire [ 1 : 0 ] fa_06_st_3 ;
  wire [ 1 : 0 ] fa_07_st_3 ;
  wire [ 1 : 0 ] fa_08_st_3 ;
  wire [ 1 : 0 ] fa_09_st_3 ;
  wire [ 1 : 0 ] fa_10_st_3 ;
  
  wire [ 1 : 0 ] ha_00_st_3 ;
 
	
  FA fa0_0_s3(fa_00_st_3[0], fa_00_st_3[1], row_00_st_2 [  3 ], row_01_st_2 [  3 ], row_02_st_2 [  3 ]);
  FA fa0_1_s3(fa_01_st_3[0], fa_01_st_3[1], row_00_st_2 [  4 ], row_01_st_2 [  4 ], row_02_st_2 [  4 ]);
  FA fa0_2_s3(fa_02_st_3[0], fa_02_st_3[1], row_00_st_2 [  5 ], row_01_st_2 [  5 ], row_02_st_2 [  5 ]);
  FA fa0_3_s3(fa_03_st_3[0], fa_03_st_3[1], row_00_st_2 [  6 ], row_01_st_2 [  6 ], row_02_st_2 [  6 ]);
  FA fa0_4_s3(fa_04_st_3[0], fa_04_st_3[1], row_00_st_2 [  7 ], row_01_st_2 [  7 ], row_02_st_2 [  7 ]);
  FA fa0_5_s3(fa_05_st_3[0], fa_05_st_3[1], row_00_st_2 [  8 ], row_01_st_2 [  8 ], row_02_st_2 [  8 ]);
  FA fa0_6_s3(fa_06_st_3[0], fa_06_st_3[1], row_00_st_2 [  9 ], row_01_st_2 [  9 ], row_02_st_2 [  9 ]);
  FA fa0_7_s3(fa_07_st_3[0], fa_07_st_3[1], row_00_st_2 [  10 ], row_01_st_2 [  10 ], row_02_st_2 [  10 ]);
  FA fa0_8_s3(fa_08_st_3[0], fa_08_st_3[1], row_00_st_2 [  11 ], row_01_st_2 [  11 ], row_02_st_2 [  11 ]);
  FA fa0_9_s3(fa_09_st_3[0], fa_09_st_3[1], row_00_st_2 [  12 ], row_01_st_2 [  12 ], row_02_st_2 [  12 ]);
  FA fa0_10_s3(fa_10_st_3[0], fa_10_st_3[1], row_00_st_2 [  13], row_01_st_2 [  13 ], row_02_st_2 [  13 ]);
  
  HA ha_00_s3 (ha_00_st_3[0],ha_00_st_3[1],row_00_st_1 [  2 ] , row_01_st_1 [  2 ] );


   assign row_00_st_3 = { 
                          row_00_st_2 [ 15 : 14 ] ,
                          fa_10_st_3 [ 0 ] , 
                          fa_09_st_3 [ 0 ] ,	
                          fa_08_st_3 [ 0 ] , 
                          fa_07_st_3 [ 0 ] , 
                          fa_06_st_3 [ 0 ] , 
                          fa_05_st_3 [ 0 ] , 
                          fa_04_st_3 [ 0 ] , 
                          fa_03_st_3 [ 0 ] , 
                          fa_02_st_3 [ 0 ] , 
                          fa_01_st_3 [ 0 ] , 
                          fa_00_st_3 [ 0 ] , 
                          ha_00_st_3 [ 0 ] , 
                          row_00_st_2 [  1 :  0 ]   
                        } ;

   assign row_01_st_3 = { 
                          row_01_st_2 [ 15 ] , 
                          fa_10_st_3 [ 1 ] , 
                          fa_09_st_3 [ 1 ] ,	
                          fa_08_st_3 [ 1 ] , 
                          fa_07_st_3 [ 1 ] , 
                          fa_06_st_3 [ 1 ] , 
                          fa_05_st_3 [ 1 ] , 
                          fa_04_st_3 [ 1 ] , 
                          fa_03_st_3 [ 1 ] , 
                          fa_02_st_3 [ 1 ] , 
                          fa_01_st_3 [ 1 ] , 
                          fa_00_st_3 [ 1 ] , 
                          ha_00_st_3 [ 1 ] , 
                          row_02_st_2 [  2      ] , 
                          row_01_st_2 [  1 :  0 ]   
                        } ;

   assign row_02_st_3 = { 
                          row_01_st_2 [ 15:  14    ] ,  
                          row_03_st_2 [ 13 :  2 ] , 
                          row_02_st_2 [  1 :  0 ]   
                        } ;

   //
   // Stage 4
   //
	
  wire [ 1 : 0 ] fa_00_st_4 ;
  wire [ 1 : 0 ] fa_01_st_4 ;
  wire [ 1 : 0 ] fa_02_st_4 ;
  wire [ 1 : 0 ] fa_03_st_4 ;
  wire [ 1 : 0 ] fa_04_st_4 ;
  wire [ 1 : 0 ] fa_05_st_4 ;
  wire [ 1 : 0 ] fa_06_st_4 ;
  wire [ 1 : 0 ] fa_07_st_4 ;
  wire [ 1 : 0 ] fa_08_st_4 ;
  wire [ 1 : 0 ] fa_09_st_4 ;
  wire [ 1 : 0 ] fa_10_st_4 ;
  wire [ 1 : 0 ] fa_11_st_4 ;
  wire [ 1 : 0 ] fa_12_st_4 ;
  
  wire [ 1 : 0 ] ha_00_st_4 ;
	
	
FA fa0_0_s4(fa_00_st_4[0], fa_00_st_4[1], row_00_st_3 [  2 ], row_01_st_3 [  2 ], row_02_st_3 [  2 ]);
FA fa0_1_s4(fa_01_st_4[0], fa_01_st_4[1], row_00_st_3 [  3 ], row_01_st_3 [  3 ], row_02_st_3 [  3 ]);  
FA fa0_2_s4(fa_02_st_4[0], fa_02_st_4[1], row_00_st_3 [  4 ], row_01_st_3 [  4 ], row_02_st_3 [  4 ]);  
FA fa0_3_s4(fa_03_st_4[0], fa_03_st_4[1], row_00_st_3 [  5 ], row_01_st_3 [  5 ], row_02_st_3 [  5 ]);  
FA fa0_4_s4(fa_04_st_4[0], fa_04_st_4[1], row_00_st_3 [  6 ], row_01_st_3 [  6 ], row_02_st_3 [  6 ]);  
FA fa0_5_s4(fa_05_st_4[0], fa_05_st_4[1], row_00_st_3 [  7 ], row_01_st_3 [  7 ], row_02_st_3 [  7 ]);  
FA fa0_6_s4(fa_06_st_4[0], fa_06_st_4[1], row_00_st_3 [  8 ], row_01_st_3 [  8 ], row_02_st_3 [  8 ]);  
FA fa0_7_s4(fa_07_st_4[0], fa_07_st_4[1], row_00_st_3 [  9 ], row_01_st_3 [  9 ], row_02_st_3 [  9 ]);  
FA fa0_8_s4(fa_08_st_4[0], fa_08_st_4[1], row_00_st_3 [  10 ], row_01_st_3 [  10 ], row_02_st_3 [  10 ]);  
FA fa0_9_s4(fa_09_st_4[0], fa_09_st_4[1], row_00_st_3 [  11 ], row_01_st_3 [  11 ], row_02_st_3 [  11 ]);  
FA fa0_10_s4(fa_10_st_4[0], fa_10_st_4[1], row_00_st_3 [  12 ], row_01_st_3 [  12 ], row_02_st_3 [  12 ]);  
FA fa0_11_s4(fa_11_st_4[0], fa_11_st_4[1], row_00_st_3 [  13 ], row_01_st_3 [  13 ], row_02_st_3 [  13 ]);  
FA fa0_12_s4(fa_12_st_4[0], fa_12_st_4[1], row_00_st_3 [  14 ], row_01_st_3 [  14 ], row_02_st_3 [  14 ]); 

HA ha_00_s4 (ha_00_st_4[0],ha_00_st_4[1],row_00_st_1 [  1 ] , row_01_st_1 [  1 ] );

   assign row_00_st_4 = { 
                          row_00_st_3 [ 15      ] ,
                          fa_12_st_4 [ 0 ] ,
                          fa_11_st_4 [ 0 ] , 
                          fa_10_st_4 [ 0 ] , 
                          fa_09_st_4 [ 0 ] , 
                          fa_08_st_4 [ 0 ] , 
                          fa_07_st_4 [ 0 ] , 
                          fa_06_st_4 [ 0 ] , 
                          fa_05_st_4 [ 0 ] , 
                          fa_04_st_4 [ 0 ] , 
                          fa_03_st_4 [ 0 ] , 
                          fa_02_st_4 [ 0 ] , 
                          fa_01_st_4 [ 0 ] , 
                          fa_00_st_4 [ 0 ] ,
                          ha_00_st_4 [ 0 ] , 
                          row_00_st_3 [ 0 ]   
                        } ;

   assign row_01_st_4 = {                           
                          fa_12_st_4 [ 1 ] ,
                          fa_11_st_4 [ 1 ] , 
                          fa_10_st_4 [ 1 ] , 
                          fa_09_st_4 [ 1 ] , 
                          fa_08_st_4 [ 1 ] , 
                          fa_07_st_4 [ 1 ] , 
                          fa_06_st_4 [ 1 ] , 
                          fa_05_st_4 [ 1 ] , 
                          fa_04_st_4 [ 1 ] , 
                          fa_03_st_4 [ 1 ] , 
                          fa_02_st_4 [ 1 ] , 
                          fa_01_st_4 [ 1 ] ,
                          fa_00_st_4 [ 1 ] ,											
                          ha_00_st_4 [ 1 ] , 
                          row_02_st_3 [  1      ] , 
                          row_01_st_3 [ 0 ]   
                        } ;

   //
   // final sum
   //

carry_select adder (p[15:0],p[16],row_00_st_4 , row_01_st_4 );	
   
endmodule 

