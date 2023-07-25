
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//A driver is written by extending the uvm_driver
//uvm_driver is inherited from uvm_component, Methods and TLM port (seq_item_port) are defined for communication between sequencer and driver
//The uvm_driver is a parameterized class and it is parameterized with the type of the request sequence_item and the type of the response sequence_item
//
//UVM_Driver Methods
// 1)get_next_item
//      This method blocks until a REQ sequence_item is available in the sequencer.
//
// 2)try_next_item
//      This is a non-blocking variant of the get_next_item() method. It will return a null pointer if there is no REQ sequence_item available in the sequencer.
//
// 3)item_done
//      The non-blocking item_done() method completes the driver-sequencer handshake and it should be called after a get_next_item() or a successful try_next_item() call.
//
// 4)put
//      The put() method is non-blocking and is used to place an RSP sequence_item in the sequencer.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//`include "m_conf.sv"
class apb_mas_driver extends uvm_driver#(apb_seq_item);
`uvm_component_utils(apb_mas_driver)


//congigration instance
    apb_mas_conf m_conf;
    virtual apb_intf vif;


// analysis port declaration
    uvm_analysis_port#(apb_seq_item) drv2scb;
 
        apb_seq_item  req;


//constructor function
    function new(string name,uvm_component parent);
       super.new(name,parent);
       // create the analysis port from driver to socoreboard
       drv2scb = new("drv2scb", this);
    endfunction
  

//build phase
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
//get vertual interface here   
  if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))begin
      `uvm_fatal("NO_VIF",{" virtual interface must be set for:",get_full_name(),".vif"});
  end

//get configuration file here
if (!uvm_config_db#(apb_mas_conf)::get(this,"","apb_mas_conf",m_conf)) begin
 `uvm_fatal("NO_CONF",{"configuration file must be set",get_full_name(),"m_conf"});
end

m_conf.print();
  endfunction:build_phase

//Printing the heirachy of connections of ports is done in end_of_elaboration_phase as shown in below
  function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
  endfunction


//run phase   
    virtual task run_phase(uvm_phase phase);
        apb_seq_item req;
        
 forever  begin
           @(posedge vif.clk);
            seq_item_port.get_next_item(req);
                if(req.pwrite==1) begin
                    wr_data(req);
                    // write expected data to analysis port
                   drv2scb.write(req);
                end
	                else if(req.pwrite==0) begin
                    rd_data(req);
                end
            seq_item_port.item_done();
        end    
    endtask: run_phase
    
    ////////////////////////////////////////////////////////////////////
    // task name: wr_data
    // input parameter: apb_seq_item
    // Description: write data to dut
    ////////////////////////////////////////////////////////////////////
    task wr_data(input apb_seq_item req);
	
        vif.psel<= 1;
        vif.pwrite <= req.pwrite;
        vif.paddr <= req.paddr;
        vif.pwdata <= req.pwdata;
      
        vif.penable <= 0;
        @(posedge vif.clk);
        wait (vif.pready<=1'b1);
        vif.penable <= 1;
/********************************************************************************************************************        
      //incertiing wait state in write data \
        if (m_conf.insert_wait_cycle) begin
               repeat (m_conf.num_wait_cycle);
           begin
            // force wait satate 

               force tb_top.dut.pready=0; // take instantation name in tb top to drive the signals
           end 
            // release pready wait 
               @(posedge vif.clk)
               release tb_top.dut.pready;
        end   
***********************************************************************************************************************/
        @(negedge vif.clk);
      //  vif.penable<= 0;
      //  vif.psel <= 0;
	`uvm_info(get_type_name(),$sformatf("\t PADDR=%0h,\t PwDATA=%0h",req.paddr,vif.pwdata),UVM_LOW); 
	
       // @(posedge vif.clk);
    endtask: wr_data
    
    ////////////////////////////////////////////////////////////////////
    // task name: rd_data
    // input parameter: addr, data
    // Description: read data from dut
    ////////////////////////////////////////////////////////////////////
 task rd_data(input apb_seq_item req);
       
	    vif.psel<= 1;
        vif.paddr <= req.paddr;	
        vif.pwrite <= req.pwrite;
            vif.penable <= 0;
       // vif.pwdata<=vif.pwdata;
	    @(posedge vif.clk);
        vif.penable <= 1;	
        req.prdata = vif.prdata; 
        @(posedge vif.clk);
        vif.penable <= 1;
        wait (vif.pready<=1'b1);

/*********************************************************************************************************************
        //incertiing wiat state in read data
        if (m_conf.insert_wait_cycle)begin
            repeat (m_conf.num_wait_cycle);
        begin 
        // force the wait state  @(posedge vif.clk);
            force tb_top.dut.pready=0;
        end
           @(posedge vif.clk);
            release tb_top.dut.pready;
        end
**********************************************************************************************************************/
       vif.psel <= 1;
//	@(negedge vif.clk);
 	`uvm_info(get_type_name(),$sformatf("\t PADDR=%0h,\t PRDATA=%0h",req.paddr,vif.prdata),UVM_LOW); 
	

	
endtask: rd_data

endclass:apb_mas_driver
 































































































   



/* 
//run phase 
virtual task run_phase(uvm_phase phase);

	     `uvm_info(get_full_name(),"start driver",UVM_LOW);	 
forever begin
  
      seq_item_port.get_next_item(req);

      drive();
       
      seq_item_port.item_done();
    //  m_cof.print();
   end
   
             `uvm_info(get_full_name(),"end driver",UVM_LOW);	
  endtask:run_phase


//888888888888888888888888888888888888888888888

virtual task drive();
   begin
	   @(posedge vif.clk )

  // vif.psel<=1'b0;
    vif.penable<=1'b0;
   if(req.pwrite==1)begin
       	   vif.psel<=1'b1;
	   vif.penable<=1'b1;
            vif.paddr<=req.paddr;
	     vif.pwrite<=req.pwrite;
	     vif.pwdata<=req.pwdata;
     	     @(posedge vif.clk)
	     vif.penable<=1'b0;
	    
     end 
   
     
     else begin
          vif.psel<=1'b1;
	  vif.paddr<=req.paddr;
	  vif.pwrite<=req.pwrite;
         @(posedge vif.clk );
          vif.penable<=1'b1;
          req.prdata<=vif.prdata;
     end
 `uvm_info(get_type_name(),$sformatf("\t PADDR=%0h,\t PRDATA=%0h",req.paddr,vif.prdata),UVM_LOW); 
//req.print();
end
endtask:drive
endclass:apb_mas_driver


//888888888888888888888888888888888888888888888888888888

*/


/*
 
 virtual task drive();
  begin
           @(posedge vif.clk)
      vif.psel<=1;
      vif.pwrite<=1;
      vif.paddr<=req.paddr;
      vif.pwdata<=req.pwdata;
      
      @(posedge vif.clk);
      vif.penable<=1;
      @(posedge vif.clk)
      vif.psel=0;
      vif.penable<=0;
      end

////read////     
begin
      @(posedge vif.clk);
      vif.psel<=0;
      vif.penable<=0; 
      @(posedge vif.clk)
      vif.psel<=1;
      vif.pwrite<=0;
     @(posedge vif.clk);
      vif.penable<=1;
     @(posedge vif.clk)
       req.prdata<=vif.prdata;
      @(posedge vif.clk);
       vif.psel<=0;
       vif.penable<=0;
       end
        `uvm_info(get_type_name(),$sformatf("\t PADDR=%0h, \t PWDATA=%0h,\t PRDATA=%0h",req.paddr,req.pwdata,vif.prdata),UVM_LOW); 
      endtask
endclass  
*/


//trying to reduce the clock cycle by giving the addresss and data manually//
//the if condition statement is not needed if we randomize the test//
/*
 virtual task drive();
      begin
      @(posedge vif.clk)
      vif.psel<=0;
      vif.penable<=0; 
      @(posedge vif.clk)
      if(vif.pwrite==1'b1)  begin
      vif.psel<=req.psel;
      vif.pwrite<=req.pwrite;
      vif.paddr<=req.paddr;
      vif.pwdata<=req.pwdata;
      @(posedge vif.clk)
      vif.penable<=1;
           
	 end
////read////     
 else if(vif.pwrite==1'b0) begin
   
      vif.psel<=1;
      vif.pwrite<=0;
      vif.paddr<=req.paddr;
      @(posedge vif.clk)
     vif.penable<=1;
     req.prdata<=vif.prdata;
           end
    `uvm_info(get_type_name(),$sformatf("\t PADDR=%0h, \t PWDATA=%0h,\t PRDATA=%0h",req.paddr,req.pwdata,vif.prdata),UVM_LOW); 
	  end
      endtask
endclass  

*/
















//more mistake in the flow
/*
virtual task drive();
@(posedge vif.clk)
vif.psel=0;
vif.psel=0;
   if(vif.pwrite==1)begin 
     //////write/////
     vif.psel<= 1'b1;
     vif.paddr<=req.paddr;
     vif.pwdata<=req.pwdata;
     vif.pwrite<=1'b1;
     @(posedge vif.clk)
     vif.penable<=1'b1;
     `uvm_info("DRV",$sformatf("addr:%0f, wdata:%0d, rdata:%0d",vif.paddr,vif.pwdata,vif.prdata),UVM_NONE);
     @(posedge vif.clk)
     vif.penable<=1'b0;
    end 
     ////read/////
     else begin
     vif.psel<= 1'b1;
     vif.paddr<=req.paddr;
     req.prdata<=vif.prdata;
     vif.pwrite<=1'b0;
     @(posedge vif.clk)
     vif.penable<=1'b1;
     `uvm_info("DRV",$sformatf("addr:%0f, wdata:%0d, rdata:%0d",vif.paddr,vif.pwdata,vif.prdata),UVM_NONE);
     @(posedge vif.clk)
     vif.penable<=1'b0;
      end 
 endtask
 endclass
 
*/
 
  /*
                   if(vif.psel==0)
                          begin
                           
                            vif.paddr     <= 'h0;
                            vif.pwdata    <= 'h0;
                            vif.pwrite    <= 'b0;
                           // vif.psel      <= 'b0;
                            vif.penable   <= 'b0;
                          @(posedge vif.clk);  
                          end
 
                  else if(vif.psel==1 &&  vif.penable==1)
                          begin
                           // vif.psel    <= 1'b1;
                            vif.paddr   <= req.paddr;
                            vif.pwdata  <= req.pwdata;
                            //vif.rst_n <= 1'b1;
                            vif.pwrite  <= 1'b1;
                            @(posedge vif.clk);
                            vif.penable <= 1'b1;
     `uvm_info("DRV", $sformatf("addr:%0d, wdata:%0d, rdata:%0d",req.paddr,req.pwdata,req.prdata), UVM_NONE);
                          
                            vif.penable <= 1'b0;
                          
                            
                          end
                      else if(vif.psel==1)
                          begin
                            vif.psel    <= 1'b1;
                            vif.paddr   <= req.paddr;
                            //vif.rst_n <= 1'b1;
                            vif.pwrite  <= 1'b0;
                            @(posedge vif.clk);
                            vif.penable <= 1'b1;
     `uvm_info("DRV", $sformatf("addr:%0d, wdata:%0d, rdata:%0d",req.paddr,req.pwdata,req.prdata), UVM_NONE);
                          
			     vif.penable <= 1'b0;
                            req.prdata     = vif.pwdata;
                         
                          end
    end
  endtask
endclass
*/


