%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 5:07 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_worker_sup).
-author("zhaoweiguo").

-behaviour(supervisor).

-include("erlmonitor.hrl").
%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
  % @todo work pool
  {ok, {{one_for_all, 0, 1}, [
    ?CHILD(erlmonitor_worker, worker)
  ]}}.





%%%===================================================================
%%% Internal functions
%%%===================================================================
