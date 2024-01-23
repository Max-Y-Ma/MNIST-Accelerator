// Agent, Sequencer, Driver, Monitor Classes for Test Environment of MNIST Accelerator Core
class core_agent extends uvm_agent;
endclass : core_agent

typedef uvm_sequencer #(core_img_item) core_sequencer;

class core_sequence extends uvm_sequence #(core_img_item);
endclass : core_sequence

class core_driver extends uvm_driver #(core_img_item);

endclass : core_driver

class core_monitor extends uvm_monitor;
endclass : core_monitor