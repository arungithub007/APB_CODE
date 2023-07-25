/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// All verification components, interfaces and DUT are instantiated in a TOPLEVEL module called TESTBENCH(module tb_top). 
// It is a static container to hold everything required to be simulated and becomes the ROOT node in the Heirachy
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////



	//`include "design.v"               "following is the include heirarchy 
      `include "uvm_macros.svh"         //include uvm_macros.svh
        `include "interface.sv"         //interface
         import uvm_pkg::*;             //import uvm_pkg
        `include "m_conf.sv"            //configuration file 
        `include "m_seq_item.sv"        //Seq_item
	    `include "m_sequence.sv"        //sequence
        `include "m_sequencer_t.sv"     //seqencer
	    `include "m_driver.sv"          //driver
        `include "m_monitor.sv"         //monitor
	    `include "m_agent.sv"           //agent
	    `include "scoreboard.sv"        //scoreboard
	    `include "env.sv"               //environment
        `include "test.sv"              //base test

	

module tb_top;
reg clk, rst_n;

  apb_slave dut(
    .clk(intf.clk),
    .rst_n(intf.rst_n),
    .paddr(intf.paddr),
    .pwrite(intf.pwrite),
    .psel(intf.psel),
    .penable(intf.penable),
    .pready(intf.pready),
    .pwdata(intf.pwdata),
    .prdata(intf.prdata)); //dut instantation

  apb_intf intf(clk, rst_n); //interface handle
  
  initial begin
	  clk=0;
	  forever #5 clk=~clk;
  end

  initial begin
	rst_n = 0;
   	repeat(2) @(posedge clk)
	rst_n=1;
end


/*

Create a test cases 

1. Write only 
2.read only 
3. Write followed by Read ( WR WR WR WR) 
4.random write and reads ( WRWWWRRWW )
5.write with wait states 
6.Write Read with wiar states.
			
*/


  initial begin

	uvm_config_db#(virtual apb_intf)::set(null,"*","vif",intf);  //config db set_up
    
       force $root.tb_top.dut.pready=0;

    run_test("apb_test"); 	// make test
	  
 //	  run_test("wrt_only"); 	// make test1
 //	  run_test("rd_only");  	// make test2
  //  run_test("wrt_fldb_rd"); 	// make test3
 //	  run_test("rnd_wrt_rd");  	// make {rand} test4 
 //	 run_test("wrt_rd_wit_st"); // make {wait} test5
 //	 run_test("wrt_wit_st");    // make {wait} teat6
    
     // run_test();
  end
endmodule
 
