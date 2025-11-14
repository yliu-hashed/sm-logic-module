// Test the correctness of the div_seq.v module
`include "src/div_seq.v"
`default_nettype none

module tb;

  parameter LEN = 16;

  localparam bad_word = {LEN{1'bX}};

  reg  CLK   = 0;
  reg  START = 0;
  wire DONE;

  reg  [LEN-1:0] A = bad_word;
  reg  [LEN-1:0] B = bad_word;
  wire [LEN-1:0] Q;
  wire [LEN-1:0] R;

  top #(
    .LEN(LEN)
  ) inst ( .* );

  integer wait_count;

  task tick ();
    begin
      CLK <= 0; #1;
      wait_count = wait_count + 1;
      CLK <= 1; #1;
    end
  endtask

  task work (
    input [LEN-1:0] a,
    input [LEN-1:0] b,
    input [LEN-1:0] q,
    input [LEN-1:0] r,
    input integer timeout
    );
    begin
      wait_count = 0;
      // feed in data to be processed
      START <= 1;
      A <= a;
      B <= b;
      tick();

      START <= 0;
      A <= bad_word;
      B <= bad_word;
      tick();

      // wait until done
      while (!DONE) begin
        if (wait_count > timeout) begin
          $display("[FAIL] timeout for longer than %0d cycles", timeout);
          $stop;
        end
        tick();
      end

      // check result
      if (Q !== q) begin
        $display("[FAIL] mismatch quotient 0x%4h from expectation 0x%4h after %0d cycles", Q, q, wait_count);
        $stop;
      end
      if (R !== r) begin
        $display("[FAIL] mismatch remainder 0x%4h from expectation 0x%4h after %0d cycles", R, r, wait_count);
        $stop;
      end
    end
  endtask

  integer i;
  wire [LEN-1:0] hash_a = i * 193;
  wire [LEN-1:0] hash_b = i * 1543;
  wire [LEN-1:0] hash_q = (hash_b != 0) ? (hash_a / hash_b) : {LEN{1'b1}};
  wire [LEN-1:0] hash_r = (hash_b != 0) ? (hash_a % hash_b) : hash_a;

  initial begin
    $dumpfile("tmp/sim/trace.vcd");
    $dumpvars(0, tb);
    for (i = 0; i < 100; i = i + 1) begin
      work ( hash_a, hash_b, hash_q, hash_r, 16 );
    end
    $display("[PASS] tb_div_seq.v");
  end
endmodule
