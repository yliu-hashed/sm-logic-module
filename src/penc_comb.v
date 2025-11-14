`default_nettype none

`ifndef GEN
`define LEN 4
`endif

`ifdef MAX

module top(
  input  [OPT-1:0] X,
  output [LEN-1:0] Y
  );

  parameter LEN = `LEN;
  localparam OPT = 2**LEN;

  wire [LEN-1:0] val_bus [0:OPT];

  assign val_bus[0] = 0;
  assign Y = val_bus[OPT];

  genvar i;
  generate
    for (i = 0; i < OPT; i = i + 1) begin
      wire key = X[i];

      wire val_next = val_bus[i+1];
      wire val_prev = val_bus[i];
      assign val_next = key ? i : val_prev;
    end
  endgenerate

endmodule

`endif

`ifdef MIN

module top(
  input  [OPT-1:0] X,
  output [LEN-1:0] Y
  );

  parameter LEN = `LEN;
  localparam OPT = 2**LEN;

  wire [LEN-1:0] val_bus [0:OPT];

  assign val_bus[OPT] = 0;
  assign Y = val_bus[0];

  genvar i;
  generate
    for (i = 0; i < OPT; i = i + 1) begin
      wire key = X[i];

      wire val_next = val_bus[i+1];
      wire val_prev = val_bus[i];
      assign val_prev = key ? i : val_next;
    end
  endgenerate

endmodule

`endif
