module apb_slave
#(
  addrWidth = 8,
  dataWidth = 32
)
(
  input                        clk,
  input                        rst_n,
  input        [addrWidth-1:0] paddr,
  input                        pwrite,
  input                        psel,
  input                        penable,
  output logic                 pready,
  input        [dataWidth-1:0] pwdata,
  output logic [dataWidth-1:0] prdata
);

logic [dataWidth-1:0] mem [256];

logic [1:0] apb_st;
const logic [1:0] SETUP_PHASE = 0;
const logic [1:0] W_ENABLE = 1;
const logic [1:0] R_ENABLE = 2;

// SETUP_PHASE -> ENABLE
always @(negedge rst_n or posedge clk) begin
  if (rst_n == 0) begin
    apb_st <= 0;
    prdata <= 0;
  end

  else begin
    case (apb_st)
      SETUP_PHASE : begin
        // clear the prdata
        prdata <= 0;
        pready <= 1;
        // Move to ENABLE when the psel is asserted
        if (psel && !penable) begin
          if (pwrite) begin
            apb_st <= W_ENABLE;
          end

          else begin
            apb_st <= R_ENABLE;
          end
        end
      end

      W_ENABLE : begin
        // write pwdata to memory
        if (psel && penable && pwrite) begin
          mem[paddr] <= pwdata;
        end

        // return to SETUP_PHASE
        apb_st <= SETUP_PHASE;
      end

      R_ENABLE : begin
        // read prdata from memory
        if (psel && penable && !pwrite) begin
          prdata <= mem[paddr];
        end

        // return to SETUP_PHASE
        apb_st <= SETUP_PHASE;
      end
    endcase
  end
end 


endmodule
