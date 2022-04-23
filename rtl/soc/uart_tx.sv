// 
// Module: uart_tx 
// 
// Notes:
// - UART transmitter module.
//

module uart_tx
  #(parameter CLK_HZ       = 100000000,
    parameter BIT_RATE     = 115200,
    parameter PAYLOAD_BITS = 8)  
   (
    input wire 			  clk , 
    input wire 			  rst_n , 
    output wire 		  uart_txd ,
    output wire 		  uart_tx_done, 
    input wire 			  uart_tx_en ,
    input wire [PAYLOAD_BITS-1:0] uart_tx_data 
    );
   
   // Input bit rate of the UART line.
   //parameter   BIT_RATE        = 9600; // bits / sec
   localparam  BIT_P           = 1_000_000_000 * 1/BIT_RATE; // nanoseconds
   
   // Clock frequency in hertz.
   //parameter   CLK_HZ          =    50_000_000;
   localparam  CLK_P           = 1_000_000_000 * 1/CLK_HZ; // nanoseconds

   // Number of data bits recieved per UART packet.
   //parameter   PAYLOAD_BITS    = 8;

   // Number of stop bits indicating the end of a packet.
   parameter   STOP_BITS       = 1;

   // Number of clock cycles per uart bit.
   //localparam       CYCLES_PER_BIT     = BIT_P / CLK_P;
   localparam       CYCLES_PER_BIT = 8;   // FIXME
   
   // Size of the registers which store sample counts and bit durations.
   localparam       COUNT_REG_LEN      = 1+$clog2(CYCLES_PER_BIT);
   
   // Internally latched value of the uart_txd line. Helps break long timing
   // paths from the logic to the output pins.
   reg 				  txd_reg;
   // Storage for the serial data to be sent.
   reg [PAYLOAD_BITS-1:0] 	  data_to_send;
   // Counter for the number of cycles over a packet bit.
   reg [COUNT_REG_LEN-1:0] 	  cycle_counter;
   // Counter for the number of sent bits of the packet.
   reg [3:0] 			  bit_counter;
   
   typedef enum 		  logic [1:0] {
					       FSM_IDLE  = 2'd0,
					       FSM_START = 2'd1,
					       FSM_SEND  = 2'd2,
					       FSM_STOP  = 2'd3
					       } uart_fsm_t;

   // Current and next states of the internal FSM.
   uart_fsm_t 				     fsm_state,n_fsm_state;

   wire 			  next_bit     = cycle_counter == CYCLES_PER_BIT;
   wire 			  payload_done = bit_counter   == PAYLOAD_BITS  ;
   wire 			  stop_done    = bit_counter   == STOP_BITS && fsm_state == FSM_STOP;

   assign uart_tx_done = (fsm_state == FSM_STOP) && stop_done;
   assign uart_txd     = txd_reg;
   
   //
   // Handle picking the next state.
   always @(*) begin : p_n_fsm_state
      case(fsm_state)
        FSM_IDLE : n_fsm_state = uart_tx_en   ? FSM_START: FSM_IDLE ;
        FSM_START: n_fsm_state = next_bit     ? FSM_SEND : FSM_START;
        FSM_SEND : n_fsm_state = payload_done ? FSM_STOP : FSM_SEND ;
        FSM_STOP : n_fsm_state = stop_done    ? FSM_IDLE : FSM_STOP ;
        default  : n_fsm_state = FSM_IDLE;
      endcase
   end

   // Handle updates to the sent data register.
   integer i = 0;
   always @(posedge clk) begin : p_data_to_send
      if(!rst_n) begin
         data_to_send <= {PAYLOAD_BITS{1'b0}};
   end else if(fsm_state == FSM_IDLE && uart_tx_en) begin
      data_to_send <= uart_tx_data;
   end else if(fsm_state       == FSM_SEND       && next_bit ) begin
      for ( i = PAYLOAD_BITS-2; i >= 0; i = i - 1) begin
         data_to_send[i] <= data_to_send[i+1];
      end
   end
   end

   // Increments the bit counter each time a new bit frame is sent.
   always @(posedge clk) begin : p_bit_counter
      if(!rst_n) begin
         bit_counter <= 4'b0;
      end else if(fsm_state != FSM_SEND && fsm_state != FSM_STOP) begin
         bit_counter <= {COUNT_REG_LEN{1'b0}};
	    end else if(fsm_state == FSM_SEND && n_fsm_state == FSM_STOP) begin
               bit_counter <= {COUNT_REG_LEN{1'b0}};
		  end else if(fsm_state == FSM_STOP&& next_bit) begin
		     bit_counter <= bit_counter + 1'b1;
		  end else if(fsm_state == FSM_SEND && next_bit) begin
		     bit_counter <= bit_counter + 1'b1;
		  end
   end


   //
   // Increments the cycle counter when sending.
   always @(posedge clk) begin : p_cycle_counter
      if(!rst_n) begin
         cycle_counter <= {COUNT_REG_LEN{1'b0}};
   end else if(next_bit) begin
      cycle_counter <= {COUNT_REG_LEN{1'b0}};
	 end else if(fsm_state == FSM_START || 
                     fsm_state == FSM_SEND  || 
                     fsm_state == FSM_STOP   ) begin
            cycle_counter <= cycle_counter + 1'b1;
	 end
   end


   //
   // Progresses the next FSM state.
   always @(posedge clk) begin : p_fsm_state
      if(!rst_n) begin
         fsm_state <= FSM_IDLE;
      end else begin
         fsm_state <= n_fsm_state;
      end
   end


   //
   // Responsible for updating the internal value of the txd_reg.
   always @(posedge clk) begin : p_txd_reg
      if(!rst_n) begin
         txd_reg <= 1'b1;
      end else if(fsm_state == FSM_IDLE) begin
         txd_reg <= 1'b1;
      end else if(fsm_state == FSM_START) begin
         txd_reg <= 1'b0;
      end else if(fsm_state == FSM_SEND) begin
         txd_reg <= data_to_send[0];
      end else if(fsm_state == FSM_STOP) begin
         txd_reg <= 1'b1;
      end
   end

endmodule
