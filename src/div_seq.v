`default_nettype none

`ifndef GEN
`define LEN 16
`endif

module top(
  (* color = "blue"  *) input  CLK,
  (* color = "white" *) input  START,
  (* color = "green" *) output DONE,

  input  [LEN-1:0] A, // numerator
  input  [LEN-1:0] B, // denominator
  output [LEN-1:0] Q, // quotient
  output [LEN-1:0] R  // remainder
  );

  parameter LEN = `LEN;
  localparam SLEN = $clog2(LEN);

  reg [SLEN:0] state = 0;

  reg [LEN-1:0] argD  = 0; // denominator
  reg [LEN-1:0] tmpNQ = 0; // shared numerator and quotient
  reg [LEN-1:0] tmpR  = 0; // remainder

  assign Q = tmpNQ;
  assign R = tmpR;

  wire [LEN-1:0] nxR = (tmpR << 1) | tmpNQ[LEN-1];
  wire div = nxR >= argD;
  wire done = !state;
  assign DONE = done;

  always @(posedge CLK) begin
    if (START) begin
      state <= { 1'b1, {SLEN{1'b0}} };
      argD  <= B;
      tmpNQ <= A;
      tmpR  <= 0;
    end else if (!done) begin
      state <= state - 1;
      tmpNQ <= (tmpNQ << 1) | div;
      tmpR  <= div ? nxR - argD : nxR;
    end
  end

endmodule
