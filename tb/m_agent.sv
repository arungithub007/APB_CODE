
class apb_mas_agnt extends uvm_agent;
`uvm_component_utils(apb_mas_agnt)
  
  apb_mas_sequencer mas_sequencer;
  apb_mas_driver drv;
  apb_mas_monitor mon;
  apb_mas_conf m_conf;		//master config file handle
  

  //constructor function
  function new (string  name,uvm_component parent);
    super.new(name,parent);
  endfunction:new

  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //buid 'driver' and 'seqencer' if "agent" is active 
    if(get_is_active()==UVM_ACTIVE)begin
          
	  //build sequencer hndle
	  mas_sequencer=apb_mas_sequencer::type_id::create("mas_sequencer",this);
          
	  //buid driver hndle
	  drv=apb_mas_driver::type_id::create("drv",this);
      end
    
     //buid monitor
      mon=apb_mas_monitor::type_id::create("mon",this);
	
      //get agent config from uvm_config_db
      if(!uvm_config_db#(apb_mas_conf)::get(this,"","apb_mas_conf",m_conf))begin 
	`uvm_fatal("mas_config not found",$sformatf("EORROR:: unable to retrieve apb_mas_conf from uvm_config_db"))
	end


  endfunction:build_phase
  
  // connect_phase
  function void connect_phase(uvm_phase phase);
    
//connect driver and sequencer ports and interface hndls if agent is active	  
    if(get_is_active()==UVM_ACTIVE)begin


 /*    
      //connect config from conf inside driver
      drv.m_conf=m_conf;

      //connect interface hndl inside driver with interface handl from config
      drv.vif=m_conf.vif;

*/

//connect sequence item port of driver and seq_item_export of seqencer is conneced in agent 


    drv.seq_item_port.connect(mas_sequencer.seq_item_export);
end



  endfunction:connect_phase
endclass:apb_mas_agnt
