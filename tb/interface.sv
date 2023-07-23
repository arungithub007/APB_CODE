interface apb_intf (input logic clk,rst_n);
	
  
  logic       		 [7:0] paddr;
  logic                    pwrite;
  logic                    psel;
  logic                    penable;
  logic                    pready;
  logic        		[31:0] pwdata;
  logic	       		[31:0] prdata;

  covergroup apb_cov@(posedge clk);
      PADDR:coverpoint paddr {bins c1[3]={[0:85],[85:170],[170:255]};}
      
      PWRITE:coverpoint pwrite {bins c2={[0:1]};}

      PSEL:coverpoint psel {bins c3={[0:1]};}

      PENABLE:coverpoint penable {bins c4={[0:1]};}

      PREADY:coverpoint pready {bins c5={[0:1]};}

      PWDATA:coverpoint pwdata {bins c6[3]={[0:85],[85:170],[170:255]};}

      PRDATA:coverpoint prdata {bins c7[3]={[0:85],[85:170],[170:255]};}

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
//////Cover Property vs Covergroup
// • Cover properties …
// • Use SVA temporal syntax
// • Can use the same properties that assertions use
// • Not accessible by SV code
// • Placeable in structural code only
// 
// • Covergroups …
// • Record values of coverpoints
// • Provide functional crosses of coverpoints
// • Accessible by SV code and testcases
// • Placeable in both objects and structural code
//
// //////////////////////////////////////////////////////////////////////////////////
