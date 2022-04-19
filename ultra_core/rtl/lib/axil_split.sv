module axil_split
  #(
    parameter NUM_DSTS   = 3,
    parameter DATA_WIDTH = 32,    
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   src_axi_awready, src_axi_wready, src_axi_bresp, src_axi_bvalid,
   src_axi_arready, src_axi_rdata, src_axi_rresp, src_axi_rvalid,
   dst_axi_awaddr, dst_axi_awvalid, dst_axi_wdata, dst_axi_wstrb,
   dst_axi_wvalid, dst_axi_bready, dst_axi_araddr, dst_axi_arvalid,
   dst_axi_rready,
   // Inputs
   clk, rst_n, decode, src_axi_awaddr, src_axi_awvalid, src_axi_wdata,
   src_axi_wstrb, src_axi_wvalid, src_axi_bready, src_axi_araddr,
   src_axi_arvalid, src_axi_rready, dst_axi_awready, dst_axi_wready,
   dst_axi_bresp, dst_axi_bvalid, dst_axi_arready, dst_axi_rdata,
   dst_axi_rresp, dst_axi_rvalid
   );
   
   input wire 			 clk;
   input wire 			 rst_n;

   input [NUM_DSTS-1:0] 	 decode;   
   
   input wire [ADDR_WIDTH-1:0] 	 src_axi_awaddr;
   input wire 			 src_axi_awvalid;
   output wire 			 src_axi_awready;

   input wire [DATA_WIDTH-1:0] 	 src_axi_wdata;
   input wire [STRB_WIDTH-1:0] 	 src_axi_wstrb;
   input wire 			 src_axi_wvalid;
   output wire 			 src_axi_wready;

   output wire [1:0] 		 src_axi_bresp;
   output wire 			 src_axi_bvalid;
   input wire 			 src_axi_bready;

   input wire [ADDR_WIDTH-1:0] 	 src_axi_araddr;
   input wire 			 src_axi_arvalid;
   output wire 			 src_axi_arready;

   output wire [DATA_WIDTH-1:0]  src_axi_rdata;
   output wire [1:0] 		 src_axi_rresp;
   output wire 			 src_axi_rvalid;
   input wire 			 src_axi_rready;

   output wire [NUM_DSTS-1:0] [ADDR_WIDTH-1:0] dst_axi_awaddr;
   output wire [NUM_DSTS-1:0] 		       dst_axi_awvalid;
   input wire [NUM_DSTS-1:0] 		       dst_axi_awready;

   output wire [NUM_DSTS-1:0] [DATA_WIDTH-1:0] dst_axi_wdata;
   output wire [NUM_DSTS-1:0] [STRB_WIDTH-1:0] dst_axi_wstrb;
   output wire [NUM_DSTS-1:0] 		       dst_axi_wvalid;
   input wire [NUM_DSTS-1:0] 		       dst_axi_wready;

   input wire [NUM_DSTS-1:0] [1:0] 	       dst_axi_bresp;
   input wire [NUM_DSTS-1:0] 		       dst_axi_bvalid;
   output wire [NUM_DSTS-1:0] 		       dst_axi_bready;

   output wire [NUM_DSTS-1:0] [ADDR_WIDTH-1:0] dst_axi_araddr;
   output wire [NUM_DSTS-1:0] 		       dst_axi_arvalid;
   input wire [NUM_DSTS-1:0] 		       dst_axi_arready;

   input wire [NUM_DSTS-1:0] [DATA_WIDTH-1:0]  dst_axi_rdata;
   input wire [NUM_DSTS-1:0] [1:0] 	       dst_axi_rresp;
   input wire [NUM_DSTS-1:0] 		       dst_axi_rvalid;
   output wire [NUM_DSTS-1:0] 		       dst_axi_rready;
   
   logic [NUM_DSTS-1:0] 		       decode,fif_wr_dat,fif_rd_dat;
   logic [NUM_DSTS-1:0] 		       wr_accept,rd_accept,brsp_accept,rrsp_accept;
   logic 				       fif_wr_full,fif_rd_full,fif_wr_psh,fif_wr_pop;
   logic 				       fif_rd_psh,fif_rd_pop;   
   
   
   always_comb begin
      for(int i=0; i<NUM_SRC; i++) begin
	 src_axi_awready    = '0;	 
	 src_axi_wready     = '0;	 
	 dst_axi_awaddr[i]  = src_axi_awaddr;
	 dst_axi_awvalid[i] = '0;
	 dst_axi_wdata      = src_axi_wdata;
	 dst_axi_wstrb      = src_axi_wstrb;
	 dst_axi_wvalid     = '0;
	 wr_accept[i]       = '0;	 
	 
	 if(decode[i] & !fif_wr_full) begin
	    src_axi_awready    = dst_axi_awready[i];	 
	    src_axi_wready     = dst_axi_wready[i];	    
	    dst_axi_awvalid[i] = src_axi_awvalid;
	    dst_axi_wvalid[i]  = src_axi_wvalid;	    
	    wr_accept[i]       = dst_axi_awvalid[i] & dst_axi_wvalid[i] & dst_axi_awready[i] & dst_axi_wready[i];	    
	 end
      end
   end

   always_comb begin
      for(int i=0; i<NUM_SRC; i++) begin	 
	 src_axi_bvalid = '0;
	 src_axi_bresp  = '0;	 
	 dst_axi_bready[i] = '0;	 
	 brsp_accept[i]    = '0;
	 
	 if(fif_wr_val & fif_wr_dat[i]) begin
	    src_axi_bvalid    = dst_axi_bvalid[i];
	    src_axi_bresp     = dst_axi_bresp[i];
	    dst_axi_bready[i] = src_axi_bready;	 
	    brsp_accept[i]    = dst_axi_bvalid[i] & dst_axi_bready[i];
	 end	 
      end
   end

   assign fif_wr_psh = |wr_accept;   
   assign fif_wr_pop = |brsp_accept;   

   /*
    fifo AUTO_TEMPLATE (
    .din      (decode),
    .psh      (fif_wr_psh),
    .pop      (fif_wr_pop),
    .dout     (fif_wr_dat),
    .dout_val (fif_wr_val),
    .full     (fif_wr_full),
    );
    */

   fifo #(.WIDTH(NUM_DSTS),.DEPTH(2)) 
   u_wr_fif (/*AUTOINST*/
	     // Outputs
	     .dout			(fif_wr_dat),		 // Templated
	     .dout_val			(fif_wr_val),		 // Templated
	     .full			(fif_wr_full),		 // Templated
	     // Inputs
	     .clk,
	     .rst_n,
	     .psh			(fif_wr_psh),		 // Templated
	     .din			(decode),		 // Templated
	     .pop			(fif_wr_pop));		 // Templated


   always_comb begin
      for(int i=0; i<NUM_SRC; i++) begin
	 src_axi_arready    = '0;	 
	 dst_axi_araddr[i]  = src_axi_awaddr;
	 dst_axi_arvalid[i] = '0;
	 rd_accept[i]       = '0;	 
	 
	 if(decode[i] & !fif_rd_full) begin
	    src_axi_arready    = dst_axi_arready[i];	 
	    dst_axi_arvalid[i] = src_axi_arvalid;
	    rd_accept[i]       = dst_axi_arvalid[i] & dst_axi_arready[i];
	 end
      end
   end

   always_comb begin
      for(int i=0; i<NUM_SRC; i++) begin	 
	 src_axi_rvalid    = '0;
	 src_axi_rdata     = dst_axi_rdata[0];
	 src_axi_rresp     = '0;	 	 
	 dst_axi_rready[i] = '0;	 
	 rrsp_accept[i]    = '0;
	 
	 if(fif_rd_val & fif_rd_dat[i]) begin
	    src_axi_rvalid    = dst_axi_rvalid[i];
	    src_axi_rdata     = dst_axi_rdata[i];
	    src_axi_rresp     = dst_axi_rresp[i];
	    dst_axi_rready[i] = src_axi_rready;	 
	    rrsp_accept[i]    = dst_axi_rvalid[i] & dst_axi_rready[i];
	 end	 
      end
   end

   assign fif_rd_psh = |rd_accept;   
   assign fif_rd_pop = |rrsp_accept;   

   /*
    fifo AUTO_TEMPLATE (
    .din      (decode),
    .psh      (fif_rd_psh),
    .pop      (fif_rd_pop),
    .dout     (fif_rd_dat),
    .dout_val (fif_rd_val),
    .full     (fif_rd_full),
    );
    */

   fifo #(.WIDTH(NUM_DSTS),.DEPTH(2)) 
   u_rd_fif (/*AUTOINST*/
	     // Outputs
	     .dout			(fif_rd_dat),		 // Templated
	     .dout_val			(fif_rd_val),		 // Templated
	     .full			(fif_rd_full),		 // Templated
	     // Inputs
	     .clk,
	     .rst_n,
	     .psh			(fif_rd_psh),		 // Templated
	     .din			(decode),		 // Templated
	     .pop			(fif_rd_pop));		 // Templated
   
   
      
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
