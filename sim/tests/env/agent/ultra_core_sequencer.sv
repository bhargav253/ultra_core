`ifndef ULTRA_CORE_SEQUENCER__SV
`define ULTRA_CORE_SEQUENCER__SV

  class ultra_core_sequencer extends uvm_sequencer#(ultra_core_seq_item);

    // Factory Registration
    `uvm_component_utils(ultra_core_sequencer)

    // Tasks and Functions
    extern function new(string name = "ultra_core_sequencer", uvm_component parent = null);
  endclass

  function ultra_core_sequencer::new(string name = "ultra_core_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

`endif

//End of ultra_core_sequencer
