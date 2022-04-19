`ifndef ULTRA_CORE_SEQ_PKG__SV
`define ULTRA_CORE_SEQ_PKG__SV

  package ultra_core_seq_pkg;

    // Import UVM Macros and Package
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Include all sequence items and sequences
    `include "ultra_core_seq_item.sv"
    `include "ultra_core_base_seq.sv"
    `include "ultra_core_sanity_seq.sv"

  endpackage

`endif

//End of ultra_core_seq_pkg
