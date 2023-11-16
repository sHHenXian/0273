module aec (
    input wire clk,
    input wire reset,
    input wire  mixed_signal,      // 16-bit 麦克风采集的信号
    input wire  speaker_signal,    // 16-bit 远端讲话声
    output reg  output_signal      // 16-bit 处理后的输出信号
);

// 定义自适应滤波器的一些参数
reg [15:0] cft;                       // 系数
reg [15:0] estimated_echo;                // 估计回音
reg [15:0] error_signal;                  // 误差
parameter mu = 16'h0CCC;                 // 步长为0.05，表示为定点形式

always @(posedge clk or posedge reset) begin
//复位
    if (reset) begin
        output_signal <= 16'd0;
        estimated_echo <= 16'd0;
        error_signal <= 16'd0;
        cft <= 16'd0;

    end else begin
        
        //估计回音
        estimated_echo <= estimated_echo + (speaker_signal * cft);
        
        //实际输出
        output_signal <= mixed_signal - estimated_echo;

        // 误差计算
        error_signal <= mixed_signal - estimated_echo;

        // 使用LMS算法更新权重

            cft <= cft + mu * error_signal * speaker_signal;
        
    end
end

endmodule
