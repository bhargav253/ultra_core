/*
 AXI split, to split Data access from core to RAM / and other IOs
 With a 2 deep FIFO, to allow 1 outstanding response
 */
module axil_split
  #(
    parameter NUM_WR_DSTS = 2,
    parameter NUM_RD_DSTS = 2,    
    parameter DATA_WIDTH  = 32,    
    parameter ADDR_WIDTH  = 32,
    parameter STRB_WIDTH  = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   src_axi_awready, src_axi_wready, src_axi_bresp, src_axi_bvalid,
   src_axi_arready, src_axi_rdata, src_axi_rresp, src_axi_rvalid,
   dst_axi_awaddr, dst_axi_awvalid, dst_axi_wdata, dst_axi_wstrb,
   dst_axi_wvalid, dst_axi_bready, dst_axi_araddr, dst_axi_arvalid,
   dst_axi_rready,
   // Inputs
   clk, rst_n, wr_decode, rd_decode, src_axi_awaddr, src_axi_awvalid,
   src_axi_wdata, src_axi_wstrb, src_axi_wvalid, src_axi_bready,
   src_axi_araddr, src_axi_arvalid, src_axi_rready, dst_axi_awready,
   dst_axi_wready, dst_axi_bresp, dst_axi_bvalid, dst_axi_arready,
   dst_axi_rdata, dst_axi_rresp, dst_axi_rvalid
   );
   
   input 			 clk;
   input 			 rst_n;

   input [NUM_WR_DSTS:0] 	 wr_decode;
   input [NUM_RD_DSTS:0] 	 rd_decode;      
   
   input [ADDR_WIDTH-1:0] 	 src_axi_awaddr;
   input 			 src_axi_awvalid;
   output logic 		 src_axi_awready;

   input [DATA_WIDTH-1:0] 	 src_axi_wdata;
   input [STRB_WIDTH-1:0] 	 src_axi_wstrb;
   input 			 src_axi_wvalid;
   output logic 		 src_axi_wready;

   output logic [1:0] 		 src_axi_bresp;
   output logic 		 src_axi_bvalid;
   input 			 src_axi_bready;

   input [ADDR_WIDTH-1:0] 	 src_axi_araddr;
   input 			 src_axi_arvalid;
   output logic 		 src_axi_arready;

   output logic [DATA_WIDTH-1:0] src_axi_rdata;
   output logic [1:0] 		 src_axi_rresp;
   output logic 		 src_axi_rvalid;
   input 			 src_axi_rready;

   output logic [NUM_WR_DSTS-1:0] [ADDR_WIDTH-1:0] dst_axi_awaddr;
   output logic [NUM_WR_DSTS-1:0] 		   dst_axi_awvalid;
   input [NUM_WR_DSTS-1:0] 			   dst_axi_awready;

   output logic [NUM_WR_DSTS-1:0] [DATA_WIDTH-1:0] dst_axi_wdata;
   output logic [NUM_WR_DSTS-1:0] [STRB_WIDTH-1:0] dst_axi_wstrb;
   output logic [NUM_WR_DSTS-1:0] 		   dst_axi_wvalid;
   input [NUM_WR_DSTS-1:0] 			   dst_axi_wready;

   input [NUM_WR_DSTS-1:0] [1:0] 		   dst_axi_bresp;
   input [NUM_WR_DSTS-1:0] 			   dst_axi_bvalid;
   output logic [NUM_WR_DSTS-1:0] 		   dst_axi_bready;

   output logic [NUM_RD_DSTS-1:0] [ADDR_WIDTH-1:0] dst_axi_araddr;
   output logic [NUM_RD_DSTS-1:0] 		   dst_axi_arvalid;
   input [NUM_RD_DSTS-1:0] 			   dst_axi_arready;

   input [NUM_RD_DSTS-1:0] [DATA_WIDTH-1:0] 	   dst_axi_rdata;
   input [NUM_RD_DSTS-1:0] [1:0] 		   dst_axi_rresp;
   input [NUM_RD_DSTS-1:0] 			   dst_axi_rvalid;
   output logic [NUM_RD_DSTS-1:0] 		   dst_axi_rready;
   
   logic [NUM_WR_DSTS:0] 			   fif_wr_dat;
   logic [NUM_RD_DSTS:0] 			   fif_rd_dat;   
   logic [NUM_WR_DSTS:0] 			   wr_accept,brsp_accept;
   logic [NUM_RD_DSTS:0] 			   rd_accept,rrsp_accept;   
   logic 					   fif_wr_full,fif_rd_full,fif_wr_psh,fif_wr_pop;
   logic 					   fif_rd_psh,fif_rd_pop;   
   logic 					   fif_wr_val,fif_rd_val;   
   
   always_comb begin
      src_axi_awready    = '0;	 
      src_axi_wready     = '0;	 
      dst_axi_awaddr     = '0;
      dst_axi_awvalid    = '0;
      dst_axi_wvalid     = '0;
      dst_axi_wdata      = '0;
      dst_axi_wstrb      = '0;
      wr_accept          = '0;	 
      

      if(wr_decode[NUM_WR_DSTS]) begin
	 src_axi_awready        = '1;	 
	 src_axi_wready         = '1;
	 wr_accept[NUM_WR_DSTS] = src_axi_awvalid & src_axi_wvalid;	 
      end
      else begin
	 for(int i=0; i<NUM_WR_DSTS; i++) begin
	    if(wr_decode[i] & !fif_wr_full) begin
	       src_axi_awready    = dst_axi_awready[i];	 
	       src_axi_wready     = dst_axi_wready[i];	    
	       dst_axi_awvalid[i] = src_axi_awvalid;
	       dst_axi_awaddr[i]  = src_axi_awaddr;
	       dst_axi_wvalid[i]  = src_axi_wvalid;
	       dst_axi_wdata[i]   = src_axi_wdata;
	       dst_axi_wstrb[i]   = src_axi_wstrb;	    	       
	       wr_accept[i]       = dst_axi_awvalid[i] & dst_axi_wvalid[i] & dst_axi_awready[i] & dst_axi_wready[i];	    
	    end
	 end
      end
   end

   always_comb begin
      src_axi_bvalid = '0;
      src_axi_bresp  = '0;	 
      dst_axi_bready = '0;	 
      brsp_accept    = '0;      
      
      if(fif_wr_val & fif_wr_dat[NUM_WR_DSTS]) begin
	 src_axi_bvalid           = '1;
	 src_axi_bresp            = 2'b10;
	 brsp_accept[NUM_WR_DSTS] = src_axi_bready;
      end
      else begin	       
	 for(int i=0; i<NUM_WR_DSTS; i++) begin	 
	    if(fif_wr_val & fif_wr_dat[i]) begin
	       src_axi_bvalid    = dst_axi_bvalid[i];
	       src_axi_bresp     = dst_axi_bresp[i];
	       dst_axi_bready[i] = src_axi_bready;	 
	       brsp_accept[i]    = dst_axi_bvalid[i] & dst_axi_bready[i];
	    end	 
	 end
      end
   end

   assign fif_wr_psh = |wr_accept;   
   assign fif_wr_pop = |brsp_accept;   

   /*
    fifo AUTO_TEMPLATE (
    .din      (wr_decode),
    .psh      (fif_wr_psh),
    .pop      (fif_wr_pop),
    .dout     (fif_wr_dat),
    .dout_val (fif_wr_val),
    .full     (fif_wr_full),
    );
    */

   fifo #(.WIDTH(NUM_WR_DSTS+1),.DEPTH(2)) 
   u_wr_fif (/*AUTOINST*/
	     // Outputs
	     .dout			(fif_wr_dat),		 // Templated
	     .dout_val			(fif_wr_val),		 // Templated
	     .full			(fif_wr_full),		 // Templated
	     // Inputs
	     .clk,
	     .rst_n,
	     .psh			(fif_wr_psh),		 // Templated
	     .din			(wr_decode),		 // Templated
	     .pop			(fif_wr_pop));		 // Templated


   always_comb begin
      src_axi_arready = '0;	 
      dst_axi_araddr  = '0;
      dst_axi_arvalid = '0;
      rd_accept       = '0;	 

      if(rd_decode[NUM_RD_DSTS]) begin
	 src_axi_arready        = '1;	 
	 rd_accept[NUM_RD_DSTS] = src_axi_arvalid;	 
      end
      else begin
	 for(int i=0; i<NUM_RD_DSTS; i++) begin	    
	    if(rd_decode[i] & !fif_rd_full) begin
	       src_axi_arready    = dst_axi_arready[i];	 
	       dst_axi_arvalid[i] = src_axi_arvalid;
	       dst_axi_araddr[i]  = src_axi_awaddr;	       
	       rd_accept[i]       = dst_axi_arvalid[i] & dst_axi_arready[i];
	    end
	 end
      end
   end
   
   always_comb begin
      src_axi_rvalid = '0;
      src_axi_rdata  = dst_axi_rdata[0];
      src_axi_rresp  = '0;	 	 
      dst_axi_rready = '0;	 
      rrsp_accept    = '0;      

      if(fif_rd_val & fif_rd_dat[NUM_RD_DSTS]) begin
	 src_axi_rvalid           = '1;
	 src_axi_rdata            = '0;
	 src_axi_rresp            = 2'b10;
	 rrsp_accept[NUM_RD_DSTS] = src_axi_rready;
      end
      else begin      	 
	 for(int i=0; i<NUM_RD_DSTS; i++) begin	 	    	 
	    if(fif_rd_val & fif_rd_dat[i]) begin
	       src_axi_rvalid    = dst_axi_rvalid[i];
	       src_axi_rdata     = dst_axi_rdata[i];
	       src_axi_rresp     = dst_axi_rresp[i];
	       dst_axi_rready[i] = src_axi_rready;	 
	       rrsp_accept[i]    = dst_axi_rvalid[i] & dst_axi_rready[i];
	    end	 
	 end
      end
   end
   
   assign fif_rd_psh = |rd_accept;   
   assign fif_rd_pop = |rrsp_accept;   

   /*
    fifo AUTO_TEMPLATE (
    .din      (rd_decode),
    .psh      (fif_rd_psh),
    .pop      (fif_rd_pop),
    .dout     (fif_rd_dat),
    .dout_val (fif_rd_val),
    .full     (fif_rd_full),
    );
    */

   fifo #(.WIDTH(NUM_RD_DSTS+1),.DEPTH(2)) 
   u_rd_fif (/*AUTOINST*/
	     // Outputs
	     .dout			(fif_rd_dat),		 // Templated
	     .dout_val			(fif_rd_val),		 // Templated
	     .full			(fif_rd_full),		 // Templated
	     // Inputs
	     .clk,
	     .rst_n,
	     .psh			(fif_rd_psh),		 // Templated
	     .din			(rd_decode),		 // Templated
	     .pop			(fif_rd_pop));		 // Templated
   
   
   
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
