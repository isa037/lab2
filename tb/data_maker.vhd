library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is
  port (
    RST_n : IN std_logic;
    CLK  : in  std_logic;
    DATA : out std_logic_vector(31 downto 0);
    END_SIM : out std_logic);
end data_maker;

architecture beh of data_maker is
	constant tco : time := 1 ns;
	constant pipe_stage_number : integer := 5;
	signal END_SIM_i : std_logic_vector(0 to pipe_stage_number);
	signal sEndSim : std_logic;
begin  -- beh

  process (CLK, RST_n)
    file fp : text open read_mode is "../tb/fp_samples.hex";
    variable ptr : line;
    variable val : std_logic_vector(31 downto 0);
  begin  -- process
    if RST_n = '0' then 
	sEndSim <='0';
    else
	    if CLK'event and CLK = '1' then  -- rising clock edge
	      if (not(endfile(fp))) then
		readline(fp, ptr);
		hread(ptr, val);
		DATA <= val after tco;
	      else 
		sEndSim <= '1' after tco;
	      end if;
	    end if;
    end if;
  end process;

 process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to pipe_stage_number) <= END_SIM_i(0 to pipe_stage_number-1) after tco;
    end if;
  end process;
  

  END_SIM <= END_SIM_i(pipe_stage_number);  

end beh;
