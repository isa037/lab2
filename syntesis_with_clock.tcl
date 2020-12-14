
analyze -f vhdl -lib WORK ../src/multiplier/FF.vhd
analyze -f vhdl -lib WORK ../src/common/fpnormalize_fpnormalize.vhd
analyze -f vhdl -lib WORK ../src/common/fpround_fpround.vhd
analyze -f vhdl -lib WORK ../src/common/packfp_packfp.vhd
analyze -f vhdl -lib WORK ../src/common/unpackfp_unpackfp.vhd
analyze -f vhdl -lib WORK ../src/mbe/my_pkg.vhd
analyze -f vhdl -lib WORK ../src/mbe/partial_product_generator.vhd
analyze -f vhdl -lib WORK ../src/mbe/s_padder.vhd
analyze -f vhdl -lib WORK ../src/mbe/FA.vhd
analyze -f vhdl -lib WORK ../src/mbe/HA.vhd
analyze -f vhdl -lib WORK ../src/mbe/dadda_stage1.vhd
analyze -f vhdl -lib WORK ../src/mbe/dadda_stage2.vhd
analyze -f vhdl -lib WORK ../src/mbe/dadda_stage3.vhd
analyze -f vhdl -lib WORK ../src/mbe/dadda_stage4.vhd
analyze -f vhdl -lib WORK ../src/mbe/dadda_stage5.vhd
analyze -f vhdl -lib WORK ../src/mbe/dadda_stage6.vhd
analyze -f vhdl -lib WORK ../src/mbe/rca63.vhd
analyze -f vhdl -lib WORK ../src/mbe/dadda_tree.vhd
analyze -f vhdl -lib WORK ../src/mbe/mbe.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage1_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage2_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage3_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_stage4_struct.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_pipeline.vhd
analyze -f vhdl -lib WORK ../src/multiplier/REG.vhd
analyze -f vhdl -lib WORK ../src/multiplier/fpmul_pipeline_inputRegistered.vhd


#Before completing the reading of source we set one parameter to preserve rtl names in the netlist to ease the procedure for power consumption estimation.
set power_preserve_rtl_hier_names true
#Launch elaborate command to load the components
#elaborate <top entity name> -arch <architecture name> -lib WORK > ./elaborate.txt
elaborate  FPmul_REGISTERED -arch registered_pipeline -lib WORK > ./elaborate.txt
#uniquify #optional command to addres to only 1 specific architecture
link

#*******  Applying constraints   ***************
#create 100 Mhz clock
create_clock -name MY_CLK -period 4.48 clk  
set_dont_touch_network MY_CLK

#jitter simulation
set_clock_uncertainty 0.07 [get_clocks MY_CLK]

#input/output delay
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

#set output load (buffer x4 used)
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#flatten the hiercarchy
ungroup -all -flatten
#implement the pparch multiplier
#set_implementation DW02_mult/pparch [find cell *mult*]

#*********    Start the syntesis    *************
compile >  ./analysis_results/compilation_results.txt

#compile ultra
#compile_ultra >  ./analysis_results/ultra_compilation_results.txt

#*********    Save the results      *************
report_timing  >  ./analysis_results/timing_results.txt
report_area    >  ./analysis_results/area_results.txt
report_resources > ./analysis_results/resource_report.txt
exit
