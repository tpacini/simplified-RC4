create_clock -name clk -period 10 [get_ports clk]

# get_clocks takes the name specified with "-name" and not the one of the port
set_false_path -from [get_ports rst_n] -to [get_clocks clk]

# min. 1 ns of input and output delay max. 2ns
# all_input automatically exclude the clock
set_input_delay  -min 1 -clock [get_clocks clk] [all_inputs ]
set_input_delay  -max 2 -clock [get_clocks clk] [all_inputs ]
set_output_delay -min 1 -clock [get_clocks clk] [all_outputs]
set_output_delay -max 2 -clock [get_clocks clk] [all_outputs]