module PCIE_Controller
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_en,
    BRAM_PORTA_0_rst,
    BRAM_PORTA_0_we,
    CLK_IN_D_clk_n,
    CLK_IN_D_clk_p,
    DDR3_addr,
    DDR3_ba,
    DDR3_cas_n,
    DDR3_ck_n,
    DDR3_ck_p,
    DDR3_cke,
    DDR3_cs_n,
    DDR3_dm,
    DDR3_dq,
    DDR3_dqs_n,
    DDR3_dqs_p,
    DDR3_odt,
    DDR3_ras_n,
    DDR3_reset_n,
    DDR3_we_n,
    RD_ADRS,
    RD_DONE,
    RD_FIFO_DATA,
    RD_FIFO_WE,
    RD_LAST,
    RD_LEN,
    RD_READY,
    RD_SIZE,
    RD_START,
    SYS_CLK_0_clk_n,
    SYS_CLK_0_clk_p,
    WR_ADRS,
    WR_DONE,
    WR_FIFO_AEMPTY,
    WR_FIFO_DATA,
    WR_FIFO_EMPTY,
    WR_FIFO_RE,
    WR_LEN,
    WR_READY,
    WR_SIZE,
    WR_START,
    WR_STRB,
    pcie_7x_mgt_rtl_0_rxn,
    pcie_7x_mgt_rtl_0_rxp,
    pcie_7x_mgt_rtl_0_txn,
    pcie_7x_mgt_rtl_0_txp,
    sys_rst_n,
    ui_clk);
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 ADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA_0, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 262144, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_WRITE" *) output [17:0]BRAM_PORTA_0_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 CLK" *) output BRAM_PORTA_0_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 DIN" *) output [31:0]BRAM_PORTA_0_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 DOUT" *) input [31:0]BRAM_PORTA_0_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 EN" *) output BRAM_PORTA_0_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 RST" *) output BRAM_PORTA_0_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 WE" *) output [3:0]BRAM_PORTA_0_we;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 CLK_IN_D CLK_N" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK_IN_D, CAN_DEBUG false, FREQ_HZ 100000000" *) input [0:0]CLK_IN_D_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 CLK_IN_D CLK_P" *) input [0:0]CLK_IN_D_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 ADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DDR3, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250" *) output [14:0]DDR3_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 BA" *) output [2:0]DDR3_ba;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CAS_N" *) output DDR3_cas_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CK_N" *) output [1:0]DDR3_ck_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CK_P" *) output [1:0]DDR3_ck_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CKE" *) output [1:0]DDR3_cke;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CS_N" *) output [1:0]DDR3_cs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DM" *) output [7:0]DDR3_dm;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DQ" *) inout [63:0]DDR3_dq;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DQS_N" *) inout [7:0]DDR3_dqs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DQS_P" *) inout [7:0]DDR3_dqs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 ODT" *) output [1:0]DDR3_odt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 RAS_N" *) output DDR3_ras_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 RESET_N" *) output DDR3_reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 WE_N" *) output DDR3_we_n;
  input [31:0]RD_ADRS;
  output RD_DONE;
  output [255:0]RD_FIFO_DATA;
  output RD_FIFO_WE;
  output RD_LAST;
  input [31:0]RD_LEN;
  output RD_READY;
  input [2:0]RD_SIZE;
  input RD_START;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 SYS_CLK_0 CLK_N" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME SYS_CLK_0, CAN_DEBUG false, FREQ_HZ 100000000" *) input SYS_CLK_0_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 SYS_CLK_0 CLK_P" *) input SYS_CLK_0_clk_p;
  input [31:0]WR_ADRS;
  output WR_DONE;
  input WR_FIFO_AEMPTY;
  input [255:0]WR_FIFO_DATA;
  input WR_FIFO_EMPTY;
  output WR_FIFO_RE;
  input [31:0]WR_LEN;
  output WR_READY;
  input [2:0]WR_SIZE;
  input WR_START;
  input [31:0]WR_STRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl_0 rxn" *) (* X_INTERFACE_MODE = "Master" *) input [7:0]pcie_7x_mgt_rtl_0_rxn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl_0 rxp" *) input [7:0]pcie_7x_mgt_rtl_0_rxp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl_0 txn" *) output [7:0]pcie_7x_mgt_rtl_0_txn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl_0 txp" *) output [7:0]pcie_7x_mgt_rtl_0_txp;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SYS_RST_N RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SYS_RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input sys_rst_n;
  output ui_clk;