# yawl

A simple typed and tested wrapper for Erlang ports using `spawn`.

## Why?

For quick calls to external code, especially for display in the Erlang shell.

## How?

Most simply, call either `:put/1` or `:get/1`, passing the command to be run:

- `:put/1` to print the output via `io:format`
- `:get/1` to return the output in a tuple as a binary

For example:

```
0> yawl:put("echo Using yawl").
Using yawl
[yawl] Exited with status 0
ok
1> yawl:get("echo Using yawl").
[yawl] Exited with status 0
{ok,<<"Using yawl\n">>}
```

An exit status other than zero sets the atom in the tuple to `error`.

The timeout for data receipt is defined near the top of the module, currently as 10ms. If exceeded, yawl wraps up, sets the atom to `timeout` and prints a timeout message including the port identifier.

The functions `:put/2` and `:get/2` accept a list for options, with one currently available: `{wait, integer()}`, to override the default timeout.

### Note

A command should apply a pipe (`|`) as expected, but only ever run as far as any boolean AND (`&&`) or semi-colon (`;`) present. The tests (see [Making changes](#making-changes) below) can be used to check this behaviour locally.

As with any use of the shell, and any use of intermediary code invoking the shell, care should be taken. The yawl source code should be reviewed before proceeding and any intended use of yawl should first be tested in a context in which no harm can be done.

## Getting started

The source file can be compiled using Rebar3 or from the Erlang shell.

### Using Rebar3

Using Rebar3, from within the root directory:

```shell
rebar3 compile
```

The functions can then be used directly with `rebar3 shell`.

### From the Erlang shell

Compiling from the Erlang shell, within the root directory, and providing an optional out directory, assuming it exists:

```
0> c("src/yawl", [{outdir, "out"}]).
{ok,yawl}
```

The functions are then available for use.

## Making changes

The project includes tests written for EUnit and specs to support static analysis with Dialyzer.

The tests assume a Unix-like system, and specifically the presence of a suitable `sh`, plus `echo`, `tr` and `sleep`.

All can be run using the Rebar3 alias `check` or from the Erlang shell. Doing so initially and after making changes, as well as adding specs and tests to cover new behaviour, is recommended.

### Using Rebar3

Using Rebar3, from within the root directory:

```shell
rebar3 check
```

### From the Erlang shell

From the Erlang shell, the tests may need to be compiled. Within the root directory, and providing an optional out directory, assuming it exists:

```
0> c("test/yawl_tests", [{outdir, "out"}]).
{ok,yawl_tests}
1> eunit:test(yawl).          
...
```

## Development plan

The following are the expected next steps in the development of the code base. The general medium-term aim is a versatile and intuitive means of calling external code. Pull requests are welcome for these and other potential improvements.

- extend available options per `open_port`
- allow for composite command strings
