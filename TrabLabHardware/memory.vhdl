-- Pedro Mello e Igor Mello, Trabalho V1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity memory is
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
    );
    port (
        clock: in std_logic; -- Clock signal; Write on Falling-Edge
    
        data_read : in std_logic; -- When '1', read data from memory
        data_write: in std_logic; -- When '1', write data to memory
        -- Data address given to memory
        data_addr : in std_logic_vector(addr_width-1 downto 0);
        -- Data sent from memory when data_read = '0' and data_write = '1'
        data_in : in std_logic_vector(data_width-1 downto 0);
        -- Data sent to memory when data_read = '1' and data_write = '0'
        data_out : out std_logic_vector((data_width*4)-1 downto 0)
    );
end entity;

architecture behavioral of memory is

    type matriz_memoria is array(2**addr_width-1 downto 0) of std_logic_vector((data_width-1) downto 0);

    signal mem: matriz_memoria := (others => (others => '0'));
    begin
    process (clock)
        begin
            if falling_edge(clock) then
                if (data_read = '0') and (data_write = '1') then
                    mem(to_integer(unsigned(data_addr))) <= data_in;
                elsif (data_read = '1') and (data_write = '0') then
                    data_out <= mem(to_integer(unsigned(data_addr))) &
                                mem(to_integer(unsigned(data_addr))+1) &
                                mem(to_integer(unsigned(data_addr))+2) &
                                mem(to_integer(unsigned(data_addr))+3);
                end if;
            end if;
    end process;

end behavioral;
            

-- vou jogar o when na lista de sensibilidade de um processo
