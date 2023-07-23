/////////////////////////////////////////////////////////////////////////////////////////////
// 
// Testcase is a pattern to check and verify specific features and functionalities of a design.
// A verification plan lists all the features and other functional items that needs to be verified, and the tests neeeded to cover each of them.
//
// where we want to hold the simulation for a specific time, it is mandatory that you raise and drop an objection
/////////////////////////////////////////////////////////////////////////////////////////////

class apb_test extends uvm_test;   //base test
  `uvm_component_utils(apb_test)

   apb_mas_conf m_conf;
   apb_env env;
   apb_mas_sequence seq;
  virtual  apb_intf vif;

  bit[0:31] i,j;

/*    //conf file insert_wait_cycle state on=1,off=0
  bit insert_wait_cycle=1'b1;

  //conf file for number of wait cycle
  int num_wait_cycle=2;

//call the below funtion in the buildphase of child classes of apb_test(base test)

 virtual function flag();
      m_conf=new();
      m_conf.insert_wait_cycle=insert_wait_cycle;
      m_conf.num_wait_cycle=num_wait_cycle;
  endfunction:flag

*/

//constuctor function
 function new(string name = "apb_test",uvm_component parent=null);
    super.new(name,parent);
 endfunction:new

 //buid phase
 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  m_conf=apb_mas_conf::type_id::create("m_conf",this);
  env = apb_env::type_id::create("env", this);
  seq = apb_mas_sequence::type_id::create("seq",this);
 
  if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))begin
      `uvm_fatal("NO_VIF",{" virtual interface must be set for:",get_full_name(),".vif"});
  end

  //setting mas_conf in buid phase of the base test
 uvm_config_db#(apb_mas_conf)::set(null,"*","apb_mas_conf",m_conf);
 endfunction : build_phase

 function void end_of_elaboration_phase(uvm_phase phase);
     super.end_of_elaboration_phase(phase);
     uvm_top.print_topology();
 endfunction:end_of_elaboration_phase
  


 //////////////////////////////////////////////////////////////////////////
 //
 //run phase:=
 //where we want to hold the simulation for a specific time, it is mandatory that you raise and drop an objecton
 //
 //////////////////////////////////////////////////////////////////////////
   task run_phase(uvm_phase phase);
	   phase.raise_objection(this);
	   seq.start(env.agnt1[0].mas_sequencer);  //to start a sequnce in a agent we need to take the sequence name start from the accecing the sequencer handle from agent 
   #50;
    phase.drop_objection(this);
    
   endtask : run_phase
  
 endclass :apb_test


 /*
 
Create a test cases 

1. Write only 
2.read only 
3. Write followed by Read ( WR WR WR WR) 
4.random write and reads ( WRWWWRRWW )
5.write with wait states 
6.Write Read with wiar states.
			
*/


////////////////////////  write only  test1 ////////////////////////

class wrt_only extends uvm_test;   //write only extends from apb_test i.e.,base test
  `uvm_component_utils(wrt_only)

   apb_mas_conf m_conf;
   apb_env env;
   apb_mas_sequence1 seq1;

//constuctor function
 function new(string name = "wrt_only",uvm_component parent=null);
    super.new(name,parent);
 endfunction:new

 //buid phase
 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  m_conf=apb_mas_conf::type_id::create("m_conf",this);
  env = apb_env::type_id::create("env", this);
  seq1 = apb_mas_sequence1::type_id::create("seq1",this);
 
  //setting mas_conf in buid phase of the base test
uvm_config_db#(apb_mas_conf)::set(null,"*","apb_mas_conf",m_conf);
 endfunction : build_phase
  
 //run phase
   task run_phase(uvm_phase phase);
	   phase.raise_objection(this);
	   seq1.start(env.agnt1[0].mas_sequencer);
   #50;
    phase.drop_objection(this);
    
   endtask : run_phase
  
 endclass :wrt_only









/////////////// read only test2 /////////////////
//
// "$root" is a SystemVerilog construct representing the top of the static elaborated module/interface hierarchy.
// This hierarchy gets constructed as part of elaboration stage of the compiler and executes before any simulation starts running.
//
/////////////////////////////////////////////////
class rd_only extends apb_test;   //read only extends from uvm_test
  `uvm_component_utils(rd_only)
   apb_mas_conf m_conf;
   apb_mas_sequence2 seq2;

//constuctor function
 function new(string name = "wrt_only",uvm_component parent=null);
    super.new(name,parent);
 endfunction:new

 //buid phase
 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  m_conf=apb_mas_conf::type_id::create("m_conf",this);
  seq2 = apb_mas_sequence2::type_id::create("seq2",this);
 
  //setting mas_conf in buid phase of the base test
uvm_config_db#(apb_mas_conf)::set(null,"*","apb_mas_conf",m_conf);
 endfunction : build_phase
  
 //run phase
   task run_phase(uvm_phase phase);
	   phase.raise_objection(this);
       for(i=0,j=255;i<255;i++,j--)
         $root.tb_top.dut.mem[i]=j;
	   seq2.start(env.agnt1[0].mas_sequencer);
   #50;
    phase.drop_objection(this);
    
   endtask : run_phase
  
 endclass :rd_only







/////////////////  Write followed by Read ( WR WR WR WR) testname=wrt_fldb_rd test3 ///////////////////


class wrt_fldb_rd extends uvm_test;   //read only extends from uvm_test
  `uvm_component_utils(wrt_fldb_rd)

   apb_mas_conf m_conf;
   apb_env env;
   apb_mas_sequence3 seq3;

//constuctor function
 function new(string name = "wrt_fldb_rd",uvm_component parent=null);
    super.new(name,parent);
 endfunction:new

 //buid phase
 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  m_conf=apb_mas_conf::type_id::create("m_conf",this);
  env = apb_env::type_id::create("env", this);
  seq3 = apb_mas_sequence3::type_id::create("seq3",this);
 
  //setting mas_conf in buid phase of the base test
uvm_config_db#(apb_mas_conf)::set(null,"*","apb_mas_conf",m_conf);
 endfunction : build_phase
  
 //run phase
   task run_phase(uvm_phase phase);
	   phase.raise_objection(this);
	   seq3.start(env.agnt1[0].mas_sequencer);
   #50;
    phase.drop_objection(this);
    
   endtask : run_phase
  
 endclass :wrt_fldb_rd










///////////////////// random write and reads ( WRWWWRRWW ) rnd_wrt_rd test4///////////////////

class rnd_wrt_rd extends uvm_test;   //read only extends from uvm_test
  `uvm_component_utils(rnd_wrt_rd)

   apb_mas_conf m_conf;
   apb_env env;
   apb_mas_sequence4 seq4;

//constuctor function
 function new(string name = "rnd_wrt_rd",uvm_component parent=null);
    super.new(name,parent);
 endfunction:new

 //buid phase
 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  m_conf=apb_mas_conf::type_id::create("m_conf",this);
  env = apb_env::type_id::create("env", this);
  seq4 = apb_mas_sequence4::type_id::create("seq4",this);
 
  //setting mas_conf in buid phase of the base test
uvm_config_db#(apb_mas_conf)::set(null,"*","apb_mas_conf",m_conf);
 endfunction : build_phase
  
 //run phase
   task run_phase(uvm_phase phase);
	   phase.raise_objection(this);
	   seq4.start(env.agnt1[0].mas_sequencer);
   #50;
       phase.drop_objection(this);
    
   endtask : run_phase
  
 endclass :rnd_wrt_rd







/////////////////////// write read with wait states tetst5 run_test("wrt_rd_wit_st"); ///////////////////////

class wrt_rd_wit_st extends uvm_test;   //base test
  `uvm_component_utils(wrt_rd_wit_st)

   apb_mas_conf m_conf;
   apb_env env;
   apb_mas_sequence5 seq5;
virtual apb_intf vif;



function void conff();
  //conf file insert_wait_cycle state on=1,off=0
  bit insert_wait_cycle=1'b1;

  //conf file for number of wait cycle
  int num_wait_cycle=2;
 
      m_conf=new();
      m_conf.insert_wait_cycle=insert_wait_cycle;
      m_conf.num_wait_cycle=num_wait_cycle;
  endfunction:conff 
      
       task wait_state();
    //incertiing wiat state in read data
          @(posedge vif.clk);

        if (m_conf.insert_wait_cycle) begin
           repeat (m_conf.num_wait_cycle);
        begin 
        // force the wait state  @(posedge vif.clk);
            force tb_top.dut.pready=0;
        end
           @(posedge vif.clk);
            release tb_top.dut.pready;
        end
  
    endtask:wait_state


//constuctor function
 function new(string name = "wrt_rd_wit_st",uvm_component parent=null);
    super.new(name,parent);
 endfunction:new

 //buid phase
 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  m_conf=apb_mas_conf::type_id::create("m_conf",this);
  env = apb_env::type_id::create("env", this);
  seq5 = apb_mas_sequence5::type_id::create("seq5",this);
  conff();
  //get  virtual interface 
  if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))begin
      `uvm_fatal("NO_VIF",{" virtual interface must be set for:",get_full_name(),".vif"});
  end

  //setting mas_conf in buid phase of the base test
  uvm_config_db#(apb_mas_conf)::set(null,"*","apb_mas_conf",m_conf);
  endfunction : build_phase

 
  
 //run phase
   task run_phase(uvm_phase phase);
     
	  phase.raise_objection(this);
     fork
     #20 wait_state();
      seq5.start(env.agnt1[0].mas_sequencer);
      #50;
     join 
      phase.drop_objection(this);
     
    
   endtask : run_phase
  
 endclass :wrt_rd_wit_st








///////////////////////// Write with wiat states ////////////////////////////




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//notes:=
//So this is how you hold the simulator.

//the next question is you have a multiple component.
//
//So each of the component could add the trees and drop objection.
//
//And then simulator will automatically count the number of objections that are raised.
//
//And once all of the objections are dropped similarly to will exit, right.
//
//So usually we do not add the objection in all of a component that exist in our environment instead.
//
//We use the reason drop objection in a sequences.
//
//So as we proceed to the sequence section, we'll be understanding more on this.
//
//Right.
//
//But something that you could take away from this is whenever you want to hold your simulator for the
//
//specific time, time could be anything.
//
//Then it is mandatory that you need to raise an objection, complete your task, specify the time for
//
//which you want to execute the task, and then you drop an objection.
//
//So this allow an entire process to complete as expected.
//
//information
