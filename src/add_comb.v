`ifndef GEN
`define LEN 16
`endif

`ifdef ARG2I

module top(
  input  [`LEN-1:0] A,
  input  [`LEN-1:0] B,
  (* color = "yellow" *)
  input             IC,
  output [`LEN-1:0] Y,
  (* color = "yellow" *)
  output            OC,
  (* color = "red" *)
  output            OVF
  );

  wire guard;
  assign {guard, OC, Y} = $signed(A) + $signed(B) + IC;

  assign OVF = guard != OC;

endmodule

`endif

`ifdef ARG3I

module top(
  input  [`LEN-1:0] A1,
  input  [`LEN-1:0] A2,
  input  [`LEN-1:0] A3,
  (* color = "yellow" *)
  input       [1:0] IC,
  output [`LEN-1:0] Y,
  (* color = "yellow" *)
  output      [1:0] OC,
  (* color = "red" *)
  output            OVF
  );

  wire guard;
  assign {OC, Y} = A1 + A2 + A3 + IC;
  assign OVF = OC ^ Y[`LEN-1];

endmodule

`endif

`ifdef ARG4I

module top(
  input  [`LEN-1:0] A1,
  input  [`LEN-1:0] A2,
  input  [`LEN-1:0] A3,
  input  [`LEN-1:0] A4,
  (* color = "yellow" *)
  input       [1:0] IC,
  output [`LEN-1:0] Y,
  (* color = "yellow" *)
  output      [1:0] OC,
  (* color = "red" *)
  output            OVF
  );

  assign {OC, Y} = A1 + A2 + A3 + A4 + IC;
  assign OVF = OC ^ Y[`LEN-1];

endmodule

`endif
