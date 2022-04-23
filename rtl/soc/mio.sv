module mio
  /* verilator lint_off VARHIDDEN */  
  #(
    parameter UART_START   = 32'h10000000,
    parameter UART_STOP    = 32'h10000004,
    parameter GPIO_START   = 32'h10000004,
    parameter GPIO_STOP    = 32'h10000008,
    parameter CLK_HZ       = 100000000,
    parameter BIT_RATE     = 115200,
    parameter PAYLOAD_BITS = 8)
   /* verilator lint_on VARHIDDEN */      
   (
    input 	  clk, 
    input 	  rst_n,


    output 	  mio__axi_arready,
    input [31:0]  mio__axi_araddr,
    input 	  mio__axi_arvalid,
   
    output 	  mio__axi_awready,
    input [31:0]  mio__axi_awaddr, 
    input 	  mio__axi_awvalid,

    output 	  mio__axi_wready,
    input 	  mio__axi_wvalid,
    input [31:0]  mio__axi_wdata, 
    input [3:0]   mio__axi_wstrb,
   
    output 	  mio__axi_bvalid,
    output [1:0]  mio__axi_bresp,
    input 	  mio__axi_bready,
   
    output [31:0] mio__axi_rdata,
    output [1:0]  mio__axi_rresp, 
    output 	  mio__axi_rvalid, 
    input 	  mio__axi_rready,

    input 	  UART_RXD,
    output 	  UART_TXD,    
    output [3:0]  GPIO_OUT
    );      
   
   logic [31:0]   gpio_axi_awaddr,uart_axi_awaddr,gpio_axi_wdata,uart_axi_wdata;
   logic [1:0] 	  gpio_axi_bresp,uart_axi_bresp;
   logic [3:0] 	  gpio_axi_wstrb,uart_axi_wstrb;

   logic [31:0]   gpio_axi_araddr,uart_axi_araddr,gpio_axi_rdata,uart_axi_rdata;
   logic [1:0] 	  gpio_axi_rresp,uart_axi_rresp;
   
   logic [2:0] 	  mio_intf_wr_decode;
   logic [2:0] 	  mio_intf_rd_decode;   

   logic [31:0]   gpio_reg,uart_tx_data;
   logic [7:0] 	  uart_rx_data;   
   
   /*AUTOLOGIC*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   logic		gpio_axi_arready;	// From u_gpio_reg of axil_reg.v
   logic		gpio_axi_arvalid;	// From u_mio_split of axil_split.v
   logic		gpio_axi_awready;	// From u_gpio_reg of axil_reg.v
   logic		gpio_axi_awvalid;	// From u_mio_split of axil_split.v
   logic		gpio_axi_bready;	// From u_mio_split of axil_split.v
   logic		gpio_axi_bvalid;	// From u_gpio_reg of axil_reg.v
   logic		gpio_axi_rready;	// From u_mio_split of axil_split.v
   logic		gpio_axi_rvalid;	// From u_gpio_reg of axil_reg.v
   logic		gpio_axi_wready;	// From u_gpio_reg of axil_reg.v
   logic		gpio_axi_wvalid;	// From u_mio_split of axil_split.v
   logic		uart_axi_arready;	// From u_uart_fifo of axil_ext.v
   logic		uart_axi_arvalid;	// From u_mio_split of axil_split.v
   logic		uart_axi_awready;	// From u_uart_fifo of axil_ext.v
   logic		uart_axi_awvalid;	// From u_mio_split of axil_split.v
   logic		uart_axi_bready;	// From u_mio_split of axil_split.v
   logic		uart_axi_bvalid;	// From u_uart_fifo of axil_ext.v
   logic		uart_axi_rready;	// From u_mio_split of axil_split.v
   logic		uart_axi_rvalid;	// From u_uart_fifo of axil_ext.v
   logic		uart_axi_wready;	// From u_uart_fifo of axil_ext.v
   logic		uart_axi_wvalid;	// From u_mio_split of axil_split.v
   logic		uart_rx_en;		// From u_uart_fifo of axil_ext.v
   logic		uart_tx_en;		// From u_uart_fifo of axil_ext.v
   // End of automatics

   
   /*
    axil_split AUTO_TEMPLATE (
    .src_axi_\(.*\)    (mio__axi_\1),
    .dst_axi_\(.*\)    ({gpio_axi_\1,uart_axi_\1}),    
    .wr_decode         (mio_intf_wr_decode),
    .rd_decode         (mio_intf_rd_decode),    
    );
    */
   
   axil_split #(.NUM_WR_DSTS(2),.NUM_RD_DSTS(2))
   u_mio_split (/*AUTOINST*/
		// Outputs
		.src_axi_awready	(mio__axi_awready),	 // Templated
		.src_axi_wready		(mio__axi_wready),	 // Templated
		.src_axi_bresp		(mio__axi_bresp),	 // Templated
		.src_axi_bvalid		(mio__axi_bvalid),	 // Templated
		.src_axi_arready	(mio__axi_arready),	 // Templated
		.src_axi_rdata		(mio__axi_rdata),	 // Templated
		.src_axi_rresp		(mio__axi_rresp),	 // Templated
		.src_axi_rvalid		(mio__axi_rvalid),	 // Templated
		.dst_axi_awaddr		({gpio_axi_awaddr,uart_axi_awaddr}), // Templated
		.dst_axi_awvalid	({gpio_axi_awvalid,uart_axi_awvalid}), // Templated
		.dst_axi_wdata		({gpio_axi_wdata,uart_axi_wdata}), // Templated
		.dst_axi_wstrb		({gpio_axi_wstrb,uart_axi_wstrb}), // Templated
		.dst_axi_wvalid		({gpio_axi_wvalid,uart_axi_wvalid}), // Templated
		.dst_axi_bready		({gpio_axi_bready,uart_axi_bready}), // Templated
		.dst_axi_araddr		({gpio_axi_araddr,uart_axi_araddr}), // Templated
		.dst_axi_arvalid	({gpio_axi_arvalid,uart_axi_arvalid}), // Templated
		.dst_axi_rready		({gpio_axi_rready,uart_axi_rready}), // Templated
		// Inputs
		.clk,
		.rst_n,
		.wr_decode		(mio_intf_wr_decode),	 // Templated
		.rd_decode		(mio_intf_rd_decode),	 // Templated
		.src_axi_awaddr		(mio__axi_awaddr),	 // Templated
		.src_axi_awvalid	(mio__axi_awvalid),	 // Templated
		.src_axi_wdata		(mio__axi_wdata),	 // Templated
		.src_axi_wstrb		(mio__axi_wstrb),	 // Templated
		.src_axi_wvalid		(mio__axi_wvalid),	 // Templated
		.src_axi_bready		(mio__axi_bready),	 // Templated
		.src_axi_araddr		(mio__axi_araddr),	 // Templated
		.src_axi_arvalid	(mio__axi_arvalid),	 // Templated
		.src_axi_rready		(mio__axi_rready),	 // Templated
		.dst_axi_awready	({gpio_axi_awready,uart_axi_awready}), // Templated
		.dst_axi_wready		({gpio_axi_wready,uart_axi_wready}), // Templated
		.dst_axi_bresp		({gpio_axi_bresp,uart_axi_bresp}), // Templated
		.dst_axi_bvalid		({gpio_axi_bvalid,uart_axi_bvalid}), // Templated
		.dst_axi_arready	({gpio_axi_arready,uart_axi_arready}), // Templated
		.dst_axi_rdata		({gpio_axi_rdata,uart_axi_rdata}), // Templated
		.dst_axi_rresp		({gpio_axi_rresp,uart_axi_rresp}), // Templated
		.dst_axi_rvalid		({gpio_axi_rvalid,uart_axi_rvalid})); // Templated
         

   assign mio_intf_wr_decode[2] = !(mio_intf_wr_decode[1] | mio_intf_wr_decode[0]);   // Error
   assign mio_intf_wr_decode[1] = (mio__axi_awaddr >= GPIO_START)  && (mio__axi_awaddr < GPIO_STOP);   
   assign mio_intf_wr_decode[0] = (mio__axi_awaddr >= UART_START)  && (mio__axi_awaddr < UART_STOP);

   assign mio_intf_rd_decode[2] = !(mio_intf_rd_decode[1] | mio_intf_rd_decode[0]);   // Error
   assign mio_intf_rd_decode[1] = (mio__axi_araddr >= GPIO_START)  && (mio__axi_araddr < GPIO_STOP);   
   assign mio_intf_rd_decode[0] = (mio__axi_araddr >= UART_START)  && (mio__axi_araddr < UART_STOP);      
   
   
   //-------------------------------------------------------------
   // UART FIFO
   //-------------------------------------------------------------         
   
   /*
    axil_ext AUTO_TEMPLATE (
    .axi_\(.*\)   (uart_axi_\1),    
    .ext_wrsp_val (uart_tx_done),
    .ext_wr_dat   (uart_tx_data),
    .ext_wen      (),
    .ext_wr_req   (uart_tx_en),
    .ext_rd_req   (uart_rx_en),
    .ext_rrsp_val (uart_rx_valid),
    .ext_rrsp_dat ({24'd0,uart_rx_data}),
    );
    */
   
   axil_ext  #(.MEM_BASE(UART_START))
     u_uart_fifo (/*AUTOINST*/
		  // Outputs
		  .axi_awready		(uart_axi_awready),	 // Templated
		  .axi_wready		(uart_axi_wready),	 // Templated
		  .axi_bresp		(uart_axi_bresp),	 // Templated
		  .axi_bvalid		(uart_axi_bvalid),	 // Templated
		  .axi_arready		(uart_axi_arready),	 // Templated
		  .axi_rdata		(uart_axi_rdata),	 // Templated
		  .axi_rresp		(uart_axi_rresp),	 // Templated
		  .axi_rvalid		(uart_axi_rvalid),	 // Templated
		  .ext_rd_req		(uart_rx_en),		 // Templated
		  .ext_wr_req		(uart_tx_en),		 // Templated
		  .ext_wr_dat		(uart_tx_data),		 // Templated
		  .ext_wen		(),			 // Templated
		  // Inputs
		  .clk,
		  .rst_n,
		  .axi_awaddr		(uart_axi_awaddr),	 // Templated
		  .axi_awvalid		(uart_axi_awvalid),	 // Templated
		  .axi_wdata		(uart_axi_wdata),	 // Templated
		  .axi_wstrb		(uart_axi_wstrb),	 // Templated
		  .axi_wvalid		(uart_axi_wvalid),	 // Templated
		  .axi_bready		(uart_axi_bready),	 // Templated
		  .axi_araddr		(uart_axi_araddr),	 // Templated
		  .axi_arvalid		(uart_axi_arvalid),	 // Templated
		  .axi_rready		(uart_axi_rready),	 // Templated
		  .ext_rrsp_dat		({24'd0,uart_rx_data}),	 // Templated
		  .ext_rrsp_val		(uart_rx_valid),	 // Templated
		  .ext_wrsp_val		(uart_tx_done));		 // Templated
   
   
   uart_tx #(
	     .BIT_RATE     (BIT_RATE),
	     .PAYLOAD_BITS (PAYLOAD_BITS),
	     .CLK_HZ       (CLK_HZ)
	     ) uart_tx
     (
      .clk          (clk          ),
      .rst_n        (rst_n        ),
      .uart_txd     (UART_TXD     ),
      .uart_tx_en   (uart_tx_en   ),
      .uart_tx_done (uart_tx_done ),
      .uart_tx_data (uart_tx_data[PAYLOAD_BITS-1:0] ) 
      );

   uart_rx #(
	     .BIT_RATE     (BIT_RATE),
	     .PAYLOAD_BITS (PAYLOAD_BITS),
	     .CLK_HZ       (CLK_HZ)
	     ) uart_rx
     (
      .clk          (clk          ),
      .rst_n        (rst_n        ),
      .uart_rxd     (UART_RXD     ),
      .uart_rx_en   (uart_rx_en   ),
      .uart_rx_break(             ),
      .uart_rx_valid(uart_rx_valid),
      .uart_rx_data (uart_rx_data[PAYLOAD_BITS-1:0] ) 
      );
   

   //-------------------------------------------------------------
   // GPIO OUT
   //-------------------------------------------------------------         

   /*
    axil_reg AUTO_TEMPLATE (
    .axi_\(.*\)  (gpio_axi_\1),    
    .reg_data    (gpio_reg),
    );
    */
   
   axil_reg #(.MEM_BASE(GPIO_START))
     u_gpio_reg (/*AUTOINST*/
		 // Outputs
		 .axi_awready		(gpio_axi_awready),	 // Templated
		 .axi_wready		(gpio_axi_wready),	 // Templated
		 .axi_bresp		(gpio_axi_bresp),	 // Templated
		 .axi_bvalid		(gpio_axi_bvalid),	 // Templated
		 .axi_arready		(gpio_axi_arready),	 // Templated
		 .axi_rdata		(gpio_axi_rdata),	 // Templated
		 .axi_rresp		(gpio_axi_rresp),	 // Templated
		 .axi_rvalid		(gpio_axi_rvalid),	 // Templated
		 .reg_data		(gpio_reg),		 // Templated
		 // Inputs
		 .clk,
		 .rst_n,
		 .axi_awaddr		(gpio_axi_awaddr),	 // Templated
		 .axi_awvalid		(gpio_axi_awvalid),	 // Templated
		 .axi_wdata		(gpio_axi_wdata),	 // Templated
		 .axi_wstrb		(gpio_axi_wstrb),	 // Templated
		 .axi_wvalid		(gpio_axi_wvalid),	 // Templated
		 .axi_bready		(gpio_axi_bready),	 // Templated
		 .axi_araddr		(gpio_axi_araddr),	 // Templated
		 .axi_arvalid		(gpio_axi_arvalid),	 // Templated
		 .axi_rready		(gpio_axi_rready));	 // Templated
   
   assign GPIO_OUT = gpio_reg[3:0];

   
endmodule

// Local variables:
// verilog-library-directories:("." "../lib/.")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
