library IEEE;
use IEEE.std_logic_1164.all;

entity cpu_CU_ver2 is 
port ( clk : in std_logic;
	   rst : in std_logic;
	   clk_ena : in std_logic;
	   opcode : in std_logic_vector (4 downto 0);
	   alu_sel : out std_logic_vector (2 downto 0);
	   reg_write : out std_logic; -- write to register
	   ram_write : out std_logic; -- write to ram
	   use_immediate : out std_logic; -- use immediate value 
	   use_ram_to_reg : out std_logic; -- use ram data as input to reg
	   jump_en : out std_logic; --allows pc to jump addr
	   ir_write : out std_logic;
	   pc_en : out std_logic
); end cpu_CU_ver2;

architecture behavioral of cpu_CU_ver2 is 

type state_type is (FETCH, DECODE, EXECUTE, WRITEBACK);
signal present_state, nxt_state : state_type;
begin	   
state_reg:process(clk, rst) 
begin 
if (rst = '1') then 
	present_state <= FETCH;
elsif(rising_edge(clk)) then
	if(clk_ena = '1') then
		present_state <= nxt_state;
	end if;
end if;
end process;

next_state:process(present_state, opcode)
begin 
nxt_state <= present_state;
case present_state is 
	when FETCH => 
		nxt_state <= DECODE;
	when DECODE => 
		nxt_state <= EXECUTE;
	when EXECUTE => 
		case opcode is 
			when "01001" =>
				nxt_state <= WRITEBACK;
			when others =>
				nxt_state <= FETCH;
		end case;
	when WRITEBACK => 
		nxt_state <= FETCH;
	when others =>
		nxt_state <= FETCH;
end case;
end process;

output : process(present_state, opcode)
begin 
alu_sel <= "000";
reg_write <= '0';
ram_write <= '0';
use_immediate <= '0';
use_ram_to_reg <= '0';
jump_en <= '0';
ir_write <= '0';
pc_en <= '0';
case present_state is 
	when FETCH =>
		ir_write <= '1';
		pc_en <= '1';
	when DECODE => 
		null;
	when EXECUTE =>
		case opcode is 
			when "00000" | "00001" | "00010" | "00011" | "00100" | "00101" | "00110" | "00111" =>
				alu_sel <= opcode(2 downto 0);
				reg_write <= '1';
			when "01000" =>
				alu_sel <= "101";
				reg_write <= '1';
				use_immediate <= '1';
			when "01001" =>
				null;
			when "01010" =>
				ram_write <= '1';
			when "01011" =>
				jump_en <= '1';
				pc_en <= '1';
			when others => 
				null;
		end case;
	when WRITEBACK =>
		reg_write <= '1';
		use_ram_to_reg <= '1';
end case;
end process;
end behavioral;
	
