-- tb_tx32.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use std.env.all;  -- VHDL-2008 stop() or finish()

entity tb_tx32 is
end tb_tx32;

architecture behavior of tb_tx32 is
  component tx32
    port (
      sel     : in  std_logic;
      selnot  : in  std_logic;
      din     : in  std_logic_vector(31 downto 0);
      dout    : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Clock/data timing
  constant Tclk : time := 10 ns;   -- clock period
  constant NCYC : natural := 12;   -- number of periods

  -- Stim/resp
  signal sel_s     : std_logic := '0';
  signal selnot_s  : std_logic := '1';
  signal din_s     : std_logic_vector(31 downto 0) := (others => '0');
  signal dout_s    : std_logic_vector(31 downto 0);

  -- Patterns: one per cycle (data duration == clock period)
  type vec_array_t is array (natural range <>) of std_logic_vector(31 downto 0);

  constant PAT : vec_array_t(0 to 11) := (
    0  => x"AAAAAAAA",
    1  => x"55555555",
    2  => x"FFFFFFFF",
    4  => x"12345678",
    5  => x"DEADBEEF",
    6  => x"CAFEBABE",
    7  => x"0F0F0F0F",
    8  => x"F0F0F0F0",
    9  => x"13579BDF",
    10 => x"2468ACE0",
    11 => x"89ABCDEF"
  );

begin
  -- DUT
  UUT : tx32
    port map (
      sel    => sel_s,
      selnot => selnot_s,
      din    => din_s,
      dout   => dout_s
    );

  -- Complement control
  selnot_s <= not sel_s;

  -- Clock-like control on sel
  clk_proc : process
  begin
    for i in 1 to NCYC loop
      sel_s <= '0'; wait for Tclk/2;  -- OFF (output should be 'Z')
      sel_s <= '1'; wait for Tclk/2;  -- ON  (transparent)
    end loop;
    wait;
  end process;

  -- Data pattern process
  data_proc : process
  begin
    for k in 0 to NCYC-1 loop
      wait until sel_s'event and sel_s = '0';  -- falling edge
      din_s <= PAT(k);
    end loop;
    wait;
  end process;

  -- Self-checking monitor
  check_proc : process
  begin
    wait for 1 ns;
    for i in 1 to NCYC loop
      -- Transparent half-cycle
      wait until sel_s = '1';
      wait for 1 ns;
      assert dout_s = din_s
        report "Mismatch while gate ON: dout /= din"
        severity error;

      -- High-Z half-cycle
      wait until sel_s = '0';
      wait for 1 ns;
      assert dout_s = (others => 'Z')
        report "Output not Hi-Z while gate OFF"
        severity error;
    end loop;

    wait for 2 ns;
    finish(0);  -- use finish() for cleaner termination
  end process;

end behavior;

