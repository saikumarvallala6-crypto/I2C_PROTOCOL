//==============================================================================
// Module Name : i2c_top_system
// Author      : vallala saikumar
// Project     : I2C Protocol Implementation in Verilog
//
// Description :
// -----------------------------------------------------------------------------
// Top-level integration module connecting the I2C Master and I2C Slave through
// a common I2C bus.
//
// Responsibilities:
// - Instantiates Master and Slave modules.
// - Creates shared SDA and SCL bus.
// - Models physical pull-up resistors.
// - Provides external interface for simulation.
//
// Notes:
// - Used only for integration.
// - Contains no protocol logic.
// - Represents a simple one-master one-slave I2C bus.
//
//==============================================================================

`include "i2c_master.sv"
`include "i2c_slave.sv"

module i2c_top_system (
    input wire clk,
    input wire rst,
    input wire start,
    input wire rw,                     
    input wire [6:0] slave_addr,
    input wire [7:0] master_write_data,
    output wire [7:0] master_read_data,
    input wire [7:0] slave_tx_data,    
    output wire [7:0] slave_rx_data,   
    output wire master_ready,
    output wire master_ack_err,
    output wire slave_rx_valid
);

    wire scl;
    wire sda;

	// Physical pull-up resistors
	// Required for open-drain I2C communication.
    pullup(scl);
    pullup(sda);

	// I2C Master Instance
    i2c_master master_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .rw(rw),
        .addr(slave_addr),
        .data_in(master_write_data),
        .data_out(master_read_data),
        .i2c_scl(scl),
        .i2c_sda(sda),
        .ready(master_ready),
        .ack_error(master_ack_err)
    );

	// I2C Slave Instance
    i2c_slave slave_inst (
        .clk(clk), // Clock provided to clean sampling errors
        .rst(rst),
        .i2c_scl(scl),
        .i2c_sda(sda),
        .tx_data(slave_tx_data),
        .rx_data(slave_rx_data),
        .rx_valid(slave_rx_valid)
    );

endmodule
