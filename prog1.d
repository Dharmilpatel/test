import std.stdio;

string func1(string b)
{
	return b;
}

unittest
{
	writeln("In program 1:");
	assert(func1("Heyy") == "Hey");
}