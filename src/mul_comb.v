`ifndef GEN
`define LEN 16
`define TRUNC
`endif

`ifdef TRUNC
`define I_LEN `LEN
`define O_LEN `LEN
`define IA_SIGN
`define IB_SIGN
`define  O_SIGN
`endif

`ifdef FULL_SIGNED
`define I_LEN `LEN
`define O_LEN (2*`LEN)
`define IA_SIGN signed
`define IB_SIGN signed
`define  O_SIGN signed
`endif

`ifdef FULL_UNSIGNED
`define I_LEN `LEN
`define O_LEN (2*`LEN)
`define IA_SIGN
`define IB_SIGN
`define  O_SIGN
`endif

`ifdef FULL_MIXED
`define I_LEN `LEN
`define O_LEN (2*`LEN)
`define IA_SIGN signed
`define IB_SIGN
`define  O_SIGN signed
`endif

module top(
  input `IA_SIGN [`I_LEN-1:0] A,
  input `IB_SIGN [`I_LEN-1:0] B,
  output `O_SIGN [`O_LEN-1:0] Y
  );
  assign Y = A * B;
endmodule
