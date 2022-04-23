module axil_rd_ext
  #(
    parameter MEM_BASE   = 32'h10000000,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter STRB_WIDTH = (DATA_WIDTH/8))
   (/*AUTOARG*/
   // Outputs
   axi_arready, axi_rdata, axi_rresp, axi_rvalid, ext_rd_req,
   // Inputs
   clk, rst_n, axi_araddr, axi_arvalid, axi_rready, ext_rsp_dat,
   ext_rsp_val
   );
   
   input 			 clk;
   input 			 rst_n;

   input [ADDR_WIDTH-1:0] 	 axi_araddr;
   input 			 axi_arvalid;
   output logic 		 axi_arready;

   output logic [DATA_WIDTH-1:0] axi_rdata;
   output logic [1:0] 		 axi_rresp;
   output logic			 axi_rvalid;
   input 			 axi_rready;

   output 			 ext_rd_req;   
   input [DATA_WIDTH-1:0] 	 ext_rsp_dat;
   input 			 ext_rsp_val;   
   
   logic 			 rd_resp_pend,rd_resp_full;
   logic 			 rd_addr_err;   
   logic [1:0] 			 mem_rd_error,mem_rd_error_d1;
   logic [DATA_WIDTH-1:0] 	 skid_fif_dat;
   logic 			 skid_fif_val;   
   
   assign rd_addr_err  = !(axi_araddr == MEM_BASE);

   assign ext_rd_req   = axi_arvalid && !rd_addr_err & !rd_resp_full;
   assign mem_rd_error = {(axi_arvalid & rd_addr_err),1'b0};   
   assign axi_arready  = axi_arvalid & !rd_resp_full;

   always_comb begin
      axi_rdata    = '0;	 
      axi_rresp    = '0;
      axi_rvalid   = '0;      
      
      if(|mem_rd_error_d1) begin
	 axi_rdata    = '0;	 
	 axi_rresp    = mem_rd_error_d1;
	 axi_rvalid   = '1;
      end
      else if(skid_fif_val | ext_rsp_val) begin
	 axi_rdata  = skid_fif_val ? skid_fif_dat : ext_rsp_dat;
	 axi_rresp  = mem_rd_error_d1;	 
	 axi_rvalid = '1;
      end
   end
   
   assign rd_resp_full = rd_resp_pend & !axi_rready;   
   
   always @(posedge clk) begin
      if (!rst_n) begin
	 rd_resp_pend    <= '0;
	 mem_rd_error_d1 <= '0;
      end
      else begin
	 rd_resp_pend    <= axi_arvalid & !rd_resp_full ? '1 :           (ext_rsp_val | skid_fif_val | mem_rd_error_d1[1]) & axi_rready ? '0 : rd_resp_pend;	 
         mem_rd_error_d1 <= axi_arvalid & !rd_resp_full ? mem_rd_error : (ext_rsp_val | skid_fif_val | mem_rd_error_d1[1]) & axi_rready ? '0 : mem_rd_error_d1;	 
      end
   end   
   
   always @(posedge clk) begin
      if (!rst_n) begin
	 skid_fif_val <= '0;
	 skid_fif_dat <= '0;
      end
      else begin
	 skid_fif_val <= ext_rsp_val & !axi_rready ? '1 : axi_rready ? '0 : skid_fif_val;	 
	 skid_fif_dat <= ext_rsp_val ? ext_rsp_dat : skid_fif_dat;	 
      end
   end            
   
endmodule

// Local variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
