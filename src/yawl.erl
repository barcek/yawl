-module(yawl).
-export([put/1, put/2, get/1, get/2]).

-define(LEDE, io_lib:format("[~ts]", [?MODULE])).
-define(WAIT, 10).

-record(config, {wait=?WAIT}).

-type options() :: [none() | {wait, integer()}].
-type summary_output_message() :: {ok | error | timeout, bitstring(), [char()]}.
-type summary_output()         :: {ok | error | timeout, bitstring()}.

% primaries

-spec put(binary())            -> ok.
-spec put(binary(), options()) -> ok.
put(Command)          -> run_put(Command, #config{}).
put(Command, Options) -> run_put(Command, read(Options)).

-spec get(binary())            -> summary_output().
-spec get(binary(), options()) -> summary_output().
get(Command)          -> run_get(Command, #config{}).
get(Command, Options) -> run_get(Command, read(Options)).

% secondaries

-spec run_put(binary(), #config{}) -> ok.
run_put(Command, Config) ->
  {_,       Output, Message} = pass(Command, Config#config.wait),
  dump({Output, Message}).

-spec run_get(binary(), #config{}) -> summary_output().
run_get(Command, Config) ->
  {Summary, Output, Message} = pass(Command, Config#config.wait),
  dump({<<>>,   Message}),
  {Summary, Output}.

% utilities

-spec read(options()) -> #config{}.
read(Options) ->
  case Options of
    []             -> #config{};
    [{wait, Wait}] -> #config{wait=Wait};
    _              -> fail("read", "impermissible argument (options)", badarg)
  end.

-spec pass(binary(), integer()) -> summary_output_message().
pass(Command, Wait) ->
  try open_port({spawn, Command}, [stderr_to_stdout, binary, exit_status]) of
    Port -> loop(Port, <<>>, Wait)
  catch
    error:Error -> fail("open_port", io_lib:format("received ~ts", [Error]), Error)
  end.

-spec loop(port(), bitstring(), integer()) -> summary_output_message().
loop(Port, Head, Wait) ->
  receive
    {Port, {data, Tail}} -> loop(Port, <<Head/binary, Tail/binary>>, Wait);
    {Port, {exit_status, Code}} ->
      case Code of
        0    -> {ok,      Head, io_lib:format("Exited with status ~tp", [Code])};
        _    -> {error,   Head, io_lib:format("Exited with status ~tp", [Code])}
      end
  after Wait -> {timeout, Head, io_lib:format("Timed out (wait: ~pms, ~tp)", [Wait, Port])}
  end.

-spec fail(binary(), binary(), atom()) -> none().
fail(Site, Note, Reason) ->
  dump({<<>>, io_lib:format("Error: ~ts - ~ts", [Site, Note])}),
  exit(Reason).

-spec dump({bitstring(), [char()]}) -> ok.
dump({Output, Message}) ->
  io:format("~ts~ts ~ts~n", [Output, ?LEDE, Message]).
