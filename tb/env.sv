class apb_env extends uvm_env;
`uvm_component_utils(apb_env)
int i;

//declaring handles for scorreboard and agent
apb_scb scb;
apb_mas_agnt agnt1[];
apb_mas_conf m_conf;


//Constructor function
function new(string name = "apb_env",uvm_component parent);
    super.new(name,parent);
endfunction:new


 //build phase 
 //donot use reporting macros in build phase to avoid confusion except ----> if(!uvm_config_db)
virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  scb = apb_scb::type_id::create("scb", this);
  //agnt1[i]=apb_mas_agnt::type_id::create("agnt1",this);
  m_conf=apb_mas_conf::type_id::create("m_conf",this);


  //get apb_mas_conf from uvm_config_db
  if(!uvm_config_db#(apb_mas_conf)::get(this," ","apb_mas_conf",m_conf))begin
	   `uvm_fatal("M_CFG Not Found ERROR", $sformatf("Unable to retrieve apb_mas_cfg from uvm_config_db"))
  end
  
       agnt1=new[m_conf.no_master];
foreach(agnt1[i])
    agnt1[i]=apb_mas_agnt::type_id::create("agnt1",this);

     //agnt1[i]=apb_mas_agnt::type_id::create($sformatf("agnt1[%0d]",agnt1[i]));

 
 endfunction : build_phase

 
 //connect phase
 virtual function void connect_phase(uvm_phase phase);

 foreach (agnt1[i]) fork
agnt1[i].drv.drv2scb.connect(scb.drv2scb_export);                    //connect driver  and scoreboard through analysis port 
agnt1[i].mon.item_collected_port.connect(scb.item_collected_export); //connect monitor and scoreboard through analysis port
 join
 endfunction:connect_phase

 endclass:apb_env

