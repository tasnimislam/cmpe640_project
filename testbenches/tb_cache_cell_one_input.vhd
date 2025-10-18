-- Testbench for cache_cell
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all;  -- for finish()

entity tb_cache_cell_one_input is
end tb_cache_cell_one_input;

architecture behavior of tb_cache_cell_one_input is

  -- DUT component declaration
  component cache_cell
    port(
      Chip_enable : in  std_logic;
      RD_WR_bar   : in  std_logic;
      Write_Data  : in  std_logic_vector(31 downto 0);
      Read_Data   : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Signals
  signal Chip_enable : std_logic := '0';
  signal RD_WR_bar   : std_logic := '1';  -- '1' means READ, '0' means WRITE
  signal Write_Data  : std_logic_vector(31 downto 0) := (others => '0');
  signal Read_Data   : std_logic_vector(31 downto 0);

begin

  -- DUT instance
  DUT: cache_cell
    port map (
      Chip_enable => Chip_enable,
      RD_WR_bar   => RD_WR_bar,
      Write_Data  => Write_Data,
      Read_Data   => Read_Data
    );

  -- Stimulus process
  stim_proc: process
  begin
    report "=== Starting cache_cell write/read test ===";

    -- Step 1: Initialize
    Chip_enable <= '0';
    RD_WR_bar   <= '1';
    Write_Data  <= (others => '0');
    wait for 10 ns;

    -- Step 2: Write phase
    Chip_enable <= '1';
    RD_WR_bar   <= '0';  -- WRITE mode
    Write_Data  <= x"DEADBEEF";  -- test data
    report "Writing data: DEADBEEF";
    wait for 10 ns;

    -- Step 3: Disable write (simulate latch holding data)
    Chip_enable <= '0';
    wait for 10 ns;

    -- Step 4: Read phase
    Chip_enable <= '1';
    RD_WR_bar   <= '1';  -- READ mode
    report "Reading data...";
    wait for 10 ns;

    -- Step 5: Check the result
    assert (Read_Data = x"DEADBEEF")
      report "Data Mismatch!"
      severity error;

    report "Data matched successfully " 
      severity note;

    -- Step 6: End simulation
    report "=== Test completed successfully ===";
    wait for 10 ns;
    finish;
  end process;

end behavior;


