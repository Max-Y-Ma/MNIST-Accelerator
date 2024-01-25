// Sequence Items for Test Stimulus of MNIST Accelerator Core
class core_img_item extends uvm_sequence_item;
    `uvm_object_utils(core_img_item)

    rand bit [`DATA_WIDTH-1:0] img [`IMG_WIDTH * `IMG_HEIGHT];
    rand bit [3:0] label;

    function new(string name = "");
        super.new(name);
    endfunction : new

    virtual function void do_copy(uvm_object rhs);
        // Copy argument data to current object
        core_img_item RHS;
        if (!$cast(RHS, rhs)) begin
            uvm_report_error("do_copy:", "Cast Failed");
            return;
        end
        super.do_copy(rhs);
        img = RHS.img;
        label = RHS.label;
    endfunction : do_copy

    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        // Compare argument data with current object
        core_img_item RHS;
        if (!$cast(RHS, rhs)) begin
            uvm_report_error("do_compare:", "Cast Failed");
            return 0;
        end
        return (super.do_compare(rhs, comparer) && (img == RHS.img) && 
            (label == RHS.label));
    endfunction : do_compare

    virtual function string convert2string();
        // Stringify current object
        string s;
        s = super.convert2string();
        s = {s, $sformatf("img = %p, label = %d", img, label)};
        return s;
    endfunction : convert2string

    virtual function bit load_image(string image_line);
        // Load Label
        if (!$sscanf(image_line, "%d%s", label, image_line)) begin
            uvm_report_fatal("load_image:", "Label not found");
            return 0;
        end

        // Load Image Data
        for (int i = 0; i < `IMG_WIDTH * `IMG_HEIGHT; i++) begin
            if (!$sscanf(image_line, ",%d%s", img[i][`DATA_WIDTH-1 -: `INTEGER_WIDTH], image_line)) begin
                uvm_report_fatal("load_image:", "Image data not found");
                return 0;
            end
        end

        // Image Loaded Successfully
        return 1;
    endfunction : load_image
endclass : core_img_item