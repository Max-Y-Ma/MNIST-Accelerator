// Sequence Items for Test Stimulus of MNIST Accelerator Core
`define IMG_WIDTH 28
`define IMG_HEIGHT 28  

class core_img_item extends uvm_sequence_item;
    `uvm_object_utils(core_img_item)

    rand bit [7:0] img [`IMG_WIDTH * `IMG_HEIGHT];
    rand bit [3:0] label;

    function new(string name = "");
        super.new(name);
    endfunction : new

    virtual function void do_copy(uvm_object rhs);
    endfunction : do_copy

    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    endfunction : do_compare

    virtual function string convert2string();
    endfunction : convert2string

    virtual function void load_image(string file_name);
    endfunction : load_image
endclass : core_img_item