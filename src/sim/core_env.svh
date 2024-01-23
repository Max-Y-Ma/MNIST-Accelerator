// Environment Class for MNIST Accelerator Core
class core_env extends uvm_env;
    `uvm_component_utils(core_env)


endclass : core_env

class core_scoreboard extends uvm_scoreboard;
endclass : core_scoreboard

// Coverage
class core_subscriber extends uvm_subscriber;
endclass : core_subscriber