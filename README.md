# Buddy Lives Another Day

A game that is in development.

## gdscript Style Guide

- variables, signals: camelCase
- functions, classes, enums: PascalCase
- constants: ALLCAPS
- functions attached to signals: \_on_[NodeName]_[signalName]
- nodes in scene hierarchy: PascalCase

Declare script-wide variables at the top of your script, with stack variables all before `onready` variables.

Type any variables that are not primitives if you can. The Godot editor can help you more with untyped variables and let you know if you break their type in your script. Even better, Godot will give you an autocomplete menu of the variable's functions when you type a "." after it.

        # OK: 
        var myInt = 0
        # OK: 
        var myInt := 0 # This is typed.
        
        # OK:
        onready var specialAttackTimer := get_node("SpecialAttackTimer") # specialAttackTimer is typed.
        # If we type "specialAttackTimer." we will see a menu containing functions like "start" or "stop".
        # AVOID: 
        onready var specialAttackTimer = get_node("SpecialAttackTimer") # specialAttackTimer is untyped.
