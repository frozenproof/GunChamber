# Action Manager System Reference
*For GunChamber Project*
*Last Updated: 2025-05-02 13:01:54 UTC*

## Overview
The Action Manager is a core system in GunChamber that handles player actions through a modular, extensible architecture. It's implemented as a node attached to the player character and manages all player actions through a flexible action registration system.

## Core Components

### 1. ActionManager Class (`action_manager.gd`)
```gdscript
class_name ActionManager
extends Node
```

#### Key Properties
- `actions: Dictionary` - Stores all registered actions by their name
- `player: CharacterBody3D` - Reference to the parent player character

#### Signals
- `action_executed(action_name: String)` - Emitted when an action is executed
- `action_registered(action_name: String)` - Emitted when a new action is registered
- `action_unregistered(action_name: String)` - Emitted when an action is unregistered

#### Core Methods
```gdscript
func _ready() -> void:
    # Initializes the manager and loads default actions
    # Validates parent is CharacterBody3D
    # Loads both default and resource-based actions
```

```gdscript
func execute_action(action_name: String, delta: float) -> void:
    # Executes a registered action if it exists and can be executed
    # Emits action_executed signal upon successful execution
```

```gdscript
func get_action(action_name: String) -> PlayerAction:
    # Retrieves an action by name from the actions dictionary
```

### 2. PlayerAction Base Class
```gdscript
class_name PlayerAction
extends Resource
```

#### Properties
- `action_name: String` - Unique identifier for the action
- `action_enabled: bool` - Whether the action can be executed
- `player: CharacterBody3D` - Reference to the player character

#### Virtual Methods
```gdscript
func initialize(p_player: CharacterBody3D) -> void:
    # Sets up the action with a reference to the player

func can_execute(p_player: CharacterBody3D) -> bool:
    # Returns whether the action can be executed
    # Default implementation checks action_enabled

func execute(p_player: CharacterBody3D, delta: float) -> void:
    # Abstract method to be implemented by concrete actions
```

## Built-in Actions

### 1. MoveAction
```gdscript
class_name MoveAction
extends PlayerAction
```
- Handles basic WASD movement
- Uses input vectors for direction
- Applies speed modifier to movement
- Normalizes movement vectors

### 2. JumpAction
```gdscript
class_name JumpAction
extends PlayerAction
```
- Handles both ground and wall jumps
- Configurable jump forces
- Checks for valid jump conditions
- Applies appropriate force vectors

## Integration Example

### In Player Controller
```gdscript
@onready var action_manager: ActionManager = $ActionManager

func _physics_process(delta: float) -> void:
    if not game_paused:
        action_manager.execute_action("move", delta)
        
        if Input.is_action_just_pressed("jump"):
            action_manager.execute_action("jump", delta)
```

## Creating Custom Actions

1. Create a new script extending `PlayerAction`:
```gdscript
class_name CustomAction
extends PlayerAction

func _init() -> void:
    action_name = "custom_action"

func can_execute(p_player: CharacterBody3D) -> bool:
    return super.can_execute(p_player) and your_condition

func execute(p_player: CharacterBody3D, delta: float) -> void:
    # Implement your action logic here
```

2. Register the action:
- Either add it to `_load_default_actions()` in ActionManager
- Or create a resource file (.tres) in the actions directory

## Resource-Based Actions
Actions can be defined as resources and automatically loaded:
1. Create a .tres file in the "res://actions/" directory
2. Define the action properties in the resource
3. The ActionManager will automatically load and register it

## Best Practices
1. Always call `initialize()` when creating new actions
2. Use meaningful action names
3. Implement proper `can_execute()` checks
4. Keep actions atomic and single-purpose
5. Use the resource system for configurable actions

## Common Pitfalls
1. Not calling super.can_execute() in overridden methods
2. Forgetting to initialize actions with player reference
3. Using duplicate action names
4. Not handling action dependencies properly

## Debugging Tips
1. Check action registration in _ready() output
2. Verify action names match exactly
3. Ensure player reference is valid
4. Monitor action_executed signals

## Future Extensions
1. Action priorities
2. Action chaining
3. Action cooldowns
4. State-based action availability
5. Action animation integration