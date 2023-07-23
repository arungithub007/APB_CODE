class apb_mas_conf extends uvm_object;

//vertual interface handle declaration
virtual apb_intf      vif; 


//declaretion of the variables and fields needed
int no_slave=0;
int no_master=1;
bit insert_wait_cycle;//triggering point on or off
int num_wait_cycle;   //wait cycle to be incerted


`uvm_object_utils_begin(apb_mas_conf)
`uvm_field_int(no_slave,UVM_ALL_ON)
`uvm_field_int(no_master,UVM_ALL_ON)
`uvm_field_int(insert_wait_cycle,UVM_ALL_ON)
`uvm_field_int(num_wait_cycle,UVM_ALL_ON)
`uvm_object_utils_end



uvm_active_passive_enum active=UVM_ACTIVE;

//constructor function
function new(string  name="apb_mas_conf");
super.new(name);
endfunction:new

endclass:apb_mas_conf
