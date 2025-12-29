`default_nettype none

`ifndef GEN
`define LEN 16
`endif

`ifdef SIGNED
`define SIGN signed
`else
`define SIGN
`endif

module top(
  input  wire `SIGN [`LEN-1:0] A,
  input  wire `SIGN [`LEN-1:0] B,
  output wire `SIGN [`LEN-1:0] O
  );
  assign O = A % B;
endmodule
