# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
# Boilerplate class to get full autocompletion and type checks for the `enemy` when coding the enemy's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name EnemyState
extends State

# Typed reference to the enemy node.
var enemy: EnemyEntity


func _ready() -> void:
    # The states are children of the `EnemyEntity` node so their `_ready()` callback will execute first.
    # That's why we wait for the `owner` to be ready first.
    yield(owner, "ready")
    # The `as` keyword casts the `owner` variable to the `EnemyEntity` type.
    # If the `owner` is not a `EnemyEntity`, we'll get `null`.
    enemy = owner as EnemyEntity
    # This check will tell us if we inadvertently assign a derived state script
    # in a scene other than `EnemyEntity.tscn`, which would be unintended. This can
    # help prevent some bugs that are difficult to understand.
    assert(enemy != null)
