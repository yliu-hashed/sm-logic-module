
// supported: 8B2D 8B3D 16B4D 16B5D 24B7D 24B8D 32B9D 32B10D

// 8 bit

`ifdef MODE_8B2D
`define BINLEN  8
`define DECLEN  2
`endif

`ifdef MODE_8B3D
`define BINLEN  8
`define DECLEN  3
`endif

// 16 bit

`ifdef MODE_16B4D
`define BINLEN 16
`define DECLEN  4
`endif

`ifdef MODE_16B5D
`define BINLEN 16
`define DECLEN  5
`endif

// 24 bit

`ifdef MODE_24B7D
`define BINLEN 24
`define DECLEN  7
`endif

`ifdef MODE_24B8D
`define BINLEN 24
`define DECLEN  8
`endif

// 32 bit

`ifdef MODE_32B9D
`define BINLEN 32
`define DECLEN  9
`endif

`ifdef MODE_32B10D
`define BINLEN 32
`define DECLEN 10
`endif
