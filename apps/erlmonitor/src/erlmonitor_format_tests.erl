%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2018 2:16 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_format_tests).
-author("zhaoweiguo").

%% API
-include_lib("eunit/include/eunit.hrl").


sort_test() ->
  A = [
    {initial_call, {otp_ring0, start, 2}},
    {current_function, {init, loop, 1, []}},
    {status, waiting},
    {reductions, 1837}
  ],
  B = [
    {initial_call, {erts_code_purger, start, 0}},
    {current_function, {erts_code_purger, loop, 0, []}},
    {status, waiting},
    {reductions, 23262}
  ],
  [A, B] = erlmonitor_format:sort([A,B], 1),
  [B, A] = erlmonitor_format:sort([A,B], 1, 1),
  [B, A] = erlmonitor_format:sort([A,B], 4),
  [A, B] = erlmonitor_format:sort([A,B], 4, 1).


