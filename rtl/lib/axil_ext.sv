module axil_ext
  #(
    parameter MEM_BASE   = 32'h10000000,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   axi_awready, axi_wready, axi_bresp, axi_bvalid, axi_arready,
   axi_rdata, axi_rresp, axi_rvalid, ext_rd_req, ext_wr_req,
   ext_wr_dat, ext_wen,
   // Inputs
   clk, rst_n, axi_awaddr, axi_awvalid, axi_wdata, axi_wstrb,
   axi_wvalid, axi_bready, axi_araddr, axi_arvalid, axi_rready,
   ext_rrsp_dat, ext_rrsp_val, ext_wrsp_val
   );
   
   input 			 clk;
   input 			 rst_n;

   input [ADDR_WIDTH-1:0] 	 axi_awaddr;
   input 			 axi_awvalid;
   output logic 		 axi_awready;

   input [DATA_WIDTH-1:0] 	 axi_wdata;
   input [STRB_WIDTH-1:0] 	 axi_wstrb;
   input 			 axi_wvalid;
   output logic 		 axi_wready;

   output logic [1:0] 		 axi_bresp;
   output logic 		 axi_bvalid;
   input 			 axi_bready;

   input [ADDR_WIDTH-1:0] 	 axi_araddr;
   input 			 axi_arvalid;
   output logic 		 axi_arready;

   output logic [DATA_WIDTH-1:0] axi_rdata;
   output logic [1:0] 		 axi_rresp;
   output logic			 axi_rvalid;
   input 			 axi_rready;

   output 			 ext_rd_req;   
   output 			 ext_wr_req;
   output logic [DATA_WIDTH-1:0] ext_wr_dat;
   output logic [STRB_WIDTH-1:0] ext_wen;   

   input [DATA_WIDTH-1:0] 	 ext_rrsp_dat;
   input 			 ext_rrsp_val;   
   input 			 ext_wrsp_val;   
   
     
   /*
    axil_wr_ext AUTO_TEMPLATE (
    .ext_rsp_val (ext_wrsp_val),
    );
    */

   axil_wr_ext #(.MEM_BASE(MEM_BASE),.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))
   u_wr_ext (/*AUTOINST*/
	     // Outputs
	     .axi_awready,
	     .axi_wready,
	     .axi_bresp			(axi_bresp[1:0]),
	     .axi_bvalid,
	     .ext_wr_dat		(ext_wr_dat[DATA_WIDTH-1:0]),
	     .ext_wen			(ext_wen[STRB_WIDTH-1:0]),
	     .ext_wr_req,
	     // Inputs
	     .clk,
	     .rst_n,
	     .axi_awaddr		(axi_awaddr[ADDR_WIDTH-1:0]),
	     .axi_awvalid,
	     .axi_wdata			(axi_wdata[DATA_WIDTH-1:0]),
	     .axi_wstrb			(axi_wstrb[STRB_WIDTH-1:0]),
	     .axi_wvalid,
	     .axi_bready,
	     .ext_rsp_val		(ext_wrsp_val));		 // Templated


   /*
    axil_rd_ext AUTO_TEMPLATE (
    .ext_rsp_val (ext_rrsp_val),
    .ext_rsp_dat (ext_rrsp_dat),
    );
    */

   axil_rd_ext #(.MEM_BASE(MEM_BASE),.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))
   u_rd_ext (/*AUTOINST*/
	     // Outputs
	     .axi_arready,
	     .axi_rdata			(axi_rdata[DATA_WIDTH-1:0]),
	     .axi_rresp			(axi_rresp[1:0]),
	     .axi_rvalid,
	     .ext_rd_req,
	     // Inputs
	     .clk,
	     .rst_n,
	     .axi_araddr		(axi_araddr[ADDR_WIDTH-1:0]),
	     .axi_arvalid,
	     .axi_rready,
	     .ext_rsp_dat		(ext_rrsp_dat),		 // Templated
	     .ext_rsp_val		(ext_rrsp_val));		 // Templated
   
   
   
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
