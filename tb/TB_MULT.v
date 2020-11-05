//`timescale 1ns

module tb_mult ();

   wire CLK_i;
   wire RST_n_i;
   wire [31:0] FP_Z_i;
   wire [31:0] DATA_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   data_maker DM(.CLK(CLK_i),
		 .DATA(DATA_i),
		 .RST_n(RST_n_i),
		 .END_SIM(END_SIM_i));


   FPmul_REGISTERED UUT(.clk(CLK_i),
		 .FP_Z(FP_Z_i),
		 .FP_B(DATA_i),
		 .FP_A(DATA_i),
		 .RST_n(RST_n_i));

   tb_output_data_checker DS(.CLK(CLK_i),
			     .RST_n(RST_n_i),
			     .DIN(FP_Z_i),
			     .END_SIM(END_SIM_i));   

endmodule

		   
