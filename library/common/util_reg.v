`timescale 1ns/100ps

module util_reg #(
    parameter IS_FF = 0,
    parameter NUM_OF_BITS = 1,
    parameter CLK_EDGE=1,
    parameter ACTIVE_RESET=1,
    parameter ACTIVE_GATE=1,
    parameter RESET_ASYNC = 0,
    parameter [NUM_OF_BITS-1:0]  INIT={NUM_OF_BITS{1'b0}},
    parameter [NUM_OF_BITS-1:0]  RESET_VALUE ={NUM_OF_BITS{1'b0}}
   

)
(
    input [NUM_OF_BITS-1:0] d,
    input  clk,
    input  en,
    input  reset,
    input resetn,
    input  gate,
    input gaten,
    output reg  [NUM_OF_BITS-1:0] q = INIT

);

wire rst;
wire gt;

assign rst= ACTIVE_RESET ? reset : resetn;
assign gt= ACTIVE_GATE ? gate : gaten;

generate 
    if (IS_FF==1) begin
        if (CLK_EDGE == 0) begin
            if(RESET_ASYNC == 0) begin
                always @(negedge clk) begin
                    if(rst== ACTIVE_RESET) begin
                        q<= RESET_VALUE;
                    end else if (en==1'b1) begin
                        q<=d;
                    end
                end
            end else if (RESET_ASYNC == 1)begin
                  if (ACTIVE_RESET == 0) begin
                    always @(negedge clk or negedge rst ) begin
                        if(rst== ACTIVE_RESET) begin
                            q<= RESET_VALUE;
                        end else if (en==1'b1) begin
                            q<=d;
                        end
                    end

                  end if (ACTIVE_RESET == 1) begin
                    always @(negedge clk or posedge rst ) begin
                        if(rst== ACTIVE_RESET) begin
                            q<= RESET_VALUE;
                        end else if (en==1'b1) begin
                            q<=d;
                        end
                    end
                 end
            end
          
        end else if (CLK_EDGE == 1) begin
            if(RESET_ASYNC == 0) begin
                always @(posedge clk) begin
                    if(rst== ACTIVE_RESET) begin
                        q<= RESET_VALUE;
                    end else if (en==1'b1) begin
                        q<=d;
                    end
                end
            end else if (RESET_ASYNC == 1)begin
                  if (ACTIVE_RESET == 0) begin
                      always @(posedge clk or negedge rst ) begin
                        if(rst== ACTIVE_RESET) begin
                            q<= RESET_VALUE;
                        end else if (en==1'b1) begin
                            q<=d;
                        end
                    end
                  end if (ACTIVE_RESET == 1) begin
                      always @(posedge clk or posedge rst ) begin
                        if(rst== ACTIVE_RESET) begin
                            q<= RESET_VALUE;
                        end else if (en==1'b1) begin
                            q<=d;
                        end
                    end
                 end
            end
           
        end
    end else if (IS_FF==0) begin
        always @(*) begin
            if(rst==ACTIVE_RESET) begin
                q<= RESET_VALUE;
            end else if (en==1'b1) begin
            if(gt == ACTIVE_GATE) begin
                q<=d;
            end
            end
        end

    end
endgenerate

endmodule
