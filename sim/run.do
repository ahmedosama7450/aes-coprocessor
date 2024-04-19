quit -sim
vsim -gui work.tb_aes -voptargs=+acc
do tb_aes_wave.do
run 2000 ns