library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity program_counter is
port(clk : in STD_LOGIC;
	 rst : in STD_LOGIC;
	 use_jump : in STD_LOGIC;
	 jump_addr : in STD_LOGIC_VECTOR(10 downto 0);
	 pc_out : out STD_LOGIC_VECTOR(10 downto 0);
	 en : in std_logic
	 );
end program_counter;
	
	 





architecture behavioral of program_counter is
signal count : unsigned(10 downto 0):=(others => '0');


begin
	process(clk, rst)
	begin 
		if (rst = '1') then 
			count <= others => '0';
		elsif (rising_edge(clk)) then
			if (en = '1') then 
				if (use_jump = '1') then
				count <= unsigned(jump_addr);
				else 
				count <= count + 1;
				
			end if;
		end if;
		end if;
		
	end process;
	
pc_out <= STD_LOGIC_VECTOR(count);

end behavioral;
