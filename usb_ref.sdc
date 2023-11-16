//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8.11 
//Created Time: 2023-03-31 09:15:03
create_clock -name clkin -period 83.333 -waveform {0 41.666} [get_ports {CLK_IN}] -add
create_clock -name sclk -period 8.333 -waveform {0 4.167} [get_nets {u_USB_SoftPHY_Top/usb2_0_softphy/u_usb_20_phy_utmi/u_usb2_0_softphy/u_usb_phy_hs/sclk}] -add
create_clock -name PHY_CLKOUT -period 16.667 -waveform {0 8.333} [get_nets {PHY_CLKOUT}] -add
create_generated_clock -name fclk_480M -source [get_ports {CLK_IN}] -master_clock clkin -divide_by 1 -multiply_by 40 [get_pins {u_pll/rpll_inst/CLKOUT}]
set_clock_groups -asynchronous -group [get_clocks {PHY_CLKOUT}] -group [get_clocks {sclk}]
set_clock_groups -asynchronous -group [get_clocks {PHY_CLKOUT}] -group [get_clocks {fclk_480M}]
