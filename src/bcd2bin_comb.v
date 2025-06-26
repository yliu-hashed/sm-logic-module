`include "src/bcd_size.vh"

`ifndef GEN
`define DECLEN 9
`define BINLEN 30
`endif

module top(
  input  [DECLEN*4-1:0] BCD,
  output [BINLEN-1  :0] BIN,
  output                ovf
  );

  parameter DECLEN = `DECLEN;
  parameter BINLEN = `BINLEN;

  wire [BINLEN-1:0] bus [0:DECLEN];
  wire [DECLEN-1:0] overflow;

  assign bus[0] = 0;
  assign BIN = bus[DECLEN];
  assign ovf = |overflow;

  genvar i;
  generate
    for (i = 0; i < DECLEN; i = i + 1) begin
      wire [BINLEN-1:0] last = bus[i];
      wire [BINLEN-1:0] next = bus[i+1];
      wire [3:0] digit = BCD[i*4 +: 4];
      assign {overflow[i], next} = last + digit * (10 ** i);
    end
  endgenerate
endmodule
