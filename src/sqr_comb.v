`default_nettype none

`ifndef GEN
`define I_LEN 16
`define O_LEN 16
`define SIGN
`endif

`ifdef TRUNC
`define I_LEN `LEN
`define O_LEN `LEN
`define SIGN
`endif

`ifdef FULL_SIGNED
`define I_LEN `LEN
`define O_LEN (2*`LEN)
`define SIGN signed
`endif

`ifdef FULL_UNSIGNED
`define I_LEN `LEN
`define O_LEN (2*`LEN)
`define SIGN
`endif

module top(
  input `SIGN [`I_LEN-1:0] X,
  output      [`O_LEN-1:0] Y
  );
  assign Y = X * X;
endmodule
