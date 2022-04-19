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
   input [3:0] [WIDTH-1:0]   din; 

   input  		     pop;
   output logic [WIDTH-1:0]  dout;
   output logic 	     dout_val;     

   output 		     full;   
   
   logic [WIDTH-1:0] 	     fif_dat;
   logic [WIDTH-1:0] 	     fif_rdat;   
   logic [$clog2(DEPTH):0]   fif_cnt;
   logic [$clog2(DEPTH)-1:0] fif_rptr;
   logic [$clog2(DEPTH)-1:0] fif_wptr;      

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
   
   assign fif_rdat = rd_fmt_t'(fif_dat);

   assign dout     = fif_dat[fif_rptr];   
   assign dout_val = (fif_cnt != 0);   

   assign full = (fif_cnt == DEPTH);   
   
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
