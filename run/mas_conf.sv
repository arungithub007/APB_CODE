class apb_mas_conf extends uvm_object;
  `uvm_object_utils(apb_mas_conf)

int no_of_slave=1;
int no_of_master=1;
bit insert_wait_cycle;
int no_of_wait_cycle=1;


function new(string name="apb_mas_conf");
   super.new(name);
endfunction:new

//to make agent active or passive
uvm_active_passive_enum active = UVM_ACTIVE;

endclass:apb_mas_conf
