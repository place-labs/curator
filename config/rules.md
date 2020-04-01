# Allowed Operators: #

* Attribute: `uts`
  * operators: [greater_than_equal, less_than_equal]
* rest of attributes
  * operators:  [include, exclude]

# Allowed Values: #

* For `greater_than_equal` and `less_than_equal` operators
  * values is an array with single `unix timestamp` value as a string.
  * e.g ["1580276617006"]
* For `include` and `exclude`
  * values is an array with as many `string` values as needed.
  * To match against empty values, `blank` string value can be provided.
  * e.g ["test-123", "blank", "mod-555"]


Rules are applied from top to bottom.
