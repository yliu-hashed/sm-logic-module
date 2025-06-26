`ifndef GEN
`define LEN 16
`endif

`ifdef SIGNED
`define SIGN signed
`else
`define SIGN
`endif

module top(
  input  `SIGN [`LEN-1:0] A,
  input  `SIGN [`LEN-1:0] B,
  output `SIGN [`LEN-1:0] O
  );
  assign O = A % B;
endmodule
