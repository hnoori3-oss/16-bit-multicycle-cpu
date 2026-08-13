library IEEE;
use ieee.std_logic_1164.all;

entity ROM is 
port (
	address : in std_logic_vector(10 downto 0);
	instruction : out std_logic_vector(15 downto 0)
	);
end ROM;


architecture behavioral of ROM is 

begin 

with address select 

instruction <=
	"0000000000100000" when "00000000000", -- AND R0, R1
	"0011000101000000" when "00000000001", -- ADD R1, R2
	"0011101100100000" when "00000000010", -- SUB R3, R1
	"0000100101000000" when "00000000011", -- OR R1, R2
	"0001000001000000" when "00000000100", -- NAND R0, R2
	"0010100101000000" when "00000000101", -- MOV R1, R2
	"0010001101000000" when "00000000110", -- XOR R3, R2
	"0001100001100000" when "00000000111", -- NOR R0, R3
	"0100000100000011" when "00000001000", -- LOADI R1, 3
	"0101000100000011" when "00000001001", -- store R1 in ram 3
	"0100101000000011" when "00000001010",  -- Load R2 with ram data 3
	"0101100000000001" when "00000001011",  -- jump to instruction 1
	"0000000000000000" when others;
end behavioral;