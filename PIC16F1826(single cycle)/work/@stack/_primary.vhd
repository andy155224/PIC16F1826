library verilog;
use verilog.vl_types.all;
entity Stack is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        push            : in     vl_logic;
        pop             : in     vl_logic;
        stack_in        : in     vl_logic_vector(10 downto 0);
        stack_out       : out    vl_logic_vector(10 downto 0)
    );
end Stack;
