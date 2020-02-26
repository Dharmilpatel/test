module pocStruct;

import core.sys.posix.dlfcn;
import std.file;

struct s
{
	void * libhandle;
	string tempFile;
	string tempFileSo;

	this(string str)
	{

		import std.array : appender;
    	import std.process : pipeProcess, Redirect, wait;

    	import std.ascii : letters;
		import std.conv : to;
		import std.path : buildPath;
		import std.random : randomSample;
		import std.utf : byCodeUnit;

		auto id = letters.byCodeUnit.randomSample(25).to!string;
    	this.tempFile = tempDir.buildPath(id ~ "tmp_file.d");
    	this.tempFileSo = "temp" ~ id ~ ".so";
		write(tempFile, str);

		auto cmd = [
			"dmd", 
			"-O",	
			"-fPIC", "-shared",
			"-of" ~ "temp" ~ id ~ ".so",
			tempFile	
		];

			
       		auto pipes = pipeProcess(cmd, Redirect.stdin | Redirect.stdout |
                                      Redirect.stderrToStdout);

 
        	auto status = wait(pipes.pid);

        	if (status != 0)
            	throw new Exception("Failed to compile code:\n");
	}

	void openSoFile()
	{
		string path = "./" ~ tempFileSo;
		libhandle = dlopen(cast (char *)path, RTLD_LAZY | RTLD_LOCAL);
		import std.stdio;
		//writeln(path);
		if (libhandle is null)
			throw new Exception("Could not find the so file:\n");
	}

	~this()
	{
		import std.stdio;
		//writeln ("calling dlclose...");
		if(libhandle !is null)
			dlclose(libhandle);
	}

	string stringFunc(string s)
	{
		alias FunType = string function(string);
		auto funptr = cast(FunType)dlsym(libhandle, "func");

		string result = funptr(s);

		return result;
	}
}


unittest
{

	s temp = s("import core.stdc.stdio;
extern (C) string func(string b)
{
	return b;
}");


	temp.openSoFile();

    assert(temp.stringFunc("It works!!") == "It works!!");
    assert(temp.stringFunc("Yayy!!") == "Yayy!!");
    assert(temp.stringFunc("Ssup") == "Ssup");

    temp.destroy();

    s temp1 = s("import core.stdc.stdio;
extern (C) string func(string b)
{
	return b ~ b;
}");


    temp1.openSoFile();

    assert(temp1.stringFunc("It works!!") == "It works!!It works!!");
    assert(temp1.stringFunc("Yayy!!") == "Yayy!!Yayy!!");
    assert(temp1.stringFunc("Ssup") == "SsupSsup");

    temp1.destroy();
}