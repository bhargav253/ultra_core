module iob
  #(parameter MIO_START   = 32'h10000000,
    parameter MIO_STOP    = 32'h10000008,
    parameter ROM_START   = 32'h00000000,
    parameter ROM_STOP    = 32'h00000400,
    parameter RAM_START   = 32'h00000400,
    parameter RAM_STOP    = 32'h00001000)   
   (
    input 		 clk, 
    input 		 rst_n,
   
    //core d interface
    input [ 31:0] 	 core__d_addr,
    input [ 31:0] 	 core__d_wdata,
    input 		 core__d_ren,
    input [ 3:0] 	 core__d_wen,
    input [ 10:0] 	 core__d_req_tag, 
   
    output logic 	 d__core_accept,
    output logic 	 d__core_val,
    output logic 	 d__core_error,
    output logic [ 31:0] d__core_rdata,
    output logic [ 10:0] d__core_resp_tag,

    //core i interface   
    input [ 31:0] 	 core__i_addr,
    input 		 core__i_ren,
   
    output logic 	 i__core_accept,
    output logic 	 i__core_val,
    output logic 	 i__core_error,
    output logic [ 31:0] i__core_rdata,
    output logic [ 31:0] i__core_pc,

    input 		 mio__axi_arready,
    output [31:0] 	 mio__axi_araddr,
    output 		 mio__axi_arvalid,
    
    input 		 mio__axi_awready,
    output [31:0] 	 mio__axi_awaddr, 
    output 		 mio__axi_awvalid,

    input 		 mio__axi_wready,
    output 		 mio__axi_wvalid,
    output [31:0] 	 mio__axi_wdata, 
    output [3:0] 	 mio__axi_wstrb,
    
    input 		 mio__axi_bvalid,
    input [1:0] 	 mio__axi_bresp,
    output 		 mio__axi_bready,
    
    input [31:0] 	 mio__axi_rdata,
    input [1:0] 	 mio__axi_rresp, 
    input 		 mio__axi_rvalid, 
    output 		 mio__axi_rready    
   );


   logic [2:0] 		 dat_intf_wr_decode;
   logic [3:0] 		 dat_intf_rd_decode;

   logic [31:0] 	 dat_ram_axi_araddr,dat_ram_axi_awaddr;
   logic [31:0] 	 dat_rom_axi_rdata,dat_ram_axi_rdata;         
   logic [31:0] 	 dat_ram_axi_wdata;      
   logic [31:0] 	 dat_rom_axi_araddr;
   logic [1:0] 		 dat_ram_axi_rresp,dat_rom_axi_rresp,dat_ram_axi_bresp;
   logic [3:0] 		 dat_ram_axi_wstrb;   

   logic [31:0] 	 dat_axi_araddr,dat_axi_awaddr,dat_axi_rdata,dat_axi_wdata;
   logic [1:0] 		 dat_axi_rresp,dat_axi_bresp;   
   logic [3:0] 		 dat_axi_wstrb;

   logic [31:0] 	 inst_axi_araddr,inst_axi_rdata;
   logic [1:0] 		 inst_axi_rresp;   

   logic [31:0] 	 rom_axi_araddr,rom_axi_rdata;
   logic [1:0] 		 rom_axi_rresp;   
   
   logic [31:0] 	 ram_rdata,ram_wdata,ram_raddr,ram_waddr;
   logic [31:0] 	 rom_rdata,rom_raddr;      

   logic [3:0] 		 ram_wen;   
   
  /*AUTOINPUT*/

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   logic		dat_axi_arready;	// From u_dat_split of axil_split.v
   logic		dat_axi_arvalid;	// From u_dat_intf of axil_adaptor.v
   logic		dat_axi_awready;	// From u_dat_split of axil_split.v
   logic		dat_axi_awvalid;	// From u_dat_intf of axil_adaptor.v
   logic		dat_axi_bready;		// From u_dat_intf of axil_adaptor.v
   logic		dat_axi_bvalid;		// From u_dat_split of axil_split.v
   logic		dat_axi_rready;		// From u_dat_intf of axil_adaptor.v
   logic		dat_axi_rvalid;		// From u_dat_split of axil_split.v
   logic		dat_axi_wready;		// From u_dat_split of axil_split.v
   logic		dat_axi_wvalid;		// From u_dat_intf of axil_adaptor.v
   logic		dat_ram_axi_arready;	// From u_ram_intf of axil_dp_ram.v
   logic		dat_ram_axi_arvalid;	// From u_dat_split of axil_split.v
   logic		dat_ram_axi_awready;	// From u_ram_intf of axil_dp_ram.v
   logic		dat_ram_axi_awvalid;	// From u_dat_split of axil_split.v
   logic		dat_ram_axi_bready;	// From u_dat_split of axil_split.v
   logic		dat_ram_axi_bvalid;	// From u_ram_intf of axil_dp_ram.v
   logic		dat_ram_axi_rready;	// From u_dat_split of axil_split.v
   logic		dat_ram_axi_rvalid;	// From u_ram_intf of axil_dp_ram.v
   logic		dat_ram_axi_wready;	// From u_ram_intf of axil_dp_ram.v
   logic		dat_ram_axi_wvalid;	// From u_dat_split of axil_split.v
   logic		dat_rom_axi_arready;	// From u_rom_axi of axil_rd_merge.v
   logic		dat_rom_axi_arvalid;	// From u_dat_split of axil_split.v
   logic		dat_rom_axi_rready;	// From u_dat_split of axil_split.v
   logic		dat_rom_axi_rvalid;	// From u_rom_axi of axil_rd_merge.v
   logic		inst_axi_arready;	// From u_rom_axi of axil_rd_merge.v
   logic		inst_axi_arvalid;	// From u_inst_intf of axil_adaptor.v
   logic		inst_axi_rready;	// From u_inst_intf of axil_adaptor.v
   logic		inst_axi_rvalid;	// From u_rom_axi of axil_rd_merge.v
   logic		ram_ren;		// From u_ram_intf of axil_dp_ram.v
   logic		rom_axi_arready;	// From u_rom_intf of axil_rom.v
   logic		rom_axi_arvalid;	// From u_rom_axi of axil_rd_merge.v
   logic		rom_axi_rready;		// From u_rom_axi of axil_rd_merge.v
   logic		rom_axi_rvalid;		// From u_rom_intf of axil_rom.v
   // End of automatics
   
//-------------------------------------------------------------
// Instruction interface
//-------------------------------------------------------------         
   
   /*
    axil_adaptor AUTO_TEMPLATE (
    .axi_aw.*       (@"(if (equal vl-dir \\"output\\") \\"\\" \\"'0\\")"),
    .axi_w.*        (@"(if (equal vl-dir \\"output\\") \\"\\" \\"'0\\")"),
    .axi_b.*        (@"(if (equal vl-dir \\"output\\") \\"\\" \\"'0\\")"),    
    .axi_awready    ('1),
    .axi_wready     ('1),    
    .axi_\(ar.*\)   (inst_axi_\1),
    .axi_\(r.*\)    (inst_axi_\1),    
    .intf_addr      (core__i_addr),
    .intf_ren       (core__i_ren),
    .intf_req_tag   (core__i_addr),            
    .intf_wen       ('0),
    .intf_wdata     ('0),    
    .intf_accept    (i__core_accept),
    .intf_val       (i__core_val),
    .intf_error     (i__core_error),
    .intf_rdata     (i__core_rdata),
    .intf_resp_tag  (i__core_pc),
    );
    */
   
   axil_adaptor
     u_inst_intf (/*AUTOINST*/
		  // Outputs
		  .axi_awaddr		(),			 // Templated
		  .axi_awvalid		(),			 // Templated
		  .axi_wvalid		(),			 // Templated
		  .axi_wdata		(),			 // Templated
		  .axi_wstrb		(),			 // Templated
		  .axi_bready		(),			 // Templated
		  .axi_araddr		(inst_axi_araddr),	 // Templated
		  .axi_arvalid		(inst_axi_arvalid),	 // Templated
		  .axi_rready		(inst_axi_rready),	 // Templated
		  .intf_accept		(i__core_accept),	 // Templated
		  .intf_val		(i__core_val),		 // Templated
		  .intf_error		(i__core_error),	 // Templated
		  .intf_rdata		(i__core_rdata),	 // Templated
		  .intf_resp_tag	(i__core_pc),		 // Templated
		  // Inputs
		  .clk,
		  .rst_n,
		  .axi_awready		('1),			 // Templated
		  .axi_wready		('1),			 // Templated
		  .axi_bvalid		('0),			 // Templated
		  .axi_bresp		('0),			 // Templated
		  .axi_arready		(inst_axi_arready),	 // Templated
		  .axi_rvalid		(inst_axi_rvalid),	 // Templated
		  .axi_rdata		(inst_axi_rdata),	 // Templated
		  .axi_rresp		(inst_axi_rresp),	 // Templated
		  .intf_addr		(core__i_addr),		 // Templated
		  .intf_wdata		('0),			 // Templated
		  .intf_ren		(core__i_ren),		 // Templated
		  .intf_wen		('0),			 // Templated
		  .intf_req_tag		(core__i_addr));		 // Templated
   
   
//-------------------------------------------------------------
// Data interface
//-------------------------------------------------------------

   /*
    axil_adaptor AUTO_TEMPLATE (
    .axi_\(.*\)    (dat_axi_\1),
    .intf_addr     (core__d_addr),
    .intf_ren      (core__d_ren),
    .intf_req_tag  (core__d_req_tag),            
    .intf_wen      (core__d_wen),
    .intf_wdata    (core__d_wdata),    
    .intf_accept   (d__core_accept),
    .intf_val      (d__core_val),
    .intf_error    (d__core_error),
    .intf_rdata    (d__core_rdata),
    .intf_resp_tag (d__core_resp_tag),
    );
    */
   
   axil_adaptor #(.TAG_WIDTH(11))
     u_dat_intf (/*AUTOINST*/
		 // Outputs
		 .axi_awaddr		(dat_axi_awaddr),	 // Templated
		 .axi_awvalid		(dat_axi_awvalid),	 // Templated
		 .axi_wvalid		(dat_axi_wvalid),	 // Templated
		 .axi_wdata		(dat_axi_wdata),	 // Templated
		 .axi_wstrb		(dat_axi_wstrb),	 // Templated
		 .axi_bready		(dat_axi_bready),	 // Templated
		 .axi_araddr		(dat_axi_araddr),	 // Templated
		 .axi_arvalid		(dat_axi_arvalid),	 // Templated
		 .axi_rready		(dat_axi_rready),	 // Templated
		 .intf_accept		(d__core_accept),	 // Templated
		 .intf_val		(d__core_val),		 // Templated
		 .intf_error		(d__core_error),	 // Templated
		 .intf_rdata		(d__core_rdata),	 // Templated
		 .intf_resp_tag		(d__core_resp_tag),	 // Templated
		 // Inputs
		 .clk,
		 .rst_n,
		 .axi_awready		(dat_axi_awready),	 // Templated
		 .axi_wready		(dat_axi_wready),	 // Templated
		 .axi_bvalid		(dat_axi_bvalid),	 // Templated
		 .axi_bresp		(dat_axi_bresp),	 // Templated
		 .axi_arready		(dat_axi_arready),	 // Templated
		 .axi_rvalid		(dat_axi_rvalid),	 // Templated
		 .axi_rdata		(dat_axi_rdata),	 // Templated
		 .axi_rresp		(dat_axi_rresp),	 // Templated
		 .intf_addr		(core__d_addr),		 // Templated
		 .intf_wdata		(core__d_wdata),	 // Templated
		 .intf_ren		(core__d_ren),		 // Templated
		 .intf_wen		(core__d_wen),		 // Templated
		 .intf_req_tag		(core__d_req_tag));	 // Templated

   

   /*
    axil_split AUTO_TEMPLATE (
    .src_axi_\(.*\)    (dat_axi_\1),
    .dst_axi_ar\(.*\)  ({mio__axi_ar\1,dat_ram_axi_ar\1,dat_rom_axi_ar\1}),
    .dst_axi_r\(.*\)   ({mio__axi_r\1,dat_ram_axi_r\1,dat_rom_axi_r\1}),    
    .dst_axi_aw\(.*\)  ({mio__axi_aw\1,dat_ram_axi_aw\1}),    
    .dst_axi_w\(.*\)   ({mio__axi_w\1,dat_ram_axi_w\1}),        
    .dst_axi_b\(.*\)   ({mio__axi_b\1,dat_ram_axi_b\1}),            
    .wr_decode         (dat_intf_wr_decode),
    .rd_decode         (dat_intf_rd_decode),    
    );
    */
   
   axil_split #(.NUM_WR_DSTS(2),.NUM_RD_DSTS(3))
     u_dat_split (/*AUTOINST*/
		  // Outputs
		  .src_axi_awready	(dat_axi_awready),	 // Templated
		  .src_axi_wready	(dat_axi_wready),	 // Templated
		  .src_axi_bresp	(dat_axi_bresp),	 // Templated
		  .src_axi_bvalid	(dat_axi_bvalid),	 // Templated
		  .src_axi_arready	(dat_axi_arready),	 // Templated
		  .src_axi_rdata	(dat_axi_rdata),	 // Templated
		  .src_axi_rresp	(dat_axi_rresp),	 // Templated
		  .src_axi_rvalid	(dat_axi_rvalid),	 // Templated
		  .dst_axi_awaddr	({mio__axi_awaddr,dat_ram_axi_awaddr}), // Templated
		  .dst_axi_awvalid	({mio__axi_awvalid,dat_ram_axi_awvalid}), // Templated
		  .dst_axi_wdata	({mio__axi_wdata,dat_ram_axi_wdata}), // Templated
		  .dst_axi_wstrb	({mio__axi_wstrb,dat_ram_axi_wstrb}), // Templated
		  .dst_axi_wvalid	({mio__axi_wvalid,dat_ram_axi_wvalid}), // Templated
		  .dst_axi_bready	({mio__axi_bready,dat_ram_axi_bready}), // Templated
		  .dst_axi_araddr	({mio__axi_araddr,dat_ram_axi_araddr,dat_rom_axi_araddr}), // Templated
		  .dst_axi_arvalid	({mio__axi_arvalid,dat_ram_axi_arvalid,dat_rom_axi_arvalid}), // Templated
		  .dst_axi_rready	({mio__axi_rready,dat_ram_axi_rready,dat_rom_axi_rready}), // Templated
		  // Inputs
		  .clk,
		  .rst_n,
		  .wr_decode		(dat_intf_wr_decode),	 // Templated
		  .rd_decode		(dat_intf_rd_decode),	 // Templated
		  .src_axi_awaddr	(dat_axi_awaddr),	 // Templated
		  .src_axi_awvalid	(dat_axi_awvalid),	 // Templated
		  .src_axi_wdata	(dat_axi_wdata),	 // Templated
		  .src_axi_wstrb	(dat_axi_wstrb),	 // Templated
		  .src_axi_wvalid	(dat_axi_wvalid),	 // Templated
		  .src_axi_bready	(dat_axi_bready),	 // Templated
		  .src_axi_araddr	(dat_axi_araddr),	 // Templated
		  .src_axi_arvalid	(dat_axi_arvalid),	 // Templated
		  .src_axi_rready	(dat_axi_rready),	 // Templated
		  .dst_axi_awready	({mio__axi_awready,dat_ram_axi_awready}), // Templated
		  .dst_axi_wready	({mio__axi_wready,dat_ram_axi_wready}), // Templated
		  .dst_axi_bresp	({mio__axi_bresp,dat_ram_axi_bresp}), // Templated
		  .dst_axi_bvalid	({mio__axi_bvalid,dat_ram_axi_bvalid}), // Templated
		  .dst_axi_arready	({mio__axi_arready,dat_ram_axi_arready,dat_rom_axi_arready}), // Templated
		  .dst_axi_rdata	({mio__axi_rdata,dat_ram_axi_rdata,dat_rom_axi_rdata}), // Templated
		  .dst_axi_rresp	({mio__axi_rresp,dat_ram_axi_rresp,dat_rom_axi_rresp}), // Templated
		  .dst_axi_rvalid	({mio__axi_rvalid,dat_ram_axi_rvalid,dat_rom_axi_rvalid})); // Templated
         

   assign dat_intf_wr_decode[2] = !(dat_intf_wr_decode[1] | dat_intf_wr_decode[0]);   // Error
   assign dat_intf_wr_decode[1] = (dat_axi_awaddr >= MIO_START)  && (dat_axi_awaddr < MIO_STOP);   
   assign dat_intf_wr_decode[0] = (dat_axi_awaddr >= RAM_START)  && (dat_axi_awaddr < RAM_STOP);
   
   assign dat_intf_rd_decode[3] = !(dat_intf_rd_decode[2] | dat_intf_rd_decode[1] | dat_intf_rd_decode[0]);   // Error
   assign dat_intf_rd_decode[2] = (dat_axi_araddr >= MIO_START)  && (dat_axi_araddr < MIO_STOP);
   assign dat_intf_rd_decode[1] = (dat_axi_araddr >= RAM_START)  && (dat_axi_araddr < RAM_STOP);
   assign dat_intf_rd_decode[0] = (dat_axi_araddr >= ROM_START)  && (dat_axi_araddr < ROM_STOP);
      
   
   /*
    axil_rd_merge AUTO_TEMPLATE (
    .src_axi_\(.*\) ({inst_axi_\1,dat_rom_axi_\1}),
    .dst_axi_\(.*\) (rom_axi_\1),
    );
    */
   
   axil_rd_merge
     u_rom_axi (/*AUTOINST*/
		// Outputs
		.src_axi_arready	({inst_axi_arready,dat_rom_axi_arready}), // Templated
		.src_axi_rdata		({inst_axi_rdata,dat_rom_axi_rdata}), // Templated
		.src_axi_rresp		({inst_axi_rresp,dat_rom_axi_rresp}), // Templated
		.src_axi_rvalid		({inst_axi_rvalid,dat_rom_axi_rvalid}), // Templated
		.dst_axi_arvalid	(rom_axi_arvalid),	 // Templated
		.dst_axi_araddr		(rom_axi_araddr),	 // Templated
		.dst_axi_rready		(rom_axi_rready),	 // Templated
		// Inputs
		.clk,
		.rst_n,
		.src_axi_araddr		({inst_axi_araddr,dat_rom_axi_araddr}), // Templated
		.src_axi_arvalid	({inst_axi_arvalid,dat_rom_axi_arvalid}), // Templated
		.src_axi_rready		({inst_axi_rready,dat_rom_axi_rready}), // Templated
		.dst_axi_arready	(rom_axi_arready),	 // Templated
		.dst_axi_rvalid		(rom_axi_rvalid),	 // Templated
		.dst_axi_rdata		(rom_axi_rdata),	 // Templated
		.dst_axi_rresp		(rom_axi_rresp));	 // Templated
   
   
   /*
    axil_rom AUTO_TEMPLATE (
    .axi_\(.*\) (rom_axi_\1),
    .mem_\(.*\) (rom_\1),
    .mem_ren    (),
    );
    */
   
   axil_rom
     u_rom_intf (/*AUTOINST*/
		 // Outputs
		 .axi_arready		(rom_axi_arready),	 // Templated
		 .axi_rdata		(rom_axi_rdata),	 // Templated
		 .axi_rresp		(rom_axi_rresp),	 // Templated
		 .axi_rvalid		(rom_axi_rvalid),	 // Templated
		 .mem_ren		(),			 // Templated
		 .mem_raddr		(rom_raddr),		 // Templated
		 // Inputs
		 .clk,
		 .rst_n,
		 .axi_araddr		(rom_axi_araddr),	 // Templated
		 .axi_arvalid		(rom_axi_arvalid),	 // Templated
		 .axi_rready		(rom_axi_rready),	 // Templated
		 .mem_rdata		(rom_rdata));		 // Templated

      
   /*
    rom AUTO_TEMPLATE (
    .dout (rom_rdata),
    .addr (rom_raddr[9:0]),
    );
    */
   
   rom
     u_rom (/*AUTOINST*/
	    // Outputs
	    .dout			(rom_rdata),		 // Templated
	    // Inputs
	    .clk,
	    .addr			(rom_raddr[9:0]));	 // Templated
   
   
   /*
    axil_dp_ram AUTO_TEMPLATE (
    .axi_\(.*\) (dat_ram_axi_\1),
    .mem_\(.*\) (ram_\1),
    
    );
    */
   
   axil_dp_ram
     u_ram_intf (/*AUTOINST*/
		 // Outputs
		 .axi_awready		(dat_ram_axi_awready),	 // Templated
		 .axi_wready		(dat_ram_axi_wready),	 // Templated
		 .axi_bresp		(dat_ram_axi_bresp),	 // Templated
		 .axi_bvalid		(dat_ram_axi_bvalid),	 // Templated
		 .axi_arready		(dat_ram_axi_arready),	 // Templated
		 .axi_rdata		(dat_ram_axi_rdata),	 // Templated
		 .axi_rresp		(dat_ram_axi_rresp),	 // Templated
		 .axi_rvalid		(dat_ram_axi_rvalid),	 // Templated
		 .mem_wen		(ram_wen),		 // Templated
		 .mem_wdata		(ram_wdata),		 // Templated
		 .mem_waddr		(ram_waddr),		 // Templated
		 .mem_ren		(ram_ren),		 // Templated
		 .mem_raddr		(ram_raddr),		 // Templated
		 // Inputs
		 .clk,
		 .rst_n,
		 .axi_awaddr		(dat_ram_axi_awaddr),	 // Templated
		 .axi_awvalid		(dat_ram_axi_awvalid),	 // Templated
		 .axi_wdata		(dat_ram_axi_wdata),	 // Templated
		 .axi_wstrb		(dat_ram_axi_wstrb),	 // Templated
		 .axi_wvalid		(dat_ram_axi_wvalid),	 // Templated
		 .axi_bready		(dat_ram_axi_bready),	 // Templated
		 .axi_araddr		(dat_ram_axi_araddr),	 // Templated
		 .axi_arvalid		(dat_ram_axi_arvalid),	 // Templated
		 .axi_rready		(dat_ram_axi_rready),	 // Templated
		 .mem_rdata		(ram_rdata));		 // Templated


   /*
    ram AUTO_TEMPLATE (
    .waddr (ram_waddr[11:0]),
    .wdata (ram_wdata),
    .wen   (ram_wen),
    .raddr (ram_raddr[11:0]),
    .rdata (ram_rdata),
    .ren   (ram_ren),    
    );
    */      
   
   ram
     u_ram (/*AUTOINST*/
	    // Outputs
	    .rdata			(ram_rdata),		 // Templated
	    // Inputs
	    .clk,
	    .waddr			(ram_waddr[11:0]),	 // Templated
	    .wen			(ram_wen),		 // Templated
	    .wdata			(ram_wdata),		 // Templated
	    .ren			(ram_ren),		 // Templated
	    .raddr			(ram_raddr[11:0]));	 // Templated
   
   
   
endmodule

// Local variables:
// verilog-library-directories:("." "../lib/.")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
