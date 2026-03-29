class_name CliParser extends RefCounted

const PREFIX = "-"

## For a given set of [param args] like -f foo -b -bar baz will return { f: foo, b: true, bar: baz }
## [param aliases] can optionally map aliases to their matching strings
static func parse(args: Array[String], aliases={}) -> Dictionary:
	var res = {}
	var i = 0
	while i < args.size():
		var arg = args[i]
		if not arg.begins_with(PREFIX):
			push_warning("Ignoring argument %s" % arg)
		else:
			arg = arg.substr(1)
			var alias = aliases.get(arg)
			if alias and alias != "":
				arg = alias

			var next = args.get(i+1)
			if not next or next.begins_with(PREFIX):
				res[arg] = true
			else:
				res[arg] = next
				i += 1

		i += 1
	return res
