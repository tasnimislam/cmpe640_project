-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity cache_line is
Port(
  line_enable: in std_logic;
  byte_offset: in std_logic_vector(1 downto 0);
  RD_WR_bar: in std_logic;

  Write_Data: in std_logic_vector(31 downto 0);
  Read_Data: out std_logic_vector(31 downto 0)
);
end cache_line;

architecture structural of cache_line is

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

component cache_cell_8bits
Port(
  Chip_enable: in std_logic;
  RD_WR_bar: in std_logic;
  Write_Data: in std_logic_vector(7 downto 0);

  Read_Data: out std_logic_vector(7 downto 0)
);
end component;


component decoder
    Port (
        enable : in STD_LOGIC;
        A0     : in STD_LOGIC;
        A1     : in STD_LOGIC;
        Y0     : out STD_LOGIC;
        Y1     : out STD_LOGIC;
        Y2     : out STD_LOGIC;
        Y3     : out STD_LOGIC
    );
end component;

signal cache_0_chip_enable: std_logic;
signal cache_1_chip_enable: std_logic;
signal cache_2_chip_enable: std_logic;
signal cache_3_chip_enable: std_logic;



begin
  cache_1_output_get: decoder 
    port map (
        enable => line_enable,
        A0     => byte_offset(0), 
        A1     => byte_offset(1),
        Y0     => cache_0_chip_enable,
        Y1     => cache_1_chip_enable,
        Y2     => cache_2_chip_enable,
        Y3     => cache_3_chip_enable
    );

cache_0: cache_cell_8bits
  port map(
    Chip_enable => cache_0_chip_enable,
    RD_WR_bar   => RD_WR_bar,
    Write_Data  => Write_Data(31 downto 24),
    Read_Data   => Read_Data(31 downto 24)
  );

cache_1: cache_cell_8bits
  port map(
    Chip_enable => cache_1_chip_enable,
    RD_WR_bar   => RD_WR_bar,
    Write_Data  => Write_Data(23 downto 16),
    Read_Data   => Read_Data(23 downto 16)
  );

cache_2: cache_cell_8bits
  port map(
    Chip_enable => cache_2_chip_enable,
    RD_WR_bar   => RD_WR_bar,
    Write_Data  => Write_Data(15 downto 8),
    Read_Data   => Read_Data(15 downto 8)
  );

cache_3: cache_cell_8bits
  port map(
    Chip_enable => cache_3_chip_enable,
    RD_WR_bar   => RD_WR_bar,
    Write_Data  => Write_Data(7 downto 0),
    Read_Data   => Read_Data(7 downto 0)
  );

end structural;

