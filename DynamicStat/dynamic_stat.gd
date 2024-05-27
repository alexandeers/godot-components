@tool @icon("res://components/_icons/icon_gauge.svg")
class_name DynamicStat extends Node

# CONFIGURATION
@export var type: Type:
	set(value):
		self.name = Type.keys()[value]
		type = value
@export var base: float = 0

# VARIABLES
var current: float:
	set(value):
		current = clamp(value, 0, max)
var last_base: float = 0
var is_dirty: bool = true
var stat_modifiers : Array
var max: float:
	get:
		if is_dirty or base != last_base:
			last_base = base
			max = calculate_final_value()
			is_dirty = false
		return max

signal current_changed
signal base_changed

# FUNCTIONS
func _ready():
	current = base

func compare_order(a: StatModifier, b: StatModifier):
	if a.order < b.order:
		return false
	else:
		return true

func add_modifier(stat: StatModifier):
	stat_modifiers.append(stat)
	is_dirty = true
	stat_modifiers.sort_custom(compare_order)

func remove_modifier(stat: StatModifier):
	stat_modifiers.erase(stat)
	is_dirty = true

func remove_all_modifiers_from_source(source: Object) -> bool:
	var has_removed = false
	for stat in stat_modifiers:
		if stat.source == source:
			is_dirty = true
			has_removed = true
			stat_modifiers.erase(stat)
	return has_removed

func calculate_final_value() -> float:
	var final_value : float = base
	var sum_percent : float = 0
	for stat in stat_modifiers:
		if stat.type == StatModifier.StatModType.Flat:
			final_value += stat.value
		if stat.type == StatModifier.StatModType.PercentAdd:
			sum_percent += stat.value
			if stat_modifiers[-1] == stat:
				final_value *= 1 + sum_percent
				sum_percent = 0
		if stat.type == StatModifier.StatModType.PercentMult:
			final_value *= 1 + stat.value
			
	return round(final_value)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if base == 0:
		warnings.append("The base value is set to 0.")
	if type == Type.None:
		warnings.append("The type of this stat is None.")
	return warnings

enum Type 
{
	None,
	Health,
}
