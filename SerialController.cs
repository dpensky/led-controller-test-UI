using Godot;
using System;
using System.IO.Ports;

// New USB device found, idVendor=1a86, idProduct=7523, bcdDevice= 2.60

public class SerialController : Node
{
    [Signal] delegate void StatusChanged(string message);

    [Export] string PortName = "/dev/ttyUSB0";
    [Export] int BaudRate = 9600;

    private SerialPort _serialPort;

    public override void _Ready()
    {
        GD.Print("[SerialManager] Serial controller loaded");
        GD.Print("Port is: " + PortName);
        GD.Print("Bound rate is: " + BaudRate);
    }


    public void WriteData(string data)
    {
        GD.Print($"[SerialManager] Trying to send character {data} to serial");
        if (_serialPort != null && _serialPort.IsOpen)
        {
            try
            {
                _serialPort.Write(data);
                EmitSignal(nameof(StatusChanged), "Data written");
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[SerialManager] Error sending character: {ex.Message}");
            }
        }
        else
        {
            GD.PrintErr("[SerialManager] Serial port is not open.");
        }
    }

    public void OpenPort()
    {
        GD.Print($"[SerialManager] Trying to open serial port at {PortName}, with {BaudRate} bound rate");
        try
        {
            _serialPort = new SerialPort(PortName, BaudRate);
            _serialPort.Open();
            GD.Print($"[SerialManager] Port {PortName} open.");
            EmitSignal(nameof(StatusChanged), "Port opened");
        }
        catch (Exception ex)
        {
            GD.PrintErr($"[SerialManager] Error opening port: {ex.Message}");
            EmitSignal(nameof(StatusChanged), ex.Message);
        }
    }

    public void ClosePort()
    {
        GD.Print("[SerialManager] Closing serial port");
        if (_serialPort != null && _serialPort.IsOpen)
        {
            _serialPort.Close();
            _serialPort.Dispose();
            GD.Print("[SerialManager] Port closed.");
            EmitSignal(nameof(StatusChanged), "Port closed");
        }
        else
        {
            GD.Print("[SerialManager] Port already closed.");
        }
    }

    public override void _ExitTree()
    {
        ClosePort();
    }

}
