library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_ram is 
port (
	clk : in std_logic;
	addr : in std_logic_vector(7 downto 0);
	write_en : in std_logic;
	data_in : in std_logic_vector (15 downto 0);
	data_out : out std_logic_vector (15 downto 0)
	);
end cpu_ram;

architecture behavioral of cpu_ram is 

type ram_type is array (0 to 255) of std_logic_vector(15 downto 0);
signal mem : ram_type:=(others=> (others => '0'));
signal data_outreg : std_logic_vector(15 downto 0):= (others => '0');
begin 
process(clk)
begin
if (rising_edge(clk)) then
	if (write_en = '1') then
		mem(to_integer(unsigned(addr))) <= data_in;
	end if;
	data_outreg <= mem(to_integer(unsigned(addr)));
end if;
end process;

data_out <= data_outreg;

end behavioral;