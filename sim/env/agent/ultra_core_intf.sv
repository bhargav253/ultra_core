`ifndef ULTRA_CORE_INTF__SV
`define ULTRA_CORE_INTF__SV

  interface ultra_core_intf(input clk);

    // Signals
    logic we;
    logic [3:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;
    
  endinterface

`endif

//End of ultra_core_intf
