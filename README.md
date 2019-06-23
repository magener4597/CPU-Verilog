# Verilog-Display

The display interface is designed to read a number and display it onto a seven-segment display. It uses a decoder and a multiplexer to cycle through the bits, store them into flip flops and then send them to a binary to seven-segment decoder. 
Finally, it sends the converted data to the seven-segment displays. The display controller is what sends the number to be displayed, the address, and the enable bit to the interface.
It reads a BCD number, and converts it into the address and the number to be displayed using a multiplexer, and a counter. The counter selects the address, as it counts through its sequence, it cycles through the addresses.
The multiplexer selects which bits of the BCD number to send to the interface. The binary to BCD converter is then added on to the controller. It reads a binary number, converts it to BCD, then sends it to the controller. 
It uses a series of registers to shift and hold data. Using a parallel adder and comparator it knows whether to keep shifting or stop and send the converted data. The frequency meter and period meters are added onto the existing sections to be able to read a frequency or period and then display it onto the seven segment displays.
The frequency meter stores a frequency value that is inputted onto the FPGA, converts it to a corresponding binary value, then sends it to the binary to BCD converter. The period meter does the same, except it reads a period from a waveform generated onto the FPGA, then converts it to binary and sends it to the binary to BCD converter.
