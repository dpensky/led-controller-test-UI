# 💡 LED Controller UI

This project is a **Godot 3.6** application for testing and controlling an external **LED controller hardware** via **Serial Communication**.

The user interface allows you to:

- Select one of **six colors**.
- Choose between **four lighting effects**.
- Adjust **intensity** across **nine levels**.
- Enable special options like:
  - **Turn Off** all LEDs
  - **Loop Effects**
  - **Glow Effect**

---

## 🗂️ Project Structure

- **`LEDControllerUI.tscn`** — Main scene containing the user interface layout.
- **`LEDController.gd`** — Godot script managing UI signals and sending commands to the hardware.
- **`SerialController.cs`** — C# class for handling serial port communication:
  - Open/Close the serial connection
  - Send formatted commands to the LED controller

---

## 🖥️ Requirements

- **Godot Engine 3.6** (C# version installed)
- **.NET SDK** for Godot 3 C# support
- An available **Serial Port** connected to your LED controller hardware.

---

## ▶️ How To Run

1. Open the project with **Godot 3.6**.
2. Build the project to ensure the C# scripts compile.
3. Configure the `SerialController.cs` with your correct **COM Port** and **baud rate**.
4. Press **Play** and start interacting with the UI.
5. The LED hardware should reflect changes immediately!

---

## ⚖️ License

MIT License
