# GunChamber

A 3D parkour-style game built with Godot Engine, featuring player movement mechanics and level generation.

## Features

### Player Movement System
- Basic movement with WASD controls
- Jumping mechanics
  - Ground jump
  - Wall jump capabilities
- Mouse-based camera control
- Gravity and floor detection

### Level Features
- Procedurally created level elements:
  - Basic floor (20x20 units)
  - Parkour platforms at various heights
  - Wall obstacles
- Dynamic platform and wall generation system

### UI Elements
- Pause Menu System
  - Resume game functionality
  - Settings menu (planned)
  - Quit game option
- Mouse capture/release system for game control

## Controls
- WASD - Movement
- Space - Jump
- Mouse - Camera control
- ESC - Toggle pause menu

## Technical Architecture

### Core Systems
1. **Player Controller (`player_controller.gd`)**
   - Handles player input
   - Camera control
   - Pause menu integration

2. **Action System**
   - `ActionManager`: Manages all player actions
   - Modular action system with:
     - `MoveAction`: Basic player movement
     - `JumpAction`: Jump and wall-jump mechanics

3. **Level Generation (`level_setup.gd`)**
   - Creates the game environment
   - Generates platforms and walls
   - Sets up collision detection

4. **Menu System (`menu.gd`)**
   - Pause menu functionality
   - Game state management
   - UI interaction handling

## Development Status
This project is currently under active development. Key features implemented:
- Basic movement and control system
- Level generation fundamentals
- Core game architecture
- Pause menu system

## Planned Features
- Settings menu implementation
- Additional game mechanics
- Enhanced level generation
- More parkour elements

## Getting Started
1. Open the project in Godot Engine
2. Run the main scene to test the current implementation
3. Use WASD to move and Space to jump
4. Press ESC to access the pause menu

## Contributing
The project is open for contributions. Feel free to submit pull requests or open issues for bugs and feature requests.

# Signing
keytool -genkeypair -alias frozenproof -keyalg RSA -keysize 2048 -keystore mykeystore.jks -validity 999999999

my birthday without /