`ifndef ULTRA_CORE_BASE_TEST__SV
`define ULTRA_CORE_BASE_TEST__SV

  class ultra_core_base_test extends uvm_test;

    // Factory Registration
    `uvm_component_utils(ultra_core_base_test)

    // Declare UVC
    ultra_core_env envh;

    extern function new(string name = "ultra_core_base_test", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
  endclass

  function ultra_core_base_test::new(string name = "ultra_core_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void ultra_core_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    envh = ultra_core_env::type_id::create("envh", this);
  endfunction

  function void ultra_core_base_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task ultra_core_base_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_full_name(), "[ultra_core] Starting Base Test", UVM_NONE)
    phase.drop_objection(this);
  endtask

  function void ultra_core_base_test::report_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

`endif

//End of ultra_core_base_test
