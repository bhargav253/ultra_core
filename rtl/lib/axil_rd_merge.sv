/*
 Simple read merge to ROM
 Expect data to come in 1 cycle always, so no extra buffering
 */
module axil_rd_merge
  #(
    parameter NUM_SRCS   = 2,
    parameter DATA_WIDTH = 32,    
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   src_axi_arready, src_axi_rdata, src_axi_rresp, src_axi_rvalid,
   dst_axi_arvalid, dst_axi_araddr, dst_axi_rready,
   // Inputs
   clk, rst_n, src_axi_araddr, src_axi_arvalid, src_axi_rready,
   dst_axi_arready, dst_axi_rvalid, dst_axi_rdata, dst_axi_rresp
   );
   
   input wire 			 clk;
   input wire 			 rst_n;

   input [NUM_SRCS-1:0] [ADDR_WIDTH-1:0] src_axi_araddr;
   input [NUM_SRCS-1:0] 		 src_axi_arvalid;
   output logic [NUM_SRCS-1:0] 		 src_axi_arready;
   
   output logic [NUM_SRCS-1:0][DATA_WIDTH-1:0] src_axi_rdata;
   output logic [NUM_SRCS-1:0] [1:0] 	       src_axi_rresp;
   output logic [NUM_SRCS-1:0] 		       src_axi_rvalid;
   input [NUM_SRCS-1:0] 		       src_axi_rready;
   
   output logic 			       dst_axi_arvalid;
   output logic [31:0] 			       dst_axi_araddr;
   input 				       dst_axi_arready;   
   
   input 				       dst_axi_rvalid;
   input [31:0] 			       dst_axi_rdata;
   input [1:0] 				       dst_axi_rresp; 
   output logic 			       dst_axi_rready;  
   
   localparam SRC_W = $clog2(NUM_SRCS);   
   
   logic [SRC_W-1:0] 			       mrg_gnt_idx;
   logic [NUM_SRCS-1:0] 		       mrg_gnt,mrg_gnt_d1;   
   
   always_comb begin
      mrg_gnt_idx     = '0;            
      for(int i=0; i<NUM_SRCS; i++)
	if(src_axi_arvalid[i]) 
	  mrg_gnt_idx = i[SRC_W-1:0];
   end
   
   assign mrg_gnt = 1 << mrg_gnt_idx;
   
   always_comb begin
      dst_axi_arvalid = '0;
      dst_axi_araddr  = src_axi_araddr;	       

      src_axi_arready = '0;      
      
      for(int i=0; i<NUM_SRCS; i++)
	if(mrg_gnt[i]) begin	 
	   dst_axi_arvalid    = src_axi_arvalid[i];
	   dst_axi_araddr     = src_axi_araddr[i];
	   src_axi_arready[i] = dst_axi_arready;	   
	end      
   end
   
   always @(posedge clk) begin
      if (!rst_n) mrg_gnt_d1 <= '0;
      else        mrg_gnt_d1 <= mrg_gnt;
   end      
   
   always_comb begin
      dst_axi_rready = '0;            
      for(int i=0;i<NUM_SRCS;i++) begin
	 src_axi_rdata[i]  = dst_axi_rdata;
	 src_axi_rresp[i]  = '0;
	 src_axi_rvalid[i] = '0;	 	 
	 if(mrg_gnt_d1[i]) begin
	    src_axi_rresp[i]  = dst_axi_rresp;
	    src_axi_rvalid[i] = dst_axi_rvalid;
	    src_axi_rdata[i]  = dst_axi_rdata;	 
	    dst_axi_rready    = dst_axi_rready | src_axi_rready[i];	 
	 end
      end
   end
      
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
