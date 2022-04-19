`ifndef ULTRA_CORE_AGENT_PKG__SV
`define ULTRA_CORE_AGENT_PKG__SV

  package ultra_core_agent_pkg;

    // Import UVM
    import uvm_pkg::*;
    import ultra_core_regs_pkg::*;
    import ultra_core_seq_pkg::*;
    `include "uvm_macros.svh"

    // Include Agent UVCs
    // `include "ultra_core_intf.sv"
    `include "ultra_core_agent_cfg.sv"
    `include "ultra_core_driver.sv"
    `include "ultra_core_monitor.sv"
    `include "ultra_core_sequencer.sv"
    `include "ultra_core_agent.sv"
  endpackage

`endif

//End of ultra_core_agent_pkg
