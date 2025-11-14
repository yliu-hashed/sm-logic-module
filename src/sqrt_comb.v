`default_nettype none

`ifndef GEN
`define LEN 16
`endif

module top(
  input  [ LEN-1:0] X,
  output [RLEN-1:0] Y
  );

  parameter LEN = `LEN;
  localparam RLEN = LEN / 2;

  wire [ LEN-1:0] bus [0:RLEN];
  wire [RLEN-1:0] ans [0:RLEN];
  assign bus[0] = 0;
  assign ans[0] = 0;

  assign Y = ans[RLEN];

  genvar i;
  generate
    for (i = 0; i < RLEN; i = i + 1) begin
      wire [LEN-1:0] shifted = {bus[i][LEN-3:0], X[(RLEN-i-1)*2+:2]};
      wire [LEN-1:0] b = {ans[i], 2'b01};
      wire cmp = shifted >= b;
      wire [LEN-1:0] tmp = shifted - b;
      assign ans[i+1] = {ans[i][RLEN-2:0], cmp};
      assign bus[i+1] = cmp ? tmp : shifted;
    end
  endgenerate
endmodule
