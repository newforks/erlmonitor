%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 9:55 AM
%%%-------------------------------------------------------------------
-module(erlmonitor_handler).
-author("zhaoweiguo").

-export([init/2]).

init(Req0, State) ->
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"text/plain">>},
    <<"Hello Erlang!">>,
    Req0),
  {ok, Req, State}.



