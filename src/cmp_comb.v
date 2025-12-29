`default_nettype none

`ifndef GEN
`define LEN 16
`endif

module top(
  input wire [LEN-1:0] A,
  input wire [LEN-1:0] B,
  (* color="green"  *) output wire EQ,
  (* color="cyan"   *) output wire SG,
  (* color="blue"   *) output wire UG,
  (* color="purple" *) output wire MG,
  (* color="red"    *) output wire XG
  );

  parameter LEN = `LEN;

  assign EQ = A == B;
  assign SG =   $signed(A) >   $signed(B);
  assign UG = $unsigned(A) > $unsigned(B);
  assign MG =   $signed(A) > $unsigned(B);
  assign XG = $unsigned(A) >   $signed(B);
endmodule
