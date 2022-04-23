/*mem adapter*/
module axil_adaptor 
  #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    parameter TAG_WIDTH = 32)
   (/*AUTOARG*/
   // Outputs
   axi_awaddr, axi_awvalid, axi_wvalid, axi_wdata, axi_wstrb,
   axi_bready, axi_araddr, axi_arvalid, axi_rready, intf_accept,
   intf_val, intf_error, intf_rdata, intf_resp_tag,
   // Inputs
   clk, rst_n, axi_awready, axi_wready, axi_bvalid, axi_bresp,
   axi_arready, axi_rvalid, axi_rdata, axi_rresp, intf_addr,
   intf_wdata, intf_ren, intf_wen, intf_req_tag
   );
   
   input 	      clk;
   input 	      rst_n;
   
   // AXI4-lite master memory interface

   output logic [ADDR_WIDTH-1:0] axi_awaddr;
   output logic 		 axi_awvalid;
   input 			 axi_awready;
   
   output logic 		 axi_wvalid;
   input 			 axi_wready;
   output logic [DATA_WIDTH-1:0] axi_wdata;
   output logic [STRB_WIDTH-1:0] axi_wstrb;
   
   input 			 axi_bvalid;
   input [1:0] 			 axi_bresp;   
   output logic 		 axi_bready;
   
   output logic [ADDR_WIDTH-1:0] axi_araddr;
   output logic 		 axi_arvalid;
   input 			 axi_arready;
   
   input 			 axi_rvalid;
   input [DATA_WIDTH-1:0] 	 axi_rdata;
   input [1:0] 			 axi_rresp;   
   output logic 		 axi_rready;
   

   input [ADDR_WIDTH-1:0] 	 intf_addr;
   input [DATA_WIDTH-1:0] 	 intf_wdata;
   input 			 intf_ren;
   input [STRB_WIDTH-1:0] 	 intf_wen;
   input [TAG_WIDTH-1:0] 	 intf_req_tag;   
   output logic 		 intf_accept;   
   output logic 		 intf_val;  
   output logic 		 intf_error;
   output logic [DATA_WIDTH-1:0] intf_rdata;
   output logic [TAG_WIDTH-1:0]  intf_resp_tag;   

   localparam XCTN_RD = 1'b0;
   localparam XCTN_WR = 1'b1;

   typedef struct 		 packed{
      logic [ADDR_WIDTH-1:0] 	 addr;
      logic [DATA_WIDTH-1:0] 	 wdata;
      logic 			 ren;
      logic [STRB_WIDTH-1:0] 	 wen;
      logic [TAG_WIDTH-1:0] 	 req_tag;
   } req_t;
   
   logic 			 skid_ren;
   logic [STRB_WIDTH-1:0] 	 skid_wen;   
   req_t                         skid_req,skid_fif;   
   logic 			 skid_psh,skid_pop,skid_fif_val;   
   logic 			 nxt_intf_accept;   
   logic 			 resp_xctn,req_xctn,req_psh;
   logic 			 rsp_fif_full,rsp_fif_val;   
   logic [TAG_WIDTH-1:0] 	 resp_tag,req_tag;
   
   
   assign axi_awvalid = skid_fif_val ? |skid_fif.wen : |intf_wen;
   assign axi_awaddr  = skid_fif_val ? skid_fif.addr : intf_addr;

   assign axi_wvalid  = skid_fif_val ? |skid_fif.wen  : |intf_wen;
   assign axi_wdata   = skid_fif_val ? skid_fif.wdata : intf_wdata;
   assign axi_wstrb   = skid_fif_val ? skid_fif.wen   : intf_wen;

   assign axi_arvalid = skid_fif_val ? skid_fif.ren  : intf_ren;
   assign axi_araddr  = skid_fif_val ? skid_fif.addr : intf_addr;      

   always @(posedge clk)
     if (!rst_n) intf_accept <= '1;
     else        intf_accept <= nxt_intf_accept;
   
   always_comb begin
      nxt_intf_accept = '1;      
      skid_psh        = '0;
      skid_req        = '0;
      skid_pop        = '0;      
      
      req_psh         = '0;      
      req_xctn        = '0;
      req_tag         = intf_req_tag;      
      
      if(skid_ren) begin
	 nxt_intf_accept = axi_arready & !rsp_fif_full;
	 skid_pop        = nxt_intf_accept;
	 if(nxt_intf_accept) begin
	    req_psh  = '1;	    
	    req_xctn = XCTN_RD;
	    req_tag  = skid_fif.req_tag;	    
	 end	 	 	 
      end
      else if(|skid_wen) begin
	 nxt_intf_accept = axi_awready & axi_wready & !rsp_fif_full;
	 skid_pop        = nxt_intf_accept;
	 if(nxt_intf_accept) begin
	    req_psh  = '1;	    
	    req_xctn = XCTN_WR;
	    req_tag  = skid_fif.req_tag;
	 end	 	 	 	 
      end
      else if(intf_ren) begin
	 nxt_intf_accept = axi_arready & !rsp_fif_full;
	 skid_psh        = !nxt_intf_accept;
	 skid_req        = '{ addr    : intf_addr,
			      wdata   : intf_wdata,
			      req_tag : intf_req_tag,
			      wen     : intf_wen,
			      ren     : intf_ren };	 
	 if(nxt_intf_accept) begin
	    req_psh  = '1;
	    req_xctn = XCTN_RD;
	    req_tag  = intf_req_tag;	    
	 end	 
      end
      else if(|intf_wen) begin
	 nxt_intf_accept = axi_awready & axi_wready & !rsp_fif_full;
	 skid_psh        = !nxt_intf_accept;
	 skid_req        = '{ addr    : intf_addr,
			      wdata   : intf_wdata,
			      req_tag : intf_req_tag,
			      wen     : intf_wen,
			      ren     : intf_ren };
	 if(nxt_intf_accept) begin
	    req_psh  = '1;
	    req_xctn = XCTN_WR;
	    req_tag  = intf_req_tag;	    
	 end	 	 
      end
   end


   always @(posedge clk)
     if (!rst_n)       skid_fif <= '0;
     else if(skid_psh) skid_fif <= skid_req;

   always @(posedge clk)
     if (!rst_n)       skid_fif_val <= '0;
     else if(skid_psh) skid_fif_val <= '1;
     else if(skid_pop) skid_fif_val <= '0;

   assign skid_ren = skid_fif_val ? skid_fif.ren : '0;
   assign skid_wen = skid_fif_val ? skid_fif.wen : '0;      
   
   always_comb begin
      intf_val      = '0;      
      intf_error    = '0;      
      intf_rdata    = axi_rdata;
      intf_resp_tag = '0;      
      
      if((resp_xctn == XCTN_WR) & rsp_fif_val) begin
	 intf_val      = axi_bvalid;
	 intf_error    = axi_bresp[1];
	 intf_resp_tag = resp_tag;	 
      end
      else if((resp_xctn == XCTN_RD) & rsp_fif_val) begin
	 intf_val      = axi_rvalid;
	 intf_error    = axi_rresp[1];
	 intf_resp_tag = resp_tag;	 	 
      end
   end

   assign axi_bready  = '1;   
   assign axi_rready  = '1;   
   
   /*
    fifo AUTO_TEMPLATE (
    .din      ({req_xctn,req_tag}),
    .psh      (req_psh),
    .pop      (intf_val),
    .dout     ({resp_xctn,resp_tag}),
    .dout_val (rsp_fif_val),
    .full     (rsp_fif_full),
    );
    */

   fifo #(.WIDTH(TAG_WIDTH+1),.DEPTH(2)) 
   u_rsp_fif (/*AUTOINST*/
	      // Outputs
	      .dout			({resp_xctn,resp_tag}),	 // Templated
	      .dout_val			(rsp_fif_val),		 // Templated
	      .full			(rsp_fif_full),		 // Templated
	      // Inputs
	      .clk,
	      .rst_n,
	      .psh			(req_psh),		 // Templated
	      .din			({req_xctn,req_tag}),	 // Templated
	      .pop			(intf_val));		 // Templated
   

endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
