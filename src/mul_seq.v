`default_nettype none

`ifndef GEN
`define LEN 16
`endif

module top(
  (* color = "blue"  *) input  wire CLK,
  (* color = "white" *) input  wire START,
  (* color = "green" *) output wire DONE,

  input  wire [LEN-1:0] A,
  input  wire [LEN-1:0] B,
  output wire [LEN-1:0] Y
  );

  parameter LEN = `LEN;
  parameter RDX = 4;
  localparam DIGIT = LEN / RDX;

  reg  [DIGIT-1:0] [RDX-1:0] argA = 0;
  reg  [DIGIT-1:0] [RDX-1:0] argB = 0;
  reg  [DIGIT-1:0] [RDX-1:0] tmp = 0;
  reg  [DIGIT-1:1] [RDX-1:0] rcarry = 0;

  wire [DIGIT-1:0] [RDX-1:0] carry;
  assign carry[DIGIT-1:1] = rcarry;
  assign carry[0] = 0;

  wire [DIGIT  :1] [RDX-1:0] carry_nx;
  wire [DIGIT-1:0] [RDX-1:0] tmp_nx;

  wire [RDX-1:0] nibble = argB[0];
  genvar i;
  generate
    for (i = 0; i < DIGIT; i = i + 1) begin
      wire [RDX-1:0] lo;
      wire [RDX-1:0] hi;
      assign { hi, lo } = argA[i] * nibble + tmp[i] + carry[i];
      assign tmp_nx[i] = lo;
      assign carry_nx[i+1] = hi;
    end
  endgenerate

  assign Y = tmp;

  wire done = (!(|argA) || !(|argB)) && !(|rcarry);
  assign DONE = done;

  always @(posedge CLK) begin
    if (START) begin
      argA <= A;
      argB <= B;
      tmp <= 0;
      rcarry <= 0;
    end else begin
      tmp <= tmp_nx;
      rcarry <= carry_nx[DIGIT-1:1];
      argA <= argA << RDX;
      argB <= argB >> RDX;
    end
  end

endmodule
