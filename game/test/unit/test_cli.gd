extends GutTest

func test_parser():
	var args = "-i -n -color always -p ./src/*.gd".split(" ")
	var aliases = {
		"i": "input",
		"n": "normal",
		"p": "path"
		}
	var res = CliParser.parse(args, aliases)
	print(res)
	assert_eq(res.input, true)
	assert_eq(res.normal, true)
	assert(not res.get("n"))
	assert(not res.get("i"))
	assert(not res.get("p"))
	assert_eq(res.path, "./src/*.gd")
