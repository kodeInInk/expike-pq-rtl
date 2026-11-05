set SCOPE "tb_top/inst_accelerator_top/*"
set SAIF  "dump_window.saif"
catch { close_saif }
# 跑到 dump_start 变成 1
run 0 ns
while { [get_value tb_top/dump_start] != 0 } {
    run 10000 ns
}

puts ">> dump_start=1 -> START SAIF"

# 开始 SAIF 采集
open_saif $SAIF
log_saif [get_objects /tb_top/inst_accelerator_top/*] 

# 继续运行 8000ns
run 1000 ns

# 结束 SAIF
close_saif
puts ">> SAIF saved to $SAIF"