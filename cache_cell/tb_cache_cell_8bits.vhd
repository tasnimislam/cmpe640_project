-- ============================================================
-- Testbench: tb_cache_cell_8bits_print.vhd
-- Purpose   : Prints operations and signal values to console
-- Duration  : 200 ns (stops exactly at 200 ns)
-- ============================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_cache_cell_8bits_print is
end entity;

architecture sim of tb_cache_cell_8bits_print is

  -- DUT ports
  signal Chip_enable : std_logic := '0';
  signal RD_WR_bar   : std_logic := '1';  -- 1=Read, 0=Write
  signal Write_Data  : std_logic_vector(7 downto 0) := (others => '0');
  signal Read_Data   : std_logic_vector(7 downto 0);

  -- Helper function for printing vectors
  function slv_to_string(slv : std_logic_vector) return string is
    variable s : string(1 to slv'length);
    variable k : integer := 1;
  begin
    for i in slv'reverse_range loop
      case slv(i) is
        when '0' => s(k) := '0';
        when '1' => s(k) := '1';
        when 'Z' => s(k) := 'Z';
        when 'X' => s(k) := 'X';
        when 'U' => s(k) := 'U';
        when others => s(k) := '?';
      end case;
      k := k + 1;
    end loop;
    return s;
  end function;

  -- Utility procedure to print signals with timestamp (ns)
  procedure print_state(msg : in string) is
  begin
    report "[" & integer'image(integer(now/1 ns)) & " ns] " & msg &
           " | CE=" & std_logic'image(Chip_enable) &
           " | RD_WR_bar=" & std_logic'image(RD_WR_bar) &
           " | Write_Data=" & slv_to_string(Write_Data) &
           " | Read_Data=" & slv_to_string(Read_Data)
           severity note;
  end procedure;

  -- Procedures for write/read
  procedure do_write(b : in std_logic_vector(7 downto 0)) is
  begin
    Write_Data  <= b;
    Chip_enable <= '1';
    RD_WR_bar   <= '0';  -- Write
    wait for 10 ns;
    print_state("WRITE operation");
    Chip_enable <= '0';
    RD_WR_bar   <= '1';
    wait for 5 ns;
  end procedure;

  procedure do_read is
  begin
    Chip_enable <= '1';
    RD_WR_bar   <= '1';  -- Read
    wait for 5 ns;
    print_state("READ operation");
    Chip_enable <= '0';
    wait for 5 ns;
  end procedure;

begin
  -- DUT instantiation (ensure 'cache_cell_8bits' and 'structural' exist)
  DUT: entity work.cache_cell_8bits(structural)
    port map (
      Chip_enable => Chip_enable,
      RD_WR_bar   => RD_WR_bar,
      Write_Data  => Write_Data,
      Read_Data   => Read_Data
    );

  -- Stimulus
  stim: process
  begin
    report "===== Simulation Start =====" severity note;

    wait for 10 ns;
    print_state("Initial idle state");

    -- WRITE 0xA5, then READ
    do_write(x"A5");
    do_read;

    -- WRITE 0x3C, then READ
    do_write(x"3C");
    do_read;

    -- Invalid write when CE=0 (should have no effect)
    Chip_enable <= '0';
    RD_WR_bar   <= '0';
    Write_Data  <= x"FF";
    wait for 10 ns;
    print_state("Attempted WRITE with CE=0 (no effect expected)");

    -- READ back previous value
    do_read;

    -- Disable read, expect tri-state (design-dependent)
    Chip_enable <= '0';
    RD_WR_bar   <= '1';
    wait for 10 ns;
    print_state("Disabled READ (expect Z state)");

    -- Align to exactly 200 ns before stopping
    if now < 200 ns then
      wait for 200 ns - now;
    end if;
    report "===== Simulation Complete (200 ns) =====" severity note;

    -- Stop (VHDL-2008); if your tool doesn't support std.env.stop, use the assert line.
    std.env.stop;
    wait;  -- keep process quiescent
    -- assert false report "Simulation finished" severity failure; -- VHDL-93 fallback

  end process;

end architecture sim;

