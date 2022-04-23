module fifo
  #(parameter WIDTH=4,
    parameter DEPTH=2)
   (/*AUTOARG*/
   // Outputs
   dout, dout_val, full,
   // Inputs
   clk, rst_n, psh, din, pop
   );
   
   input wire 		     clk;
   input wire 		     rst_n;

   input 		     psh;
   input [WIDTH-1:0] 	     din; 

   input  		     pop;
   output logic [WIDTH-1:0]  dout;
   output logic 	     dout_val;     

   output logic 	     full;   
   
   logic [DEPTH-1:0] [WIDTH-1:0] fif_dat;

   generate
      if(DEPTH == 1) begin : dep_eq_1

	 always @(posedge clk)
	   if(!rst_n)   fif_dat <= '0;   
	   else if(psh) fif_dat <= din;   	 

	 
	 always @(posedge clk)
	   if(!rst_n)   full <= '0;   
	   else if(psh) full <= '1;
	   else if(pop) full <= '0;      
	 
	 assign dout     = fif_dat;   
	 assign dout_val = full;   

      end
      else begin : dep_gt_1
	 
	 logic [$clog2(DEPTH):0] 	 fif_cnt;
	 logic [$clog2(DEPTH)-1:0] 	 fif_rptr;
	 logic [$clog2(DEPTH)-1:0] 	 fif_wptr;      
	 	 
	 always @(posedge clk)
	   if(!rst_n)   fif_rptr <= '0;   
	   else if(pop) fif_rptr <= (fif_rptr == DEPTH-1) ? '0 : fif_rptr + 1;

	 always @(posedge clk)
	   if(!rst_n)   fif_wptr <= '0;   
	   else if(psh) fif_wptr <= (fif_wptr == DEPTH-1) ? '0 : fif_wptr + 1;
	 
	 always @(posedge clk)
	   if(!rst_n)   fif_dat <= '0;   
	   else if(psh) fif_dat[fif_wptr] <= din;   

	 always @(posedge clk)
	   if(!rst_n)         fif_cnt <= '0;   
	   else if(psh & pop) fif_cnt <= fif_cnt;
	   else if(psh)       fif_cnt <= fif_cnt + 1;
	   else if(pop)       fif_cnt <= fif_cnt - 1;      

	 assign dout     = fif_dat[fif_rptr];   
	 assign dout_val = (fif_cnt != 0);   

	 assign full = (fif_cnt == DEPTH);   
	 
      end
   endgenerate
   
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
