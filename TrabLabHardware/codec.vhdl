-- Pedro Mello e Igor Mello, Trabalho V1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity codec is
    port (
        interrupt: in std_logic; -- Interrupt signal
        read_signal: in std_logic; -- Read signal
        write_signal: in std_logic; -- Write signal
        valid: out std_logic := '0'; -- Valid signal

        -- Byte written to codec
        codec_data_in : in std_logic_vector(7 downto 0);
        -- Byte read from codec
        codec_data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture flex of codec is
begin
    process (interrupt) is
        type char_file_t is file of character;
        file arquivo : char_file_t;
        file arquivo_saida: text;
        subtype byte_t is natural range 0 to 255; -- ASCII
        variable char_v : character;    
        variable byte_v : byte_t;
        variable linha: line;
        variable valid_aux: std_logic := '0';
    begin
        if read_signal = '1' and write_signal = '0' then
            file_open(arquivo, "test.txt", read_mode);
            while not endfile(arquivo) loop
                read(arquivo, char_v);
                byte_v := character'pos(char_v);
                if byte_v > 31 then  
                    codec_data_out <= std_logic_vector(to_unsigned(byte_v, codec_data_out'length));
                end if;
                -- Pulso em valid
                valid <= not valid_aux;
                valid <= valid_aux;

            end loop;
            file_close(arquivo);

        elsif read_signal = '0' and write_signal = '1' then
            file_open(arquivo_saida, "saida_test.txt", write_mode);
            write(linha, to_integer(unsigned(codec_data_in)));
            writeline(arquivo_saida, linha);
            file_close(arquivo_saida);
            -- Pulso em valid
            valid <= not valid_aux;
            valid <= valid_aux;

        end if;
    end process;
end architecture;