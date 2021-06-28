`ifndef ULTRA_CORE_AGENT_CFG__SV
`define ULTRA_CORE_AGENT_CFG__SV

  class ultra_core_agent_cfg extends uvm_object;

    // Factory Registration
    `uvm_object_utils(ultra_core_agent_cfg)

    // UVM Agent Controls

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // Tasks and Functions

    extern function new(string name = "ultra_core_agent_cfg");

  endclass

  function ultra_core_agent_cfg::new(string name = "ultra_core_agent_cfg");
    super.new(name);
  endfunction

`endif

//End of ultra_core_agent_cfg
