`uvm_analysis_imp_decl(_drv2scb)
`uvm_analysis_imp_decl(_item_collected)

class apb_scb extends uvm_scoreboard;
	`uvm_component_utils(apb_scb)


//variables
//assosiative arry syntax
//  value        array_name        [key]
//data_type    array_identifier  [indextype]
bit[31:0] ref_data[*];    // declaring assosiative array



// declaring the analysis port for item collected in sc components
uvm_analysis_imp_item_collected#(apb_seq_item, apb_scb)item_collected_export;  //monitor to scoreboard
uvm_analysis_imp_drv2scb#(apb_seq_item, apb_scb)drv2scb_export;         //driver to scoreboard



//constructor function
        function new(string name="apb_scb",uvm_component parent);
		super.new(name,parent);
	endfunction:new

//build phase
	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);    
	//create analysis port
	item_collected_export=new("item_collected_export",this);
	    drv2scb_export=new("drv2scb_export",this);
        endfunction



        virtual function void write_drv2scb(apb_seq_item req_collected);
 

	 if(req_collected.pwrite==1)
	 
                                    begin

	                            ref_data[req_collected.paddr]=req_collected.pwdata;  // data comes from driver
                                    end
   
				    else  begin
	        	if (ref_data.exists(req_collected.paddr)) begin	    
	                if ((ref_data[req_collected.paddr]==req_collected.prdata)) begin
		            `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);
                           `uvm_info(get_full_name(),"read_operation_matched_with_write_operation", UVM_LOW);
                    
	                end
                	else begin

                          `uvm_info(get_full_name(),"read_operation_not_matched_with_write_operation", UVM_LOW);
                       
		              end
                         end
		 end

       // else   `uvm_info(get_full_name(),"data_not_exist_in_the_addr", UVM_LOW);
	      
 
     `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);    
	    
endfunction : write_drv2scb

        virtual function void write_item_collected(apb_seq_item req_collected);
 

	 if(req_collected.pwrite==1)
	 
                                    begin

	                            ref_data[req_collected.paddr]=req_collected.pwdata;  // data comes from monitor 
                                    end
   
				    else  begin
	        	if (ref_data.exists(req_collected.paddr)) begin	    
	                if ((ref_data[req_collected.paddr]==req_collected.prdata)) begin
		            `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);
                           `uvm_info(get_full_name(),"read_operation_matched_with_write_operation", UVM_LOW);
                    
	                end
                	else begin

                          `uvm_info(get_full_name(),"read_operation_not_matched_with_write_operation", UVM_LOW);
                       
		              end
                         end
		 end

       // else   `uvm_info(get_full_name(),"data_not_exist_in_the_addr", UVM_LOW);
	      
 
     `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);    
	    
endfunction : write_item_collected



endclass
	/*
	//implementing the write function

        virtual function void write_drv2scb(apb_seq_item req_collected);
 

	 if(req_collected.pwrite==1)
	 
                                    begin

	                            ref_data[req_collected.pwdata]=req_collected.pwdata;  // data comes from driver
                                    end
   
				    else  begin
	        	if (ref_data.exists(req_collected.paddr)) begin	    
	                if ((ref_data[req_collected.paddr]==req_collected.prdata)) begin
		            `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);
                           `uvm_info(get_full_name(),"read_operation_matched_with_write_operation", UVM_LOW);
                    
	                end
                	else begin

                          `uvm_info(get_full_name(),"read_operation_not_matched_with_write_operation", UVM_LOW);
                       
		              end
                         end
		 end

       // else   `uvm_info(get_full_name(),"data_not_exist_in_the_addr", UVM_LOW);
	      
 
     `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);    
	    
endfunction : write_drv2scb

        virtual function void write_item_collected(apb_seq_item req_collected);
 

	 if(req_collected.pwrite==1)
	 
                                    begin

	                            ref_data[req_collected.pwdata]=req_collected.pwdata;  // data comes from monitor 
                                    end
   
				    else  begin
	        	if (ref_data.exists(req_collected.paddr)) begin	    
	                if ((ref_data[req_collected.paddr]==req_collected.prdata)) begin
		            `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);
                           `uvm_info(get_full_name(),"read_operation_matched_with_write_operation", UVM_LOW);
                    
	                end
                	else begin

                          `uvm_info(get_full_name(),"read_operation_not_matched_with_write_operation", UVM_LOW);
                       
		              end
                         end
		 end

       // else   `uvm_info(get_full_name(),"data_not_exist_in_the_addr", UVM_LOW);
	      
 
     `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);    
	    
endfunction : write_item_collected



endclass
*/



/*
`uvm_analysis_imp_decl(_item_collected)
`uvm_analysis_imp_decl(_drv2scb)

class apb_scb extends uvm_scoreboard;  
`uvm_component_utils(apb_scb)



//variables
//assosiative arry syntax
//  value        array_name        [key]
//data_type    array_identifier  [indextype]
apb_seq_item ref_data[$];    // declaring queue array



// declaring the analysis port for item collected in sc components
uvm_analysis_imp_imp_collected#(apb_seq_item, apb_scb)item_collected_export;  //monitor to scoreboard
uvm_analysis_imp_drv2scb#(apb_seq_item, apb_scb)drv2scb_export;         //driver to scoreboard


//contructor function
function new(string name,uvm_component parent);
    super.new(name,parent);

    //create analysis ports
    item_collected_export=new("item_collected_export",this);
    drv2scb_export=new("drv2scb_export",this);
  endfunction:new


//build phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction:build_phase

//connect phase
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
endfunction:connect_phase

//run_phase
virtual function void run_phase(uvm_phase phase);
super.run_phase(phase);
endfunction:run_phase


//driver to scoreboard write function
function void write_drv2scb(apb_seq_item item);
	//print seq_item recieved from driver
	`uvm_info("SCB",$sformatf("seq_item written from driver: \n"),UVM_HIGH)
	item.print();

	//pushe expected seq_item into accosiative array
	ref_data.push_back(item);
endfunction:write_drv2scb


    // monitor to scoreboard write function
    function void write_item_collected(apb_seq_item item);
        // print seq_item details received from monitor
        `uvm_info("SCB", $sformatf("Seq_item written from monitor: \n"), UVM_HIGH)
        item.print();
        
        // push captured seq_item into queue
        rcvd_seq_item_q.push_back(item);
    endfunction: write_mntr2scb

  



/* 
  virtual function void write(apb_seq_item req);

	    ref_data[req.paddr]=req.pwdata;  // data comes from monitor
	    
endfunction : write 


virtual function void write(apb_seq_item req_collected);

	 if(req_collected.pwrite==1)begin
                                   
	                         if(ref_data[req_collected.paddr]==req_collected.pwdata) // data comes from monitor  
				    begin
	       	if (ref_data.exists(req_collected.paddr)) begin	    
	                if ((ref_data[req_collected.paddr]==req_collected.prdata)) begin
		            `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);
                           `uvm_info(get_full_name(),"read_operation_matched_with_write_operation", UVM_LOW);
                       req_collected.print();
	                end
                	else begin

                          `uvm_info(get_full_name(),"read_operation_not_matched_with_write_operation", UVM_LOW);
  	                   req_collected.print();  
		              end
                         end
		end

       // else   `uvm_info(get_full_name(),"data_not_exist_in_the_addr", UVM_LOW);
       end	    
 
     `uvm_info(get_full_name(),$sformatf(" \t paddr=%0h, \t pwdata=%0h,\t prdata=%0h", req_collected.paddr,req_collected.pwdata,req_collected.prdata ),UVM_LOW);    
	    
endfunction : write



endclass:apb_scb

*/

