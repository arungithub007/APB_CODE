//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//UVM sequences are made up of several data items which can be put together in different ways to create interesting scenarios. 
//They are executed by an assigned sequencer which then sends data items to the driver.
//Hence, sequences make up the core stimuli of any verification plan.
//
//===>my_sequence is inherited from uvm_sequence
//===>It is registered with the factory using `uvm_object_utils because it is a transaction item
//===>The main stimulus is written within the body() task, while pre_body() and post_body() are useful callbacks to be used if required
//===>A data packet is created and sent for execution using `uvm_do macro
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class apb_mas_sequence extends uvm_sequence#(apb_seq_item);
 //apb_seq_item req; 
  `uvm_object_utils(apb_mas_sequence)
 
  function new(string name="apb_mas_sequence");
    super.new(name);
  endfunction:new


 task body();
	//  req = apb_seq_item::type_id::create("req");
	//	repeat(5) `uvm_do_with(req ,{req.pwrite==1'b1;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h17; req.pwdata == 8'h11;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1b; req.pwdata == 8'h22;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h19; req.pwdata == 8'h33;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1c; req.pwdata == 8'h44;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h17;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 6'h1b;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h19;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h1c;})
 endtask:body

//here we are taking randomization instead mannual
/*
  task body();
 // `uvm_do(req);
  repeat(4)
  begin
    req = apb_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize());
  //  req.print();
    finish_item(req);
    end 
  endtask
*/

endclass:apb_mas_sequence


///////////////////////// write only sequence test1 ///////////////////
class apb_mas_sequence1 extends uvm_sequence#(apb_seq_item);
 //apb_seq_item req; 
  `uvm_object_utils(apb_mas_sequence1)
 
  function new(string name="apb_mas_sequence1");
    super.new(name);
  endfunction:new


 task body();
	//  req = apb_seq_item::type_id::create("req");
	//	repeat(5) `uvm_do_with(req ,{req.pwrite==1'b1;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h17; req.pwdata == 8'h11;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1b; req.pwdata == 8'h22;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h19; req.pwdata == 8'h33;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1c; req.pwdata == 8'h44;})
 endtask:body

endclass:apb_mas_sequence1







//////////////////////////// read only test2 ////////////////////////////
class apb_mas_sequence2 extends uvm_sequence#(apb_seq_item);
 //apb_seq_item req; 
  `uvm_object_utils(apb_mas_sequence2)
 
  function new(string name="apb_mas_sequence2");
    super.new(name);
  endfunction:new


 task body();
 ///  req = apb_seq_item::type_id::create("req");
	repeat(5)
    `uvm_do_with(req, {req.pwrite==1'b0;})
//	`uvm_do(req)
 endtask:body

endclass:apb_mas_sequence2


///////////////////////////write fallowed by read  test3 /////////////////////////

class apb_mas_sequence3 extends uvm_sequence#(apb_seq_item);
	`uvm_object_utils(apb_mas_sequence3)

	//constructor function
	function new(string name="apb_mas_sequence3");
		super.new(name);
	endfunction:new

	task body();
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h17; req.pwdata == 8'h11;})	
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h17;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1b; req.pwdata == 8'h22;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h1b;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h19; req.pwdata == 8'h33;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h19;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1c; req.pwdata == 8'h44;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h1c;})
	endtask:body                            
endclass:apb_mas_sequence3





/////////////////////////////// randome write read testname=rnd_wrt_rd test4 /////////////////////////

//here we are taking randomization instead mannual

class apb_mas_sequence4 extends uvm_sequence#(apb_seq_item);
	`uvm_object_utils(apb_mas_sequence4)

	//constructor function
	function new(string name="apb_mas_sequence4");
		super.new(name);
	endfunction:new
/*
virtual task body();
 repeat(4)

  `uvm_do(req)
endtask:body 
*/  

task body();
  repeat(5)begin
	  req = apb_seq_item::type_id::create("req");

       start_item(req);
       req.randomize();
  //  req.print();
    finish_item(req);
    end  
  endtask
  
endclass:apb_mas_sequence4 



/////////////////////// write read with wait states tetst5 ///////////////////////

class apb_mas_sequence5 extends uvm_sequence#(apb_seq_item);
	`uvm_object_utils(apb_mas_sequence5)

	//constructor function
	function new(string name="apb_mas_sequence5");
		super.new(name);
	endfunction:new

    task body();
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h17; req.pwdata == 8'h11;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1b; req.pwdata == 8'h22;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h19; req.pwdata == 8'h33;})
	`uvm_do_with(req, { req.pwrite == 1'b1;	req.paddr == 8'h1c; req.pwdata == 8'h44;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h17;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 6'h1b;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h19;})
	`uvm_do_with(req, { req.pwrite == 1'b0;	req.paddr == 8'h1c;})
endtask:body
endclass:apb_mas_sequence5

