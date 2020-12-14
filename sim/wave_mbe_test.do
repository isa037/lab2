onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_mult/CLK_i
add wave -noupdate -format Logic /tb_mult/RST_n_i
add wave -noupdate -format Literal /tb_mult/FP_Z_i
add wave -noupdate -format Literal /tb_mult/DATA_i
add wave -noupdate -format Logic /tb_mult/END_SIM_i
add wave -noupdate -format Literal /tb_mult/UUT/fp_a
add wave -noupdate -format Literal /tb_mult/UUT/fp_b
add wave -noupdate -format Literal /tb_mult/UUT/fp_z
add wave -noupdate -format Literal -radix unsigned /tb_mult/UUT/mult/a_sig
add wave -noupdate -format Literal -radix decimal /tb_mult/UUT/mult/b_sig
add wave -noupdate -format Literal -radix unsigned /tb_mult/UUT/mult/i2/i2combo/mbe_out
add wave -noupdate -format Literal -radix unsigned /tb_mult/UUT/mult/i2/i2combo/mbe_multiplier
add wave -noupdate -format Literal -radix unsigned /tb_mult/UUT/mult/i2/i2combo/mbe_multiplicand
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31 ns} 0}
configure wave -namecolwidth 474
configure wave -valuecolwidth 100
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
update
WaveRestoreZoom {56 ns} {79 ns}
