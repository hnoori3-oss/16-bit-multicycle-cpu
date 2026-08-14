library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_top_level is 
port (
		clk_in : in std_logic;
		rst_in : in std_logic;
		
		cpu_out : out std_logic_vector(15 downto 0)
		
	);
end cpu_top_level;

architecture structural of cpu_top_level is 
component cpu_register is 
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
); end component;

component cpu_alu is 
port (
	A,B : in STD_LOGIC_vector(15 downto 0);
	  Sel : in STD_Logic_vector(2 downto 0);
	  Result : out STD_LOGIC_vector(15 downto 0);
	  Z : out STD_LOGIC;
	  N : out STD_LOGIC);
end component;

component cpu_CU_ver2 is 
port (
	clk : in std_logic;
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
); end component;

component Program_counter is 
port (
	clk : in STD_LOGIC;
	rst : in STD_LOGIC;
	en : in std_logic;
	use_jump : in STD_LOGIC;
	jump_addr : in STD_LOGIC_VECTOR(10 downto 0);
	pc_out : out STD_LOGIC_VECTOR(10 downto 0)
	 ); end component;
	 
component ROM is 
port (
	address : in std_logic_vector(10 downto 0);
	instruction : out std_logic_vector(15 downto 0)
	); end component;

component cpu_ram is 
port (
	clk : in std_logic;
	addr : in std_logic_vector(7 downto 0);
	write_en : in std_logic;
	data_in : in std_logic_vector (15 downto 0);
	data_out : out std_logic_vector (15 downto 0)
);end component;

signal pc_addr : STD_LOGIC_vector(10 downto 0);
signal sig_jump_addr : STD_LOGIC_vector(10 downto 0);
signal sig_use_jump : std_logic;
signal sig_pc_en : std_logic;
signal slow_pc : std_logic;

signal sig_instruction : std_logic_vector(15 downto 0);
signal sig_IR : STD_LOGIC_vector(15 downto 0);
signal opcode_sig : std_logic_vector(4 downto 0);
signal rd, rs : std_logic_vector(2 downto 0); -- destination reg and source reg

signal sig_alu_sel : std_logic_vector(2 downto 0);
signal slow_write_en : std_logic;
signal reg_en_write : std_logic;
signal sig_write_data: std_logic_vector(15 downto 0);
signal sig_ir_write : std_logic;
signal slow_ir : std_logic;

signal R : std_logic_vector(15 downto 0);
signal Neg : std_logic;
signal Zero : std_logic;
signal display_result : std_logic_vector(15 downto 0); 

signal Data_A, Data_B, alu_B_input : std_logic_vector(15 downto 0);
signal imm16 : std_logic_vector(15 downto 0);
signal use_immediate_sig : std_logic;

signal clock_en : std_logic:='0';
signal clock_counter : unsigned(26 downto 0):= (others => '0');


signal write_en_ram : std_logic;
signal sig_ram_data_out : std_logic_vector(15 downto 0);
signal sig_use_r_to_reg : std_logic;
signal slow_ram_write : std_logic;
signal ram_addr: std_logic_vector(7 downto 0);


begin 

process(clk_in, rst_in) 
begin 

if rst_in = '1' then 
clock_en <= '0';
clock_counter <= (others => '0');

elsif (rising_edge(clk_in)) then
	if (clock_counter = to_unsigned(100000000 - 1, clock_counter'length)) then 
		clock_en <= '1';
		clock_counter <= (others => '0');
	else 
	clock_counter <= clock_counter + 1;
	clock_en <= '0';
	
	end if;
end if;
end process;

IR : process(clk_in, rst_in) 
begin 
if (rst_in = '1') then 
	sig_IR <= (others => '0');
elsif(rising_edge(clk_in)) then 
	if (slow_ir = '1') then
		sig_IR <= sig_instruction;
	end if; 
end if;
end process;

Display_REG : process(clk_in, rst_in)
begin
if (rst_in = '1') then 
    display_result <= (others => '0');
elsif (rising_edge(clk_in)) then 
    if (slow_write_en = '1') then 
        display_result <= sig_write_data;
    end if;
end if;
end process;
	
	

opcode_sig <= sig_IR(15 downto 11);
rd <= sig_IR(10 downto 8);
rs <= sig_IR(7 downto 5);
sig_jump_addr <= sig_IR(10 downto 0);
ram_addr <= sig_IR(7 downto 0);


imm16 <= "00000000" & sig_IR(7 downto 0);
alu_B_input <= imm16 when use_immediate_sig = '1' else Data_B;

sig_write_data <= sig_ram_data_out when sig_use_r_to_reg = '1' else R;

cpu_out <= display_result;

slow_write_en <= reg_en_write and clock_en;
slow_ram_write <= write_en_ram and clock_en;
slow_pc <= sig_pc_en and clock_en;
slow_ir <= sig_ir_write and clock_en;



PC_cpu : Program_counter port map (
	clk => clk_in,
	rst => rst_in,
	use_jump => sig_use_jump,
	jump_addr => sig_jump_addr,
	pc_out => pc_addr,
	en => slow_pc
	);
	
ROM1 : ROM port map (
	address => pc_addr,
	instruction => sig_instruction);
	
CTRL1 : cpu_CU_ver2 port map (
	clk => clk_in,
	rst => rst_in,
	clk_ena => clock_en,
	opcode => opcode_sig,
	alu_sel => sig_alu_sel,
	reg_write => reg_en_write,
	ram_write => write_en_ram,
	jump_en => sig_use_jump,
	use_immediate => use_immediate_sig,
	use_ram_to_reg=> sig_use_r_to_reg,
	ir_write => sig_ir_write,
	pc_en => sig_pc_en);
	
REG1 : cpu_register port map (
	clk => clk_in,
	rst => rst_in,
	write_addr=> rd,
	write_data=> sig_write_data,
	read_addr_A => rd,
	read_addr_B => rs,
	reg_write => slow_write_en,
	read_data_A => Data_A,
	read_data_B => Data_B);

ALU1 : cpu_alu port map (
	A => Data_A,
	B => alu_B_input,
	Sel => sig_alu_sel,
	Z => Zero,
	N => Neg,
	Result => R);
	
RAM1 : cpu_ram port map (
	clk => clk_in,
	addr => ram_addr, 
	write_en => slow_ram_write,
	data_in => Data_A,
	data_out => sig_ram_data_out);
	
	
end structural;
	
	
	

	
