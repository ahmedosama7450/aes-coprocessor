onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_aes/tb/clk
add wave -noupdate /tb_aes/tb/rst_n
add wave -noupdate /tb_aes/tb/dut/gen_aes_coprocessor/aes_coproc/actual_issue_ready
add wave -noupdate /tb_aes/tb/dut/gen_aes_coprocessor/aes_coproc/is_first_instr_previous
add wave -noupdate /tb_aes/tb/dut/gen_aes_coprocessor/aes_coproc/is_first_instr
add wave -noupdate /tb_aes/tb/dut/gen_aes_coprocessor/aes_coproc/result_stage_available_d
add wave -noupdate /tb_aes/tb/dut/gen_aes_coprocessor/aes_coproc/result_stage_available_q
add wave -noupdate /tb_aes/tb/dut/gen_aes_coprocessor/aes_coproc/result_valid
add wave -noupdate /tb_aes/tb/dut/xif/compressed_valid
add wave -noupdate /tb_aes/tb/dut/xif/compressed_ready
add wave -noupdate /tb_aes/tb/dut/xif/compressed_req
add wave -noupdate /tb_aes/tb/dut/xif/compressed_resp
add wave -noupdate /tb_aes/tb/dut/xif/issue_valid
add wave -noupdate /tb_aes/tb/dut/xif/issue_ready
add wave -noupdate -childformat {{/tb_aes/tb/dut/xif/issue_req.instr -radix binary -childformat {{{[31]} -radix binary} {{[30]} -radix binary} {{[29]} -radix binary} {{[28]} -radix binary} {{[27]} -radix binary} {{[26]} -radix binary} {{[25]} -radix binary} {{[24]} -radix binary} {{[23]} -radix binary} {{[22]} -radix binary} {{[21]} -radix binary} {{[20]} -radix binary} {{[19]} -radix binary} {{[18]} -radix binary} {{[17]} -radix binary} {{[16]} -radix binary} {{[15]} -radix binary} {{[14]} -radix binary} {{[13]} -radix binary} {{[12]} -radix binary} {{[11]} -radix binary} {{[10]} -radix binary} {{[9]} -radix binary} {{[8]} -radix binary} {{[7]} -radix binary} {{[6]} -radix binary} {{[5]} -radix binary} {{[4]} -radix binary} {{[3]} -radix binary} {{[2]} -radix binary} {{[1]} -radix binary} {{[0]} -radix binary}}}} -expand -subitemconfig {/tb_aes/tb/dut/xif/issue_req.instr {-height 15 -radix binary -childformat {{{[31]} -radix binary} {{[30]} -radix binary} {{[29]} -radix binary} {{[28]} -radix binary} {{[27]} -radix binary} {{[26]} -radix binary} {{[25]} -radix binary} {{[24]} -radix binary} {{[23]} -radix binary} {{[22]} -radix binary} {{[21]} -radix binary} {{[20]} -radix binary} {{[19]} -radix binary} {{[18]} -radix binary} {{[17]} -radix binary} {{[16]} -radix binary} {{[15]} -radix binary} {{[14]} -radix binary} {{[13]} -radix binary} {{[12]} -radix binary} {{[11]} -radix binary} {{[10]} -radix binary} {{[9]} -radix binary} {{[8]} -radix binary} {{[7]} -radix binary} {{[6]} -radix binary} {{[5]} -radix binary} {{[4]} -radix binary} {{[3]} -radix binary} {{[2]} -radix binary} {{[1]} -radix binary} {{[0]} -radix binary}}} {/tb_aes/tb/dut/xif/issue_req.instr[31]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[30]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[29]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[28]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[27]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[26]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[25]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[24]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[23]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[22]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[21]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[20]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[19]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[18]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[17]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[16]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[15]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[14]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[13]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[12]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[11]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[10]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[9]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[8]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[7]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[6]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[5]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[4]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[3]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[2]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[1]} {-radix binary} {/tb_aes/tb/dut/xif/issue_req.instr[0]} {-radix binary}} /tb_aes/tb/dut/xif/issue_req
add wave -noupdate /tb_aes/tb/dut/xif/issue_resp
add wave -noupdate /tb_aes/tb/dut/xif/commit_valid
add wave -noupdate -expand /tb_aes/tb/dut/xif/commit
add wave -noupdate /tb_aes/tb/dut/xif/mem_valid
add wave -noupdate /tb_aes/tb/dut/xif/mem_ready
add wave -noupdate /tb_aes/tb/dut/xif/mem_req
add wave -noupdate /tb_aes/tb/dut/xif/mem_resp
add wave -noupdate /tb_aes/tb/dut/xif/mem_result_valid
add wave -noupdate /tb_aes/tb/dut/xif/mem_result
add wave -noupdate /tb_aes/tb/dut/xif/result_valid
add wave -noupdate /tb_aes/tb/dut/xif/result_ready
add wave -noupdate -expand /tb_aes/tb/dut/xif/result
add wave -noupdate /tb_aes/tb/mem/data_mem
add wave -noupdate -expand /tb_aes/tb/dut/core/register_file_wrapper_i/register_file_i/mem
add wave -noupdate /tb_aes/tb/dut/core/cs_registers_i/mcause_alias_we
add wave -noupdate /tb_aes/tb/dut/core/cs_registers_i/mcause_n
add wave -noupdate /tb_aes/tb/dut/core/cs_registers_i/mcause_o
add wave -noupdate /tb_aes/tb/dut/core/cs_registers_i/mcause_q
add wave -noupdate /tb_aes/tb/dut/core/cs_registers_i/mcause_rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39131 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 248
configure wave -valuecolwidth 103
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {168180 ps}
