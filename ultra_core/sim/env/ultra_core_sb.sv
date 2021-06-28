`ifndef ULTRA_CORE_SB__SV
`define ULTRA_CORE_SB__SV

  class ultra_core_sb extends uvm_scoreboard;

    // Factory Registration
    `uvm_component_utils(ultra_core_sb)

    // Analysis Fifo
    uvm_tlm_analysis_fifo #(ultra_core_seq_item) sb_fifo;

    // Data Item
    ultra_core_seq_item seq_item;

    // Tasks and Functions
    extern function new(string name = "ultra_core_sb", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
  endclass

  function ultra_core_sb::new(string name = "ultra_core_sb", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void ultra_core_sb::build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_fifo = new("sb_fifo", this);
  endfunction

  task ultra_core_sb::run_phase(uvm_phase phase);
    forever begin
      sb_fifo.get(seq_item);
      `uvm_info(get_full_name(), "[ULTRA_CORE] Received new item in SB", UVM_LOW)
      `uvm_info(get_full_name(), $sformatf("\n[ULTRA_CORE] Packet Data:\n\twe: %0d,\n\taddr: %0d,\n\twdata: %0d,\n\trdata: %0d", 
      seq_item.we, seq_item.addr, seq_item.wdata, seq_item.rdata), UVM_LOW) 
    end
  endtask

`endif

//End of ultra_core_sb
