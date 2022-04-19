module axil_fifo
  #(
    parameter MEM_BASE   = 32'h10000000,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   axi_awready, axi_wready, axi_bresp, axi_bvalid, fif_dat, fif_den,
   fif_val,
   // Inputs
   clk, rst_n, axi_awaddr, axi_awvalid, axi_wdata, axi_wstrb,
   axi_wvalid, axi_bready, fif_pop
   );
   
   input wire 			 clk;
   input wire 			 rst_n;

   input wire [ADDR_WIDTH-1:0] 	 axi_awaddr;
   input wire 			 axi_awvalid;
   output wire 			 axi_awready;

   input wire [DATA_WIDTH-1:0] 	 axi_wdata;
   input wire [STRB_WIDTH-1:0] 	 axi_wstrb;
   input wire 			 axi_wvalid;
   output wire 			 axi_wready;

   output wire [1:0] 		 axi_bresp;
   output wire 			 axi_bvalid;
   input wire 			 axi_bready;

   input 			 fif_pop;
   output [DATA_WIDTH-1:0] 	 fif_dat;
   output [STRB_WIDTH-1:0] 	 fif_den;   
   output 			 fif_val;   
      
   logic 			 axi_rvalid_reg;
   logic 			 rd_addr_err,wr_addr_err;   
   logic [1:0] 			 mem_rd_error,mem_rd_error_d1;
   logic [1:0] 			 mem_wr_error,mem_wr_error_d1;      

   
   assign wr_addr_err  = !(axi_awaddr == MEM_BASE);

   assign fif_psh      = axi_awvalid && axi_wvalid & !wr_addr_error & !fif_full;
   assign mem_wr_error = {(axi_awvalid & axi_wvalid & wr_addr_err),1'b0};   
   assign axi_awready  = axi_awvalid && axi_wvalid & !fif_full;
   assign axi_wready   = !fif_full;
   assign axi_bresp    = mem_wr_error_d1;
   assign axi_bvalid   = axi_bvalid_reg;
   
   always @(posedge clk) begin
      if (!rst_n) begin
	 mem_wr_error_d1 <= '0;
	 axi_bvalid_reg  <= '0;	 
      end
      else begin
         mem_wr_error_d1 <= mem_wr_error;
	 axi_bvalid_reg  <= axi_awvalid && axi_wvalid & !fif_full ? '1 : axi_bready ? '0 : axi_bvalid_reg;	 
      end
   end   


   /*
    fifo AUTO_TEMPLATE (
    .din      ({axi_awdata,axi_wstrb}),
    .psh      (fif_psh),
    .pop      (fif_pop),
    .dout     ({fif_dat,fif_den}),
    .dout_val (fif_val),
    .full     (fif_full),
    );
    */

   fifo #(.WIDTH(DATA_WIDTH+STRB_WIDTH),.DEPTH(2)) 
   u_fif (/*AUTOINST*/
	  // Outputs
	  .dout				({fif_dat,fif_den}),	 // Templated
	  .dout_val			(fif_val),		 // Templated
	  .full				(fif_full),		 // Templated
	  // Inputs
	  .clk,
	  .rst_n,
	  .psh				(fif_psh),		 // Templated
	  .din				({axi_awdata,axi_wstrb}), // Templated
	  .pop				(fif_pop));		 // Templated
   
   
   
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
