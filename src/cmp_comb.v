`ifndef GEN
`define LEN 16
`endif

module top(
  input  [LEN-1:0] A,
  input  [LEN-1:0] B,
  (* color="green"  *) output EQ,
  (* color="cyan"   *) output SG,
  (* color="blue"   *) output UG,
  (* color="purple" *) output MG,
  (* color="red"    *) output XG
  );

  parameter LEN = `LEN;

  assign EQ = A == B;
  assign SG =   $signed(A) >   $signed(B);
  assign UG = $unsigned(A) > $unsigned(B);
  assign MG =   $signed(A) > $unsigned(B);
  assign XG = $unsigned(A) >   $signed(B);
endmodule
