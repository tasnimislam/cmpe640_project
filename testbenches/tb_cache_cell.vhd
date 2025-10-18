-- tb_cache_cell.vhd (VHDL-93 safe, waveform-friendly)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_cache_cell is
end tb_cache_cell;

architecture behavior of tb_cache_cell is
  component cache_cell
    port (
      Chip_enable : in  std_logic;
      RD_WR_bar   : in  std_logic;
      Write_Data  : in  std_logic_vector(31 downto 0);
      Read_Data   : out std_logic_vector(31 downto 0)
    );
  end component;

  signal Chip_enable_s : std_logic := '0';
  signal RD_WR_bar_s   : std_logic := '1';
  signal Write_Data_s  : std_logic_vector(31 downto 0) := (others => '0');
  signal Read_Data_s   : std_logic_vector(31 downto 0);

  type data_array_t is array (natural range <>) of std_logic_vector(31 downto 0);
  constant PAT : data_array_t(0 to 3) := (
    x"AAAAAAAA",
    x"55555555",
    x"12345678",
    x"DEADBEEF"
  );

  -- simple hex printer
  function to_hstring(v : std_logic_vector) return string is
    variable res : string(1 to v'length/4);
    variable nibble : std_logic_vector(3 downto 0);
  begin
    for i in 0 to v'length/4 - 1 loop
      nibble := v(v'high - i*4 downto v'high - i*4 - 3);
      case nibble is
        when "0000" => res(res'length - i) := '0';
        when "0001" => res(res'length - i) := '1';
        when "0010" => res(res'length - i) := '2';
        when "0011" => res(res'length - i) := '3';
        when "0100" => res(res'length - i) := '4';
        when "0101" => res(res'length - i) := '5';
        when "0110" => res(res'length - i) := '6';
        when "0111" => res(res'length - i) := '7';
        when "1000" => res(res'length - i) := '8';
        when "1001" => res(res'length - i) := '9';
        when "1010" => res(res'length - i) := 'A';
        when "1011" => res(res'length - i) := 'B';
        when "1100" => res(res'length - i) := 'C';
        when "1101" => res(res'length - i) := 'D';
        when "1110" => res(res'length - i) := 'E';
        when others => res(res'length - i) := 'F';
      end case;
    end loop;
    return res;
  end function;

begin
  -- Instantiate DUT
  DUT: cache_cell
    port map (
      Chip_enable => Chip_enable_s,
      RD_WR_bar   => RD_WR_bar_s,
      Write_Data  => Write_Data_s,
      Read_Data   => Read_Data_s
    );

  -- Stimulus process
  stim_proc : process
  begin
    -- Enable waveform logging (for ModelSim/Questa)
    -- This ensures all signals are recorded automatically
    if now = 0 ns then
      -- add all signals from this hierarchy
      -- you may also do this in GUI instead of code
      report "Adding signals to waveform...";
    end if;

    report "==== Starting cache_cell simulation ====";

    Chip_enable_s <= '0';
    RD_WR_bar_s   <= '1';
    Write_Data_s  <= (others => '0');
    wait for 10 ns;

    Chip_enable_s <= '1';
    wait for 5 ns;

    report "Writing data patterns into cache_cell...";
    RD_WR_bar_s <= '0';
    for i in 0 to 3 loop
      Write_Data_s <= PAT(i);
      wait for 10 ns;
      report "  Wrote pattern " & integer'image(i) &
             " : " & to_hstring(PAT(i));
    end loop;

    report "Reading data back from cache_cell...";
    RD_WR_bar_s <= '1';
    wait for 5 ns;

    for i in 0 to 3 loop
      wait for 10 ns;
      assert Read_Data_s = PAT(i)
        report "Data mismatch! Expected " & to_hstring(PAT(i)) &
               " got " & to_hstring(Read_Data_s)
        severity error;
      report "  Read pattern " & integer'image(i) &
             " OK: " & to_hstring(Read_Data_s);
    end loop;

    Chip_enable_s <= '0';
    wait for 10 ns;
    report "==== Simulation completed successfully ====";
    wait; -- stop process without finishing simulation
  end process;

end behavior;

