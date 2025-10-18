-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity cache_cell is
Port(
  Chip_enable: in std_logic;
  RD_WR_bar: in std_logic;
  Write_Data: in std_logic_vector(31 downto 0);

  Read_Data: out std_logic_vector(31 downto 0)
);
end cache_cell;

architecture structural of cache_cell is

component and2

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

component Dlatch                     
  port ( d   : in  std_logic;
         clk : in  std_logic;
         q   : out std_logic;
         qbar: out std_logic); 
end component;

component tx                      
  port ( sel   : in std_logic;
         selnot: in std_logic;
         input : in std_logic;
         output:out std_logic);
end component;

component inverter

  port (
    input    : in  std_logic;
    output   : out std_logic);
end component;

component tx32
  port (
    sel     : in  std_logic;                       -- active-high control
    selnot  : in  std_logic;                       -- complement control
    input   : in  std_logic_vector(31 downto 0);   -- 32-bit input bus
    output  : out std_logic_vector(31 downto 0)    -- 32-bit output bus
  );
end component;

component Dlatch32
  port(
    d    : in  std_logic_vector(31 downto 0);
    clk  : in  std_logic;
    q    : out std_logic_vector(31 downto 0);
    qbar : out std_logic_vector(31 downto 0)
  );
end component;



signal Read_enable: std_logic;
signal Write_enable: std_logic;
signal invert_rd_wr: std_logic;

signal data_inside: std_logic_vector(31 downto 0);
signal data_inside_bar: std_logic_vector(31 downto 0);

signal invert_read_enable: std_logic;

begin

  and_for_read: and2 port map(input1=> Chip_enable, input2=> RD_WR_bar, output=> Read_enable);

  invert_read_write_operation: inverter port map(input=> RD_WR_bar, output=> invert_rd_wr);
  and_for_write: and2 port map(input1=> Chip_enable , input2=>invert_rd_wr, output=> Write_enable);

  write_operation: Dlatch32 port map(d=> Write_Data, clk=> Write_enable, q=> data_inside, qbar=> data_inside_bar);

  invert_read_enable_signal: inverter port map(input=> Read_enable, output=> invert_read_enable);
  read_operation: tx32 port map(sel=> Read_enable, selnot=> invert_read_enable, input=> data_inside, output=> Read_Data);
  
end structural;
