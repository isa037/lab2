library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity tb_output_data_checker is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    END_SIM : in std_logic;
    DIN : in std_logic_vector(31 downto 0));
end tb_output_data_checker;

architecture beh of tb_output_data_checker is
	SIGNAL CORRECT_VALUE    :  std_logic_vector(31 downto 0);

begin  -- beh

 process (CLK, RST_n, END_SIM)--tb process
	--Open results output file  --------------------------------------
    file res_fp : text open WRITE_MODE is "./results.csv";
    variable line_out : line;    
	-------------------------------------------------------------------
	--Open file of input values and file of correct output values
	file inputValues_fp : text open READ_MODE is "../tb/fp_samples.hex";
	file correctOutputValues_fp : text open READ_MODE is "../tb/fp_prod.hex";
    variable line_in : line;  
	variable input, correctOutputValue : std_logic_vector(31 downto 0);
variable input_int, correctOutputValue_int : integer;
	variable signal_error: integer :=0;
	-------------------------------------------------------------------
	variable write_first_line_in_csv : std_logic := '0';
	variable wait_for_output : integer := 0;
	   

 begin  -- process
	if write_first_line_in_csv = '0' then 
		write(line_out, string'("INPUT, OUTPUT, EXPECTED OUTPUT,TEST RESULT"));
      	writeline(res_fp, line_out);
		write_first_line_in_csv := '1';
	end if;

		
    if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      	wait_for_output := wait_for_output + 1;
	if(wait_for_output > 6) then
			--Write INPUT value readed from file
			if not endfile(inputValues_fp) then
				readline(inputValues_fp, line_in);
				hread(line_in, input);
	       		end if;
			write(line_out, conv_integer(signed(input)));
			write(line_out, string'(","));
			--Write OUTPUT value obtained by tested circuit
			write(line_out, conv_integer(signed(DIN)));
			write(line_out, string'(","));
			--Write EXPECTED OUTPUT value readed from file
		if not endfile(correctOutputValues_fp) then
			readline(correctOutputValues_fp, line_in);
			hread(line_in, correctOutputValue);
		end if;
			write(line_out, conv_integer(signed(correctOutputValue)));
			write(line_out, string'(","));      
			--Test result an write TEST RESULT
		if (DIN /= correctOutputValue) then
		  	write(line_out, string'("Error"));
			signal_error:=1;
		else
		  	write(line_out, string'("OK"));
		end if;
			writeline(res_fp, line_out);
     	end if;
    end if;

	if END_SIM = '1' THEN
		if signal_error=0 then
			write(line_out, string'("SIMULATION ENDED SUCCESSFULLY"));
			writeline(res_fp, line_out);
		else
			write(line_out, string'("ERROR, WRONG RESULT PRODUCED"));
			writeline(res_fp, line_out);
		end if;			
	end if;
  end process;
end beh;
