-module(yawl_tests).
-include_lib("eunit/include/eunit.hrl").

% output some

put_one_some_test() ->
  ?assertEqual(ok, yawl:put("echo Test put one")),
  ?assertEqual(?capturedOutput, "Test put one\n[yawl] Exited with status 0\n").

put_two_some_test() ->
  ?assertEqual(ok, yawl:put("echo Test put two", [])),
  ?assertEqual(?capturedOutput, "Test put two\n[yawl] Exited with status 0\n").

get_one_some_test() ->
  ?assertEqual({ok, <<"Test get one\n">>}, yawl:get("echo Test get one")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

get_two_some_test() ->
  ?assertEqual({ok, <<"Test get two\n">>}, yawl:get("echo Test get two", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

% output some, pipe

put_one_some_pipe_test() ->
  ?assertEqual(ok, yawl:put("echo Test put one | tr T t")),
  ?assertEqual(?capturedOutput, "test put one\n[yawl] Exited with status 0\n").

put_two_some_pipe_test() ->
  ?assertEqual(ok, yawl:put("echo Test put two | tr T t", [])),
  ?assertEqual(?capturedOutput, "test put two\n[yawl] Exited with status 0\n").

get_one_some_pipe_test() ->
  ?assertEqual({ok, <<"test get one\n">>}, yawl:get("echo Test get one | tr T t")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

get_two_get_some_pipe_test() ->
  ?assertEqual({ok, <<"test get two\n">>}, yawl:get("echo Test get two | tr T t", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

% output some, boolean AND

put_one_some_and_test() ->
  ?assertEqual(ok, yawl:put("echo Test put one && echo more")),
  ?assertEqual(?capturedOutput, "Test put one\n[yawl] Exited with status 0\n").

put_two_some_and_test() ->
  ?assertEqual(ok, yawl:put("echo Test put two && echo more", [])),
  ?assertEqual(?capturedOutput, "Test put two\n[yawl] Exited with status 0\n").

get_one_some_and_test() ->
  ?assertEqual({ok, <<"Test get one\n">>}, yawl:get("echo Test get one && echo more")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

get_two_some_and_test() ->
  ?assertEqual({ok, <<"Test get two\n">>}, yawl:get("echo Test get two && echo more", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

% output some, semi-colon

put_one_some_semi_colon_test() ->
  ?assertEqual(ok, yawl:put("echo Test put one; echo more")),
  ?assertEqual(?capturedOutput, "Test put one\n[yawl] Exited with status 0\n").

put_two_some_semi_colon_test() ->
  ?assertEqual(ok, yawl:put("echo Test put two; echo more", [])),
  ?assertEqual(?capturedOutput, "Test put two\n[yawl] Exited with status 0\n").

get_one_some_semi_colon_test() ->
  ?assertEqual({ok, <<"Test get one\n">>}, yawl:get("echo Test get one; echo more")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

get_two_some_semi_colon_test() ->
  ?assertEqual({ok, <<"Test get two\n">>}, yawl:get("echo Test get two; echo more", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

% output none

put_one_none_test() ->
  ?assertEqual(ok,         yawl:put("sh -c \"\"")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

put_two_none_test() ->
  ?assertEqual(ok,         yawl:put("sh -c \"\"", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

get_one_none_test() ->
  ?assertEqual({ok, <<>>}, yawl:get("sh -c \"\"")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

get_two_none_test() ->
  ?assertEqual({ok, <<>>}, yawl:get("sh -c \"\"", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 0\n").

% exit status, other

put_one_none_exit_1_test() ->
  ?assertEqual(ok,            yawl:put("sh -c \"exit 1\"")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 1\n").

put_two_none_exit_1_test() ->
  ?assertEqual(ok,            yawl:put("sh -c \"exit 1\"", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 1\n").

get_one_none_exit_1_test() ->
  ?assertEqual({error, <<>>}, yawl:get("sh -c \"exit 1\"")),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 1\n").

get_two_none_exit_1_test() ->
  ?assertEqual({error, <<>>}, yawl:get("sh -c \"exit 1\"", [])),
  ?assertEqual(?capturedOutput, "[yawl] Exited with status 1\n").

% timeout, default

put_one_none_timeout_test() ->
  ?assertEqual(ok,              yawl:put("sleep 1")),
  ?assertEqual(string:str(?capturedOutput, "[yawl] Timed out (wait: 10ms, #Port<"), 1).

put_two_none_timeout_test() ->
  ?assertEqual(ok,              yawl:put("sleep 1"), []),
  ?assertEqual(string:str(?capturedOutput, "[yawl] Timed out (wait: 10ms, #Port<"), 1).

get_one_none_timeout_test() ->
  ?assertEqual({timeout, <<>>}, yawl:get("sleep 1")),
  ?assertEqual(string:str(?capturedOutput, "[yawl] Timed out (wait: 10ms, #Port<"), 1).

get_two_get_none_timeout_test() ->
  ?assertEqual({timeout, <<>>}, yawl:get("sleep 1", [])),
  ?assertEqual(string:str(?capturedOutput, "[yawl] Timed out (wait: 10ms, #Port<"), 1).

% timeout, option wait

put_two_none_timeout_wait_test() ->
  ?assertEqual(ok,              yawl:put("sleep 1", [{wait, 20}])),
  ?assertEqual(string:str(?capturedOutput, "[yawl] Timed out (wait: 20ms, #Port<"), 1).

get_two_get_none_timeout_wait_test() ->
  ?assertEqual({timeout, <<>>}, yawl:get("sleep 1", [{wait, 20}])),
  ?assertEqual(string:str(?capturedOutput, "[yawl] Timed out (wait: 20ms, #Port<"), 1).

% error, read, badarg

put_two_none_error_read_test() ->
  ?assertExit(badarg, yawl:put("sh -c \"\"", nil)),
  ?assertEqual(?capturedOutput, "[yawl] Error: read - impermissible argument (options)\n").

get_two_none_error_read_test() ->
  ?assertExit(badarg, yawl:get("sh -c \"\"", nil)),
  ?assertEqual(?capturedOutput, "[yawl] Error: read - impermissible argument (options)\n").

% error, open_port, badarg

put_one_none_error_open_test() ->
  ?assertExit(badarg, yawl:put("")),
  ?assertEqual(?capturedOutput, "[yawl] Error: open_port - received badarg\n").

put_two_none_error_open_test() ->
  ?assertExit(badarg, yawl:put(""), []),
  ?assertEqual(?capturedOutput, "[yawl] Error: open_port - received badarg\n").

get_one_none_error_open_test() ->
  ?assertExit(badarg, yawl:get("")),
  ?assertEqual(?capturedOutput, "[yawl] Error: open_port - received badarg\n").

get_two_none_error_open_test() ->
  ?assertExit(badarg, yawl:get("", [])),
  ?assertEqual(?capturedOutput, "[yawl] Error: open_port - received badarg\n").
