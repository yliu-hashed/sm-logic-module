`include "src/bcd_size.vh"

`ifndef GEN
`define DECLEN 9
`define BINLEN 30
`endif

module top(
  input  [BINLEN-1:0]   BIN,
  output [DECLEN*4-1:0] BCD,
  output                ovf
  );

  parameter DECLEN = `DECLEN;
  parameter BINLEN = `BINLEN;

  localparam BWIDTH = DECLEN*4;

  wire [BWIDTH-1:0] bus [0:BINLEN-1];
  assign ovf = BIN >= 10**DECLEN;

  assign bus[0] = 0;
  assign BCD = {bus[BINLEN-1][BWIDTH-2:0], BIN[0]};

  // double-dabble

  genvar layer, item;
  generate
    for (layer = 0; layer < BINLEN - 1; layer = layer + 1) begin
      wire [BWIDTH-1:0] prev = {bus[layer][BWIDTH-2:0], BIN[BINLEN-layer-1]};
      wire [BWIDTH-1:0] next = bus[layer+1];
      for (item = 0; item < DECLEN; item = item + 1) begin
        wire [3:0] ddi = prev[item*4+:4];
        wire [3:0] ddo = next[item*4+:4];
        assign ddo = (ddi > 4'd4) ? ddi + 4'd3 : ddi;
      end
    end
  endgenerate
endmodule
