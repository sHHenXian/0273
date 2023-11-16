module mic (
    input wire clk,              // 时钟信号
    //input wire reset,            // 复位信号
    input wire mic_in0,   // 第一个麦克风信号输入（16位宽）
    input wire mic_in1,   // 第二个麦克风信号输入（16位宽）
    input wire mic_in2,   // 第三个麦克风信号输入（16位宽）
    input wire mic_in3,   // 第四个麦克风信号输入（16位宽）
    output wire i2s_data,        // I2S音频数据输出
    output wire i2s_clk,         // I2S时钟输出
    output wire i2s_lrclk        // I2S帧同步信号输出
);

// 定义参数
parameter SAMPLE_RATE = 48000; // 采样频率 48 kHz
parameter word_len = 16; // 设置 word_len 为 16

wire lrc_edge;

// 定义局部变量
reg aud_lrc_d0 = 0;
reg [5:0] sample_counter = 0; // 采样计数器
reg [15:0] audio_data1 = 16'h0000; // 用于存储I2S格式的音频数据
reg [15:0] audio_data2 = 16'h0000;
reg [15:0] audio_data3 = 16'h0000;
reg [15:0] audio_data4 = 16'h0000;

assign lrc_edge = i2s_lrclk ^ aud_lrc_d0;

always @(posedge i2s_clk /*or posedge reset*/) begin
    /*if (reset)*/
        aud_lrc_d0 <= 1'b0;
    /*else*/
        aud_lrc_d0 <= i2s_lrclk;
end

always @(posedge i2s_clk /*or posedge reset*/) begin
    /*if (reset) begin
        sample_counter <= 0;
        audio_data1 <= 16'h0000;
        audio_data2 <= 16'h0000;
        audio_data3 <= 16'h0000;
        audio_data4 <= 16'h0000;
    end else begin*/
        if (sample_counter <= word_len) begin
            sample_counter <= sample_counter + 1;
            audio_data1 <= {audio_data1, mic_in0}; // I2S格式
            audio_data2 <= {audio_data2, mic_in1};
            audio_data3 <= {audio_data3, mic_in2};
            audio_data4 <= {audio_data4, mic_in3};
        /*end*/
    end
end

// 生成I2S时钟和帧同步信号
assign i2s_clk = clk;     // I2S时钟与系统时钟一致
assign i2s_lrclk = 1'b1;  // I2S帧同步信号可以根据需要进一步配置

// 输出I2S音频数据
assign i2s_data = {audio_data1,audio_data2,audio_data3,audio_data4};

endmodule
