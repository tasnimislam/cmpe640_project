library IEEE;
use IEEE.std_logic_1164.all;
use std.env.all;  -- VHDL-2008 for stop()

entity tb_Dlatch32 is
end tb_Dlatch32;

architecture behavior of tb_Dlatch32 is
  component Dlatch32 is
    port(
      d    : in  std_logic_vector(31 downto 0);
      clk  : in  std_logic;
      q    : out std_logic_vector(31 downto 0);
      qbar : out std_logic_vector(31 downto 0)
    );
  end component;

  constant Tclk  : time := 10 ns;   -- clock period
  constant NCYC  : natural := 12;   -- number of cycles to run

  signal d_tb    : std_logic_vector(31 downto 0) := (others => '0');
  signal clk_tb  : std_logic := '0';
  signal q_tb    : std_logic_vector(31 downto 0);
  signal qbar_tb : std_logic_vector(31 downto 0);

  type vec_array_t is array (natural range <>) of std_logic_vector(31 downto 0);
  constant PATTERNS : vec_array_t := (
    x"AAAAAAAA", x"55555555", x"FFFFFFFF", x"00000000",
    x"12345678", x"DEADBEEF", x"CAFEBABE", x"0F0F0F0F",
    x"F0F0F0F0", x"13579BDF", x"2468ACE0", x"89ABCDEF"
  );
begin
  -- DUT
  DUT: Dlatch32
    port map(
      d    => d_tb,
      clk  => clk_tb,
      q    => q_tb,
      qbar => qbar_tb
    );

  -- Clock: exact period Tclk, finite duration
  clock_gen : process
  begin
    for i in 1 to NCYC loop
      clk_tb <= '0'; wait for Tclk/2;
      clk_tb <= '1'; wait for Tclk/2;
    end loop;
    wait;  -- idle; supervisor will stop sim
  end process;

  -- Data: change once per clock period (equal cycle),
  -- align updates to falling edge so data is stable during clk='1'
  data_gen : process
  begin
    for k in 0 to NCYC-1 loop
      wait until falling_edge(clk_tb);
      d_tb <= PATTERNS(k);
    end loop;
    wait;
  end process;

  -- Supervisor: stop cleanly
  finish_proc : process
  begin
    wait for (NCYC * Tclk + 2 ns);
    stop(0);
  end process;

end behavior;
