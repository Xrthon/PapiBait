class_name HealthComponent
extends Node


## Emitted when health changes.
signal changed(life: float)

signal healed(amount: float)

signal healed_fully()

signal damaged(amount: float)

## Emitted when health reaches 0.
signal died()

## Emitted when health has been restored after death.
signal revived()

## The maximum allowed health.
var max_life :float = 5.0

## The current health.
@onready var health := max_life:
	set(health_): 
		health = clampf(health_, 0.0, max_life)
		changed.emit(health_)
		
## Apply an amount of healing.  If [i]will_revive[/i] is true, the health can be
## from a "dead" state.
func heal(amount: float, will_revive := false) -> void:
	if is_dead() and not will_revive: return

	var old_heath := health

	health += amount

	healed.emit(health - old_heath)
	changed.emit(health)

	if is_maxed():
		healed_fully.emit()

## Apply a full amount of healing.
func heal_fully() -> void:
	heal(max_life)

## Apply an amount of damage.
func damage(amount: float) -> void:
	var old_heath := health

	health -= amount

	damaged.emit(old_heath - health)
	changed.emit(health)
		
	if is_dead():
		died.emit()

## Return whether the health should be considered "dead".
func is_dead() -> bool:
	return not is_alive()
	
## Return whether the health should be considered "alive".
func is_alive() -> bool:
	return health > 0
	
## Return whether the health is maxed out.
func is_maxed() -> bool:
	return health >= max_life

## Revive the health from "dead" state.
func revive(amount: float) -> void:
	if is_dead() and amount > 0.0:
		heal(amount, true)
		revived.emit()
