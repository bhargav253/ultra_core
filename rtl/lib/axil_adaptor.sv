/*mem adapter*/
module axil_adapter 
  (/*AUTOARG*/
   // Outputs
   axi_awvalid, axi_awaddr, axi_wvalid, axi_wdata, axi_wstrb,
   axi_bready, axi_arvalid, axi_araddr, axi_rready, intf_accept,
   intf_rdata, intf_error,
   // Inputs
   clk, rst_n, axi_awready, axi_wready, axi_bvalid, axi_arready,
   axi_rvalid, axi_rdata, intf_val, intf_addr, intf_wdata, intf_wen,
   intf_ren
   );
   
   input 	      clk;
   input 	      rst_n;
   
   // AXI4-lite master memory interface

   output 	      axi_awvalid;
   input 	      axi_awready;
   output [31:0]      axi_awaddr;

   output 	      axi_wvalid;
   input 	      axi_wready;
   output [31:0]      axi_wdata;
   output [ 3:0]      axi_wstrb;

   input 	      axi_bvalid;
   output 	      axi_bready;

   output 	      axi_arvalid;
   input 	      axi_arready;
   output [31:0]      axi_araddr;

   input 	      axi_rvalid;
   output 	      axi_rready;
   input [31:0]       axi_rdata;

   input 	      intf_val;
   output 	      intf_accept;
   input [31:0]       intf_addr;
   input [31:0]       intf_wdata;
   input [ 3:0]       intf_wen;
   input 	      intf_ren;   
   output [31:0]      intf_rdata;
   output [31:0]      intf_error;   
   
   reg 		      ack_awvalid;
   reg 		      ack_arvalid;
   reg 		      ack_wvalid;
   reg 		      xfer_done;

   assign axi_awvalid = intf_val && |intf_wen && !ack_awvalid;
   assign axi_awaddr  = intf_addr;

   assign axi_arvalid = intf_val && intf_ren && !ack_arvalid;
   assign axi_araddr  = intf_addr;

   assign axi_wvalid = intf_val && |intf_wen && !ack_wvalid;
   assign axi_wdata  = intf_wdata;
   assign axi_wstrb  = intf_wen;

   assign intf_accept = axi_bvalid || axi_rvalid;
   assign axi_bready = intf_val && |intf_wen;
   assign axi_rready = intf_val && intf_ren;
   assign intf_rdata = axi_rdata;

   always @(posedge clk) begin
      if (!rst_n) begin
	 ack_awvalid <= 0;
      end 
      else begin
	 xfer_done <= intf_val && intf_accept;
	 if (axi_awready && axi_awvalid)
	   ack_awvalid <= 1;
	 if (axi_arready && axi_arvalid)
	   ack_arvalid <= 1;
	 if (axi_wready && axi_wvalid)
	   ack_wvalid <= 1;
	 if (xfer_done || !intf_val) begin
	    ack_awvalid <= 0;
	    ack_arvalid <= 0;
	    ack_wvalid <= 0;
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
