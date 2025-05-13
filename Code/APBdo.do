vlib work
vlog APB_interface.sv APB_top.sv APB_svr.sv APB_sequence_item.sv APB_scoreboard.sv APB_coverage.sv APB_monitor.sv APB_Wrapper.sv  APB_Wrapper_tb.sv  +cover
vsim -voptargs=+acc work.APB_top -cover
add wave *
add wave -r /*
coverage save APB_Wrapper_tb.ucdb -onexit

run -all

vcover report APB_Wrapper_tb.ucdb -details -all -annotate -output APB_cvr.txt


