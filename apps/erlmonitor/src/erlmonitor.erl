%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%     Interface Module
%%% @end
%%% Created : 06. Dec 2018 8:51 PM
%%%-------------------------------------------------------------------
-module(erlmonitor).
-author("zhaoweiguo").

%% API
-export([start/0]).

start() ->
%%  application:ensure_all_started(lager),
  application:ensure_all_started(erlmonitor).




