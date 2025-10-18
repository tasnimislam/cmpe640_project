-- Entity: tx32 — 32-bit Transmission Gate
-- Architecture : structural
-- Author: 

library IEEE;
use IEEE.std_logic_1164.all;

entity tx32 is
  port (
    sel     : in  std_logic;                       -- active-high control
    selnot  : in  std_logic;                       -- complement control
    input   : in  std_logic_vector(31 downto 0);   -- 32-bit input bus
    output  : out std_logic_vector(31 downto 0)    -- 32-bit output bus
  );
end tx32;

architecture structural of tx32 is

  component tx 
    port (
      sel    : in  std_logic;
      selnot : in  std_logic;
      input  : in  std_logic;
      output : out std_logic
    );
  end component;

begin
  -- Generate 32 transmission gates
  gen_tx : for i in 31 downto 0 generate
    tx_bit : tx
      port map (
        sel    => sel,
        selnot => selnot,
        input  => input(i),
        output => output(i)
      );
  end generate gen_tx;

end structural;
