class apb_mas_monitor extends uvm_monitor;
  
  virtual apb_intf vif;

  apb_mas_conf m_conf;
  
  `uvm_component_utils(apb_mas_monitor)
    apb_seq_item req_collected;   
  
  uvm_analysis_port#(apb_seq_item)item_collected_port; //analysis port declaration
  
  //constructor function
  function new(string name,uvm_component parent);
    super.new(name,parent);
    req_collected=new();
  endfunction:new
  
  //buid phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

        item_collected_port=new("item_collected_port",this);


    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF",{" virtual interface must be set for:",get_full_name(),".vif"});

  if (!uvm_config_db#(apb_mas_conf)::get(this,"","apb_mas_conf",m_conf)) begin
 `uvm_fatal("NO_CONF",{"configuration file must be set",get_full_name(),"m_conf"});
end

  endfunction:build_phase
  
//connect phase
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction:connect_phase


//Printing the heirachy of connections of ports is done in end_of_elaboration_phase as shown in below
function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction:end_of_elaboration_phase
 
//run phase
  virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
   

   forever begin
	     @(posedge vif.clk);

          //  if(vif.psel) begin
            //    while(vif.penable) begin
                    // create seq_item
                   // req = apb_seq_item::type_id::create("req");
                    
      
                    if(vif.pwrite == 1)  begin
                            req_collected.pwrite=1;
                            req_collected.paddr = vif.paddr;
                            req_collected.pwdata = vif.pwdata;
                            //@(apb_intf.cb);
                            // write to analysis port for sampling coverage
                          //  mntr2cov.write(item);
       `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);
			  
                        end    
                    
                    else if(vif.pwrite == 0) begin
                            req_collected.pwrite= 0;
                            req_collected.paddr = vif.paddr;
                            req_collected.prdata = vif.prdata;
                         //   @(posedge vif.clk);
                            // send the item to scoreboard for checking
                            item_collected_port.write(req_collected);
                        
                            // write to analysis port for sampling coverage
                          //  mntr2cov.write(item);
       `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);
			
                        end
            //        end
             //   end
           
	end 

  endtask:run_phase
 
endclass:apb_mas_monitor


/* 
  forever begin
     // `uvm_info(get_full_name(),"monitor_start",UVM_LOW);

     @ (posedge vif.clk)
            begin
              req_collected.pwrite = vif.pwrite;
              req_collected.paddr = vif.paddr;
              req_collected.psel = vif.psel;
              req_collected.penable = vif.penable;
      
      if(vif.pwrite==1'b1)begin
              req_collected.pwdata =vif.pwdata;
      end
      else begin

              req_collected.prdata = vif.prdata;
      end
          //    req_collected.print();
      
	   item_collected_port.write(req_collected);
     end
       `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);


     // `uvm_info(get_full_name(),"monitor_end",UVM_LOW);
     end
*/

