module rom2x48_infer_onefile #(
  parameter integer W = 4608,    // 位宽
  parameter integer D = 48       // 每个逻辑RAM深度
)(
  input  wire                 clk,
  input  wire                 ren0,
  input  wire [$clog2(D)-1:0] raddr0,
  output reg  [W-1:0]         rdata0,
  input  wire                 ren1,
  input  wire [$clog2(D)-1:0] raddr1,
  output reg  [W-1:0]         rdata1
);
  localparam integer DEPTH = 2*D;   // 96

  // 提示综合用 Block RAM；Synplify/Vivado 都认识
  (* ram_style="block" *) /* synthesis syn_ramstyle="block_ram" */
  reg [W-1:0] mem [0:DEPTH-1];

  // 只读：用 $readmemh 初始化一份 96×4608 的文件
  initial begin
    // 每行 4608 位（1152 十六进制字符），共 96 行
    $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/P64/syn_ram/code_weight.mem", mem);
  end

  // 端口A：0..47
  always @(posedge clk) begin
    if (ren0) rdata0 <= mem[raddr0];
  end

  // 端口B：48..95（+D 偏移）
  always @(posedge clk) begin
    if (ren1) rdata1 <= mem[raddr1 + D];
  end
endmodule