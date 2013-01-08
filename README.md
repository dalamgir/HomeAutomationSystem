HomeAutomationSystem
====================

INTRODUCTION
============

The aim of the project is to design a complete System-on-a-chip for an embedded system, for deployment on an FPGA platform. The application of this System-on-a-chip will be that of a controller for an electronic home automation system, using which one will be able to use a single remote to conveniently control various appliances commonly found in a house. It will have
a basic Operating System along with certain applications designed to interface with common
peripherals. The system will be designed using the Verilog hardware description language, with
ModelSim being used as the primary development environment.

PROJECT DESCRIPTION
===================

The aim of the project is to design a controller for an electronic home automation system, to
allow the user to control multiple peripherals from one place. The peripherals the controller
interfaces with are:

Home security system
Garage door opener
Thermostat
Home theater system
USB

The controller interfaces with these peripherals using the Bluetooth protocol.

The primary parts of this project are:

Processor design
Control Unit
Bus structure design
Memory design
Peripheral design
Peripheral Application design

DESIGN
======

The design of the processor is based on the ARM version 7 specifications, as ARM is the
dominant RISC processor on the market for embedded systems. ARM 7 is a RISC processor,
which is suitable for use as RISC architectures have a small number of instructions that are
performed very efficiently. Since this system does not require many instructions, and speed is a
priority due to the home security system, a RISC architecture best suits the needs of the design.

The aim of the system is to allow the user to control their appliances conveniently from one
place, using a single interface. The system should be small and lightweight, which will allow it
to be portable, easily installable, and easy to use. In addition, the system must be able to handle
inputs from many different appliances and ensure that certain tasks have more importance than
others while not impacting performance as much as possible for the other appliances. Therefore, a priority interrupt-driven control was chosen as to maximize response time for all appliances
while making sure that high-priority applications such as home security will not be ignored.

DESIGN SPECIFICATION
====================

Home Security

The home security system is designed to monitor the doors and windows of a house, allow the
user to arm and disarm it using a PIN, and sound an alarm if any of them is breached while the
system is armed.

Garage Door Opener

The garage door system allows the user to open and close a garage door, and check its current
status.

Thermostat

The thermostat allows the user to increase/decrease the current temperature, or set it to a preset
temperature.

Home Theater

The home theater system allows the user to control the states of the system such as play, pause,
rewind, fast-forward, stop, increase and decrease volume.

USB

The USB system allows the user to plug in a USB storage device, and it will then store the log
files on the USB device and update the firmware of the system.