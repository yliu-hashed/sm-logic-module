`ifndef GEN
`define LEN 16
`endif

module top(
  (* color = "blue"  *) input  CLK,
  (* color = "white" *) input  START,
  (* color = "green" *) output DONE,

  input  [LEN-1:0] A,
  input  [LEN-1:0] B,
  output [LEN-1:0] Y
  );

  parameter LEN = `LEN;

  reg [LEN-1:0] argA = 0;
  reg [LEN-1:0] argB = 0;
  reg [LEN-1:0] tmp = 0;
  assign Y = tmp;

  wire done = !argA || !argB;
  assign DONE = done;

  wire [3:0] nibble = argB[3:0];

  always @(posedge CLK) begin
    if (START) begin
      argA <= A;
      argB <= B;
      tmp <= 0;
    end else begin
      tmp <= tmp + argA * nibble;
      argA <= argA << 4;
      argB <= argB >> 4;
    end
  end

endmodule
