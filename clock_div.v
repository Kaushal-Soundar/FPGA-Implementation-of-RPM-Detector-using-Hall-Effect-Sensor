module clock_div #(
    parameter SYS_CLK_FREQ = 100_000_000,   // Input clock frequency (Hz)
    parameter TICK_FREQ    = 1              // Output tick frequency (Hz)
)(
    input  wire clk,      
    input  wire rst,      
    output reg  tick      
);

    localparam integer DIV_COUNT = SYS_CLK_FREQ / TICK_FREQ;
    localparam integer CW = $clog2(DIV_COUNT);

    reg [CW-1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            tick  <= 0;
        end else begin
            if (count == DIV_COUNT-1) begin
                count <= 0;
                tick  <= 1'b1;   // assert tick for exactly 1 cycle
            end else begin
                count <= count + 1;
                tick  <= 1'b0;   // clear tick on all other cycles
            end
        end
    end

endmodule
