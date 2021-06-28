`ifndef ULTRA_CORE_SANITY_TEST__SV
`define ULTRA_CORE_SANITY_TEST__SV

  class ultra_core_sanity_test extends ultra_core_base_test;

    // Factory Registration
    `uvm_component_utils(ultra_core_sanity_test)

    // Sequence to start
    ultra_core_sanity_seq seqh;

    extern function new(string name = "ultra_core_sanity_test", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
  endclass

  function ultra_core_sanity_test::new(string name = "ultra_core_sanity_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void ultra_core_sanity_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void ultra_core_sanity_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task ultra_core_sanity_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_full_name(), "[ultra_core] Starting sanity Test", UVM_NONE)
    seqh = ultra_core_sanity_seq::type_id::create("seqh");
    seqh.start(envh.agnth.seqrh);
    phase.drop_objection(this);
  endtask

  function void ultra_core_sanity_test::report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction

`endif

//End of ultra_core_sanity_test
