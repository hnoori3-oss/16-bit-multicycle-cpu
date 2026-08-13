library IEEE;
use IEEE.std_logic_1164.all;

entity cpu_register is 
port (
	clk : in std_logic ;
	rst : in std_logic;
	reg_write : in std_logic;
	
	write_addr : in std_logic_vector(2 downto 0);
	write_data : in std_logic_vector(15 downto 0);
	
	read_addr_A : in std_logic_vector(2 downto 0);
	read_addr_B : in std_logic_vector(2 downto 0);
	
	read_data_A : out std_logic_vector(15 downto 0);
	read_data_B : out std_logic_vector(15 downto 0)
);
end cpu_register;

architecture behavioral of cpu_register is 

signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(15 downto 0):=(others => '0');

begin 

with read_addr_A select 
	read_data_A <= R0 when "000",
				   R1 when "001",
				   R2 when "010",
				   R3 when "011",
				   R4 when "100",
				   R5 when "101",
				   R6 when "110",
				   R7 when "111",
				   "0000000000000000" when others;
				   
with read_addr_B select 
	read_data_B <= R0 when "000",
				   R1 when "001",
				   R2 when "010",
				   R3 when "011",
				   R4 when "100",
				   R5 when "101",
				   R6 when "110",
				   R7 when "111",
				   "0000000000000000" when others;


process(clk,rst) 
begin 
if (rst = '1') then 
R0 <= "0000000000000001"; --1
R1 <= "0000000000000010"; --2
R2 <= "0000000000000011"; --3
R3 <= "0000000000000100"; --4
R4 <= "0000000000100100"; --36
R5 <= "0000000100000100"; --516
R6 <= "0000000001000100"; --132
R7 <= "0000000010000100"; --260
elsif rising_edge(clk) then 
	if reg_write = '1' then
		case write_addr is
		
		when "000" => 
			R0 <= write_data;
			
		when "001" => 
			R1 <= write_data;
		
		when "010" => 
			R2 <= write_data;
		
		when "011" => 
			R3 <= write_data;
		
		when "100" =>
			R4 <= write_data;
		
		when "101" => 
			R5 <= write_data;
			
		when "110" => 
			R6 <= write_data;
			
		when "111" =>
			R7 <= write_data;
		
		when others =>
			null;
		end case;	
	end if;
end if;
end process;
end behavioral;

