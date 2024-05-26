package my_pkg;

    // Define parameters
    parameter TRUE_T = 1'b1;
    parameter FALSE_T = 1'b0;
    parameter CLOCK_CYCLE_T = 10; 
    parameter CLOCK_WIDTH_T = CLOCK_CYCLE_T/2;
    parameter IDLE_CLOCKS_T = 2;

    // Define common data types 
    typedef bit bit_t;
    typedef logic [7:0] byte_t;
    typedef logic [6:0] address_t;
    typedef logic wr_en_t;
    typedef logic done_t;
    typedef bit ACKT_t;
 
endpackage
