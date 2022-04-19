module axil_dp_ram
  #(
    parameter MEM_START  = 32'h00000400,
    parameter MEM_STOP   = 32'h00001000,    
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   axi_awready, axi_wready, axi_bresp, axi_bvalid, axi_arready,
   axi_rdata, axi_rresp, axi_rvalid, mem_wen, mem_wdata, mem_waddr,
   mem_ren, mem_raddr,
   // Inputs
   clk, rst_n, axi_awaddr, axi_awvalid, axi_wdata, axi_wstrb,
   axi_wvalid, axi_bready, axi_araddr, axi_arvalid, axi_rready,
   mem_rdata
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

   input wire [ADDR_WIDTH-1:0] 	 axi_araddr;
   input wire 			 axi_arvalid;
   output wire 			 axi_arready;

   output wire [DATA_WIDTH-1:0]  axi_rdata;
   output wire [1:0] 		 axi_rresp;
   output wire 			 axi_rvalid;
   input wire 			 axi_rready;
   
   output [STRB_WIDTH-1:0] 	 mem_wen;
   output [DATA_WIDTH-1:0] 	 mem_wdata;   
   output [ADDR_WIDTH-1:0] 	 mem_waddr;      
   
   output 			 mem_ren;   
   output [ADDR_WIDTH-1:0] 	 mem_raddr;   
   input [DATA_WIDTH-1:0] 	 mem_rdata;   
      
   logic 			 axi_rvalid_reg;
   logic 			 rd_addr_err,wr_addr_err;   
   logic [1:0] 			 mem_rd_error,mem_rd_error_d1;
   logic [1:0] 			 mem_wr_error,mem_wr_error_d1;      

   
   assign wr_addr_err  = !((axi_awaddr >= MEM_START) && (axi_awaddr < MEM_STOP));

   assign mem_waddr    = axi_awaddr;
   assign mem_wen      = axi_awvalid && axi_wvalid & !wr_addr_error ? axi_wstrb : '0;
   assign mem_wr_error = {(axi_awvalid & wr_addr_err),1'b0};   
   assign axi_awready  = axi_wvalid;
   assign axi_wready   = '1;
   assign axi_bresp    = mem_wr_error_d1;
   assign axi_bvalid   = axi_bvalid_reg;
   
   always @(posedge clk) begin
      if (!rst_n) begin
	 mem_wr_error_d1 <= '0;
	 axi_bvalid_reg  <= '0;	 
      end
      else begin
         mem_wr_error_d1 <= mem_wr_error;
	 axi_bvalid_reg  <= axi_awvalid && axi_wvalid ? '1 : axi_bready ? '0 : axi_bvalid_reg;
      end
   end   


   assign rd_addr_err  = !((axi_araddr >= MEM_START) && (axi_araddr < MEM_STOP));
   
   assign mem_raddr    = axi_araddr;      
   assign mem_ren      = axi_arvalid & !rd_addr_error;   
   assign mem_rd_error = {(axi_arvalid & rd_addr_err),1'b0};   

   assign axi_arready = '1;
   assign axi_rdata   = |mem_rd_error_d1 ? '0 : mem_rdata;
   assign axi_rresp   = mem_rd_error_d1;
   assign axi_rvalid  = axi_rvalid_reg;
   
   always @(posedge clk) begin
      if (!rst_n) begin
	 mem_rd_error_d1 <= '0;
	 axi_rvalid_reg  <= '0;	 
      end
      else begin
         mem_rd_error_d1 <= mem_rd_error;
	 axi_rvalid_reg  <= axi_arvalid;	 
      end
   end   

endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
