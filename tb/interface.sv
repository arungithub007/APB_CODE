interface apb_intf (input logic clk,rst_n);
	
  
  logic       		 [7:0] paddr;
  logic                    pwrite;
  logic                    psel;
  logic                    penable;
  logic                    pready;
  logic        		[31:0] pwdata;
  logic	       		[31:0] prdata;

  covergroup apb_cov@(posedge clk);
      


      PSEL:   coverpoint psel    {bins c1 = {0,1};
                                  bins c2 = (0=>0),(0=>1),(1=>0),(1=>1);}
      PENABLE:coverpoint penable {bins c3 = {0,1};
                                  bins c4 = (0=>0),(0=>1),(1=>0),(1=>1);}
      PWRITE: coverpoint pwrite  {bins c5 = {0,1};
                                  bins c6 = (0=>0),(0=>1),(1=>0),(1=>1);}
      PREADY: coverpoint pready  {bins c7 = {0,1};
                                  bins c8 = (0=>0),(0=>1),(1=>0),(1=>1);}
      PADDR:  coverpoint paddr   {bins c9 [3] = {[0:85],[85:170],[170:255]};
                           ignore_bins c10 [2] = {[85:170],[170:255]};}
      PWDATA: coverpoint pwdata  {bins c11 [3] = {[0:85],[85:170],[170:255]};
                           ignore_bins c12 [2]= {[85:170],[170:255]};}
      PRDATA: coverpoint prdata  {bins c13 [3] = {[0:85],[85:170],[170:255]};
                           ignore_bins c14 [2]= {[85:170],[170:255]};}
                           
      
                           /////////////////////////////////////
                           //
                           //CROSS COVERAGES
                           //
                           ////////////////////////////////////
                           PSELXPENABLE: cross PSEL,PENABLE;
                           SELXENXWRT  : cross PSEL,PENABLE,PWRITE;
                           




  endgroup 

 initial begin
   apb_cov cvg=new();
    $display("Coverage = %f", cvg.get_coverage());
  // cvg.get_coverage();
   cvg.get_inst_coverage();
end

endinterface:apb_intf

 
//////////////////////////////////////////////////////////////////////////////////
//
//2//////Cover Property vs Covergroup
//10// • Cover properties …
//3// • Use SVA temporal syntax
//4// • Can use the same properties that assertions use
//5// • Not accessible by SV code
//6// • Placeable in structural code only
//7// 
//8// • Covergroups …
//9// • Record values of coverpoints
//10// • Provide functional crosses of coverpoints
// • Accessible by SV code and testcases
// • Placeable in both objects and structural code
//
////////////////////////////////////////////////////////////////////////////////////
