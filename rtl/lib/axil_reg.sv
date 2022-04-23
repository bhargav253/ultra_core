module axil_reg
  #(
    parameter MEM_BASE   = 32'h10000004,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   axi_awready, axi_wready, axi_bresp, axi_bvalid, axi_arready,
   axi_rdata, axi_rresp, axi_rvalid, reg_data,
   // Inputs
   clk, rst_n, axi_awaddr, axi_awvalid, axi_wdata, axi_wstrb,
   axi_wvalid, axi_bready, axi_araddr, axi_arvalid, axi_rready
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
   
   output logic [DATA_WIDTH-1:0] reg_data;   
   
   
   
   logic 			 rd_addr_err,wr_addr_err;   
   logic [1:0] 			 mem_rd_error,mem_rd_error_d1;
   logic [1:0] 			 mem_wr_error,mem_wr_error_d1;      
   logic 			 wr_resp_full,wr_resp_pend;
   logic 			 rd_resp_full,rd_resp_pend;      
   logic 			 reg_wr;
   logic [DATA_WIDTH-1:0] 	 reg_wr_dat;
   logic [STRB_WIDTH-1:0] 	 reg_wen;   
   
   assign wr_addr_err  = !(axi_awaddr == MEM_BASE);

   assign reg_wr       = axi_awvalid && axi_wvalid & !wr_addr_err & !wr_resp_full;
   assign reg_wr_dat   = axi_wdata;
   assign reg_wen      = axi_wstrb;   
   
   assign mem_wr_error = {(axi_awvalid & axi_wvalid & wr_addr_err),1'b0};   
   assign axi_awready  = axi_awvalid && axi_wvalid & !wr_resp_full;
   assign axi_wready   = axi_awvalid && axi_wvalid & !wr_resp_full;
   assign axi_bresp    = mem_wr_error_d1;
   assign axi_bvalid   = wr_resp_pend;

   assign wr_resp_full = wr_resp_pend & !axi_bready;   

   always @(posedge clk) begin
      if (!rst_n) begin
	 wr_resp_pend    <= '0;	 
	 mem_wr_error_d1 <= '0;
      end
      else begin
	 wr_resp_pend    <= axi_awvalid && axi_wvalid & !wr_resp_full ? '1 :           axi_bready ? '0 : wr_resp_pend;
         mem_wr_error_d1 <= axi_awvalid && axi_wvalid & !wr_resp_full ? mem_wr_error : axi_bready ? '0 : mem_wr_error_d1;
      end
   end           

   assign rd_addr_err  = !(axi_araddr == MEM_BASE);

   assign mem_rd_error = {(axi_arvalid & rd_addr_err),1'b0};   
   assign axi_arready  = axi_arvalid & !rd_resp_full;

   assign rd_resp_full = rd_resp_pend & !axi_rready;   
   
   assign axi_rdata    = |mem_rd_error_d1 ? '0 : reg_data;   
   assign axi_rresp    = mem_rd_error_d1;
   assign axi_rvalid   = rd_resp_pend;   
      
   always @(posedge clk) begin
      if (!rst_n) begin
	 rd_resp_pend    <= '0;
	 mem_rd_error_d1 <= '0;
      end
      else begin
	 rd_resp_pend    <= axi_arvalid & !rd_resp_full ? '1 :           axi_rready ? '0 : rd_resp_pend;	 
         mem_rd_error_d1 <= axi_arvalid & !rd_resp_full ? mem_rd_error : axi_rready ? '0 : mem_rd_error_d1;	 
      end
   end   
   
   always @(posedge clk) begin
      if (!rst_n)     reg_data <= '0;
      else if(reg_wr) begin
	 for(int i=0;i<DATA_WIDTH;i=i+8) begin
	    reg_data[i+:8] <= reg_wen[i/8] ? reg_wr_dat[i+:8] : reg_data[i+:8];
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
