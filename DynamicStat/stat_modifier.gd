class_name StatModifier

var value: float
var type: StatModType
var order: int
var source: Object

enum StatModType
{
	Flat = 100,
	PercentAdd = 200,
	PercentMult = 300
}

func _init(_value: float, _type: StatModType, _order: int, _source: Object):
	self.value = _value
	self.type = _type
	self.order = _order
	self.source = _source
