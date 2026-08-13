library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 

entity cpu_alu is
 port( A,B : in STD_LOGIC_vector(15 downto 0);
	  Sel : in STD_Logic_vector(2 downto 0);
	  Result : out STD_LOGIC_vector(15 downto 0);
	  Z : out STD_LOGIC;
	  N : out STD_LOGIC);


end cpu_alu;

architecture behavioral of cpu_alu is
signal R: STD_LOGIC_vector(15 downto 0);
begin
with Sel select
R <= 	  A and B when "000",
		  A or B when "001",
		  A nand B when "010",
		  A nor B when "011",
		  A xor B when "100",
		  B when "101",
		  STD_LOGIC_vector(signed(A) + signed(B)) when "110",
		  STD_LOGIC_vector(signed(A) - signed(B)) when "111",
		  "0000000000000000" when others;
		  
		  



Result <= R;
Z <= '1' when R = "0000000000000000" else '0';
N <= R(15);
end behavioral;
