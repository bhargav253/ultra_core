module axil_wr_ext
  #(
    parameter MEM_BASE   = 32'h10000000,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   axi_awready, axi_wready, axi_bresp, axi_bvalid, ext_wr_dat,
   ext_wen, ext_wr_req,
   // Inputs
   clk, rst_n, axi_awaddr, axi_awvalid, axi_wdata, axi_wstrb,
   axi_wvalid, axi_bready, ext_rsp_val
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

   input 			 ext_rsp_val;
   output logic [DATA_WIDTH-1:0] ext_wr_dat;
   output logic [STRB_WIDTH-1:0] ext_wen;   
   output 			 ext_wr_req;   
   
   logic 			 rd_addr_err,wr_addr_err;   
   logic [1:0] 			 mem_rd_error,mem_rd_error_d1;
   logic [1:0] 			 mem_wr_error,mem_wr_error_d1;      
   logic 			 fif_full,fif_psh;   
   logic 			 wr_resp_full,wr_resp_pend;   
   
   assign wr_addr_err  = !(axi_awaddr == MEM_BASE);

   assign fif_psh      = axi_awvalid && axi_wvalid & !wr_addr_err & !fif_full & !wr_resp_full;
   assign mem_wr_error = {(axi_awvalid & axi_wvalid & wr_addr_err),1'b0};   
   assign axi_awready  = axi_awvalid && axi_wvalid & !fif_full & !wr_resp_full;
   assign axi_wready   = axi_awvalid && axi_wvalid & !fif_full & !wr_resp_full;
   assign axi_bresp    = mem_wr_error_d1;
   assign axi_bvalid   = wr_resp_pend;

   assign wr_resp_full = wr_resp_pend & !axi_bready;   

   always @(posedge clk) begin
      if (!rst_n) begin
	 wr_resp_pend    <= '0;	 
	 mem_wr_error_d1 <= '0;
      end
      else begin
	 wr_resp_pend    <= axi_awvalid && axi_wvalid & !wr_resp_full & !fif_full ? '1 :           axi_bready ? '0 : wr_resp_pend;
         mem_wr_error_d1 <= axi_awvalid && axi_wvalid & !wr_resp_full & !fif_full ? mem_wr_error : axi_bready ? '0 : mem_wr_error_d1;
      end
   end   
     
   /*
    fifo AUTO_TEMPLATE (
    .din      ({axi_wdata,axi_wstrb}),
    .psh      (fif_psh),
    .pop      (ext_rsp_val),
    .dout     ({ext_wr_dat,ext_wen}),
    .dout_val (ext_wr_req),
    .full     (fif_full),
    );
    */

   fifo #(.WIDTH(DATA_WIDTH+STRB_WIDTH),.DEPTH(1)) 
   u_fif (/*AUTOINST*/
	  // Outputs
	  .dout				({ext_wr_dat,ext_wen}),	 // Templated
	  .dout_val			(ext_wr_req),		 // Templated
	  .full				(fif_full),		 // Templated
	  // Inputs
	  .clk,
	  .rst_n,
	  .psh				(fif_psh),		 // Templated
	  .din				({axi_wdata,axi_wstrb}), // Templated
	  .pop				(ext_rsp_val));		 // Templated
   
   
   
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
