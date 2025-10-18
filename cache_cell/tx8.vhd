-- Entity: tx8 — 8-bit Transmission Gate
-- Architecture : structural
-- Author: 

library IEEE;
use IEEE.std_logic_1164.all;

entity tx8 is
  port (
    sel     : in  std_logic;                       -- active-high control
    selnot  : in  std_logic;                       -- complement control
    input   : in  std_logic_vector(7 downto 0);   -- 8-bit input bus
    output  : out std_logic_vector(7 downto 0)    -- 8-bit output bus
  );
end tx8;

architecture structural of tx8 is

  component tx 
    port (
      sel    : in  std_logic;
      selnot : in  std_logic;
      input  : in  std_logic;
      output : out std_logic
    );
  end component;

begin
  -- Generate 8 transmission gates
  gen_tx : for i in 7 downto 0 generate
    tx_bit : tx
      port map (
        sel    => sel,
        selnot => selnot,
        input  => input(i),
        output => output(i)
      );
  end generate gen_tx;

end structural;
