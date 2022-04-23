`ifndef ULTRA_CORE__SV
`define ULTRA_CORE__SV

`define RISCV_BOOT_ADDRESS      32'h00000000

module ultra_core
  (
   // Declare some signals so we can see how I/O works
   input 	clk,
   input 	rst_n,
   input 	UART_RX,
   output 	UART_TX,   
   output [3:0] GPIO_O
   );

   assign rdata = '0;   
   
   wire 		     intr        = 1'b0;   
   wire [ 31:0] 	     boot_vector = `RISCV_BOOT_ADDRESS;   

   wire [ 31:0] 	     core__d_addr;
   wire [ 31:0] 	     core__d_wdata;
   wire 		     core__d_ren;
   wire [ 3:0] 		     core__d_wen;
   wire [ 10:0] 	     core__d_req_tag; 

   wire 		     d__core_accept;
   wire 		     d__core_val;
   wire 		     d__core_error;
   wire [ 31:0] 	     d__core_rdata;
   wire [ 10:0] 	     d__core_resp_tag;

   wire [ 31:0] 	     core__i_addr;
   wire 		     core__i_ren;
   
   wire 		     i__core_accept;
   wire 		     i__core_val;
   wire 		     i__core_error;
   wire [ 31:0] 	     i__core_rdata;
   wire [ 31:0] 	     i__core_pc;

   wire 		     mio__axi_arready;
   wire [31:0] 		     mio__axi_araddr;
   wire 		     mio__axi_arvalid;
   wire 		     mio__axi_awready;
   wire [31:0] 		     mio__axi_awaddr; 
   wire 		     mio__axi_awvalid;
   wire 		     mio__axi_wready;
   wire 		     mio__axi_wvalid;
   wire [31:0] 		     mio__axi_wdata; 
   wire [3:0] 		     mio__axi_wstrb;
   wire 		     mio__axi_bvalid;
   wire [1:0] 		     mio__axi_bresp;
   wire 		     mio__axi_bready;
   wire [31:0] 		     mio__axi_rdata;
   wire [1:0] 		     mio__axi_rresp; 
   wire 		     mio__axi_rvalid; 
   wire 		     mio__axi_rready;
         
   riscv_core core
     (
      // Inputs
      .clk_i(clk)
      ,.rst_i(~rst_n)
      ,.mem_d_data_rd_i(d__core_rdata)
      ,.mem_d_accept_i(d__core_accept)      
      ,.mem_d_ack_i(d__core_val)
      ,.mem_d_resp_tag_i(d__core_resp_tag)
      ,.mem_d_error_i(d__core_error)
      ,.mem_i_accept_i(i__core_accept)
      ,.mem_i_valid_i(i__core_val)
      ,.mem_i_inst_i(i__core_rdata)
      ,.mem_i_inst_pc_i(i__core_pc)
      ,.mem_i_error_i(i__core_error)
      ,.intr_i(intr)
      ,.reset_vector_i(boot_vector)
      ,.cpu_id_i(32'b0)

      // Outputs
      ,.mem_d_addr_o(core__d_addr)
      ,.mem_d_data_wr_o(core__d_wdata)
      ,.mem_d_rd_o(core__d_ren)
      ,.mem_d_wr_o(core__d_wen)
      ,.mem_d_cacheable_o()
      ,.mem_d_req_tag_o(core__d_req_tag)
      ,.mem_d_invalidate_o()
      ,.mem_d_flush_o()    
      ,.mem_i_rd_o(core__i_ren)
      ,.mem_i_flush_o()
      ,.mem_i_invalidate_o()
      ,.mem_i_pc_o(core__i_addr)
      );
   
   
   iob 
   iob (
	// inputs
	.clk(clk) 
	,.rst_n(rst_n)
	,.core__d_addr(core__d_addr)
	,.core__d_wdata(core__d_wdata)
	,.core__d_ren(core__d_ren)
	,.core__d_wen(core__d_wen)
	,.core__d_req_tag(core__d_req_tag) 
	,.core__i_addr(core__i_addr)
	,.core__i_ren(core__i_ren)
	,.d__core_accept(d__core_accept)
	,.d__core_val(d__core_val)
	,.d__core_error(d__core_error)
	,.d__core_rdata(d__core_rdata)
	,.d__core_resp_tag(d__core_resp_tag)
	,.mio__axi_arready(mio__axi_arready)
	,.mio__axi_araddr(mio__axi_araddr)
	,.mio__axi_arvalid(mio__axi_arvalid)
	,.mio__axi_awready(mio__axi_awready)
	,.mio__axi_awaddr(mio__axi_awaddr) 
	,.mio__axi_awvalid(mio__axi_awvalid)
	,.mio__axi_wready(mio__axi_wready)
	,.mio__axi_wvalid(mio__axi_wvalid)
	,.mio__axi_wdata(mio__axi_wdata) 
	,.mio__axi_wstrb(mio__axi_wstrb)
	,.mio__axi_bvalid(mio__axi_bvalid)
	,.mio__axi_bresp(mio__axi_bresp)
	,.mio__axi_bready(mio__axi_bready)
	,.mio__axi_rdata(mio__axi_rdata)
	,.mio__axi_rresp(mio__axi_rresp) 
	,.mio__axi_rvalid(mio__axi_rvalid) 
	,.mio__axi_rready(mio__axi_rready)
	,.i__core_accept(i__core_accept)
	,.i__core_val(i__core_val)
	,.i__core_error(i__core_error)
	,.i__core_rdata(i__core_rdata)
	,.i__core_pc(i__core_pc));


   mio 
     mio (
	  // inputs
	  .clk(clk) 
	  ,.rst_n(rst_n)
	  ,.mio__axi_arready(mio__axi_arready)
	  ,.mio__axi_araddr(mio__axi_araddr)
	  ,.mio__axi_arvalid(mio__axi_arvalid)
	  ,.mio__axi_awready(mio__axi_awready)
	  ,.mio__axi_awaddr(mio__axi_awaddr) 
	  ,.mio__axi_awvalid(mio__axi_awvalid)
	  ,.mio__axi_wready(mio__axi_wready)
	  ,.mio__axi_wvalid(mio__axi_wvalid)
	  ,.mio__axi_wdata(mio__axi_wdata) 
	  ,.mio__axi_wstrb(mio__axi_wstrb)
	  ,.mio__axi_bvalid(mio__axi_bvalid)
	  ,.mio__axi_bresp(mio__axi_bresp)
	  ,.mio__axi_bready(mio__axi_bready)
	  ,.mio__axi_rdata(mio__axi_rdata)
	  ,.mio__axi_rresp(mio__axi_rresp) 
	  ,.mio__axi_rvalid(mio__axi_rvalid) 
	  ,.mio__axi_rready(mio__axi_rready)
	  ,.UART_RXD(UART_RX)
	  ,.UART_TXD(UART_TX)	  
	  ,.GPIO_OUT(GPIO_O));

   
   // Print some stuff as an example
   initial begin
      $display("[%0t] Model running...\n", $time);
   end

endmodule : ultra_core

`endif
