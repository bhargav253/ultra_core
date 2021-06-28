`ifndef ULTRA_CORE_TEST_PKG__SV
`define ULTRA_CORE_TEST_PKG__SV

  package ultra_core_test_pkg;

    // Import UVM
    import uvm_pkg::*;
    import ultra_core_seq_pkg::*;
    import ultra_core_regs_pkg::*;
    import ultra_core_agent_pkg::*;
    import ultra_core_env_pkg::*;
    `include "uvm_macros.svh"

    // Import UVC
    `include "ultra_core_base_test.sv"
    `include "ultra_core_sanity_test.sv"

  endpackage

`endif

//End of ultra_core_test_pkg
