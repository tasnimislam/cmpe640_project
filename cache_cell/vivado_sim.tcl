exec xvhdl Dlatch.vhd Dlatch8.vhd tb_Dlatch8.vhd
exec xelab tb_Dlatch8 -debug typical -s sim_out
exec xsim sim_out -gui
