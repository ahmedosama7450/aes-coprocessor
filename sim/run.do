quit -sim
vsim -gui work.tb_aes -voptargs=+acc
do tb_aes_wave.do
run 4000 ns