module mio
  /* verilator lint_off VARHIDDEN */  
  #(parameter CLK_HZ       = 100000000,
    parameter BIT_RATE     = 115200,
    parameter PAYLOAD_BITS = 8)
   /* verilator lint_on VARHIDDEN */      
   (
    input 	 clk, 
    input 	 rst_n,

    //uart interface
    input 	 iob__mio_val,
    input 	 iob__mio_port,
    input [31:0] iob__mio_wdata,
    output 	 mio__iob_done,

    output 	 uart_txd,
    output [3:0] gpio_out
    );
   
   localparam PORT_GPIO = 0;
   localparam PORT_UART = 1;      
   
   typedef enum  logic {
			MIO_IDLE  = 1'b0,
			MIO_WAIT  = 1'b1
			} mio_fsm_t;

   mio_fsm_t mio_state,nxt_mio_state;
   logic [PAYLOAD_BITS-1:0] uart_tx_data;    
   logic 		    mio_wr_done,uart_tx_en;   
   logic [3:0] 		    gpio_reg;   

   always @ (posedge clk)
     if (!rst_n) mio_state <= MIO_IDLE;	
     else        mio_state <= nxt_mio_state;   
   
   
   always_comb begin
      nxt_mio_state = mio_state;
      mio_wr_done   = '0;      
      
      case(mio_state)
	MIO_IDLE : begin
	   nxt_mio_state = (iob__mio_val && (iob__mio_port == PORT_UART)) ? MIO_WAIT : MIO_IDLE;
	   mio_wr_done  = (iob__mio_val && (iob__mio_port == PORT_GPIO));	   
	end
	MIO_WAIT : begin
	   nxt_mio_state = uart_tx_done ? MIO_IDLE : MIO_WAIT;
	   mio_wr_done   = uart_tx_done;	   
	end
      endcase
   end
   
   assign mio__iob_done = mio_wr_done;   

   //-------------------------------------------------------------
   // UART FIFO
   //-------------------------------------------------------------         

   assign uart_tx_en   = iob__mio_val && (iob__mio_port == PORT_UART);   
   assign uart_tx_data = iob__mio_wdata[PAYLOAD_BITS-1:0];
   
   uart_tx #(
	     .BIT_RATE     (BIT_RATE),
	     .PAYLOAD_BITS (PAYLOAD_BITS),
	     .CLK_HZ       (CLK_HZ)
	     ) uart_tx
     (
      .clk          (clk          ),
      .rst_n        (rst_n        ),
      .uart_txd     (uart_txd     ),
      .uart_tx_en   (uart_tx_en   ),
      .uart_tx_done (uart_tx_done ),
      .uart_tx_data (uart_tx_data ) 
      );


   //-------------------------------------------------------------
   // GPIO OUT
   //-------------------------------------------------------------         

   always @(posedge clk) begin
      if(!rst_n) 
	gpio_reg <= 4'h0;
      else if(iob__mio_val && (iob__mio_port == PORT_GPIO))    
	gpio_reg <= iob__mio_wdata[3:0];
   end
   
   assign gpio_out = gpio_reg;   

   
endmodule
