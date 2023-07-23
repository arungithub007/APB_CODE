class apb_mas_sequencer extends uvm_sequencer#(apb_seq_item);
	`uvm_component_utils(apb_mas_sequencer)

	//constructor function
	function new (string name="apb_mas_sequencer",uvm_component parent=null);
		super.new(name,parent);
	endfunction:new
endclass:apb_mas_sequencer
