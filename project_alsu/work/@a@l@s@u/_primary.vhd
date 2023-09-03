library verilog;
use verilog.vl_types.all;
entity ALSU is
    generic(
        INPUT_PERIORITY : string  := "A";
        FULL_ADDER      : string  := "ON"
    );
    port(
        A               : in     vl_logic_vector(2 downto 0);
        B               : in     vl_logic_vector(2 downto 0);
        opcode          : in     vl_logic_vector(2 downto 0);
        cin             : in     vl_logic;
        serial_in       : in     vl_logic;
        direction       : in     vl_logic;
        red_op_A        : in     vl_logic;
        red_op_B        : in     vl_logic;
        bypass_A        : in     vl_logic;
        bypass_B        : in     vl_logic;
        CLK             : in     vl_logic;
        RST_n           : in     vl_logic;
        \out\           : out    vl_logic_vector(5 downto 0);
        leds            : out    vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INPUT_PERIORITY : constant is 1;
    attribute mti_svvh_generic_type of FULL_ADDER : constant is 1;
end ALSU;
