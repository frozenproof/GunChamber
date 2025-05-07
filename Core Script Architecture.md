# Core Script Architecture

### 1. Player System

#### Player Controller (`player/player_controller.gd`)
- Main player control script
- Manages input processing
- Coordinates with ActionManager for movement and abilities
- Handles camera control and pause functionality
- Key relationships:
  - Uses `ActionManager` for executing actions
  - Controls the `CameraPivot` node
  - Integrates with pause menu system

#### Action Manager (`player/action_manager.gd`)
```gdscript
class_name ActionManager
extends Node

var actions: Dictionary = {}
var player: CharacterBody3D
var db_manager: DBManager

const CORE_ACTION_ID = 1000
const SKILL_ACTION_ID = 3
```
- Central system for managing all player actions
- Loads and initializes actions from database
- Maintains a dictionary of available actions
- Key relationships:
  - Parent: `CharacterBody3D` (player)
  - Uses `DBManager` for loading action data
  - Manages individual action scripts like `MoveAction` and `JumpAction`

### 2. Action System

#### Base Action Class (`player/player_action.gd`)
```gdscript
class_name PlayerAction
extends Resource

@export var action_name: String = ""
@export var action_enabled: bool = true
```
- Base class for all player actions
- Provides common action functionality
- Enforces action implementation structure

#### Move Action (`actions/scripts/move_action.gd`)
```gdscript
class_name MoveAction
extends Node

@export var move_speed: float = 10.0
@export var acceleration: float = 3.0
@export var deceleration: float = 9.0
```
- Handles player movement
- Processes input direction
- Applies camera-relative movement

#### Jump Action (`actions/scripts/jump_action.gd`)
```gdscript
class_name JumpAction
extends Node

@export var jump_force: float = 4.5
@export var max_jumps: int = 2
@export var wall_jump_force: float = 2.0
```
- Manages jumping mechanics
- Handles both ground and wall jumps
- Tracks jump count and resets on ground contact

### 3. Database System

#### DB Manager (`db/db_manager.gd`)
```gdscript
class_name DBManager
extends Node

var DB_PATH_ACTION = DbHelperUtils.DB_PATH_BASE_ACTIONS
var DB_TABLE_NAME_ACTIONS_BASE2 = DbHelperUtils.DB_TABLE_NAME_ACTIONS_BASE
```
- Manages database connections and queries
- Handles action and map data storage
- Initializes database structure if not exists

#### DB Helper (`db/db_helper.gd`)
```gdscript
class_name DbHelperUtils

static var DB_PATH_MAIN = "res://data/"
static var DB_PATH_BASE_ACTIONS = DB_PATH_MAIN + "base_action.db"
```
- Provides utility functions for database operations
- Defines database paths and table structures
- Handles database creation and queries

### 4. Level System

#### Level Setup (`map/level_setup.gd`)
```gdscript
extends Node3D

func _ready() -> void:
    # Create floor and platforms
```
- Manages level generation and layout
- Creates basic environment elements
- Handles platform and wall creation
- Key relationships:
  - Uses `DBManager` for map data
  - Creates physical elements using Godot's 3D nodes

## Script Interaction Flow

1. **Initialization Flow**:
   ```plaintext
   Player Controller
   ├─► Action Manager
   │    ├─► DB Manager (loads action data)
   │    └─► Individual Actions (move, jump, etc.)
   └─► Level Setup (creates environment)
   ```

2. **Action Execution Flow**:
   ```plaintext
   Input
   ├─► Player Controller
   ├─► Action Manager
   │    ├─► Move Action
   │    └─► Jump Action
   └─► Physics System
   ```

3. **Database Operations Flow**:
   ```plaintext
   DB Manager
   ├─► DB Helper Utils
   ├─► SQLite Database
   └─► Action/Map Data
   ```

## Performance Considerations

As detailed in `Costs saving.md`, the system implements:
- Network optimization for multiplayer
- State management with different update frequencies:
  - Critical actions: 60Hz
  - Environment: 10Hz
  - Inventory: 1Hz
- P2P communication for immediate actions
- Server validation for critical states

## Usage Example

```gdscript
# In player_controller.gd
func _physics_process(delta: float) -> void:
    # Execute movement
    action_manager.execute_action("move", delta)
    
    # Handle jump input
    if Input.is_action_just_pressed("jump"):
        action_manager.execute_action("jump", delta)
```

This script architecture provides a modular, maintainable, and scalable foundation for the game, with clear separation of concerns and efficient data management.