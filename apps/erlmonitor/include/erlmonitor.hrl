

-define(LOG(M), io:format("[~p:~p ~p]  "++M, [?MODULE, ?LINE, ?FUNCTION_NAME])).
-define(LOGLN(M), io:format("[~p:~p ~p]  "++M++"~n", [?MODULE, ?LINE, ?FUNCTION_NAME])).
-define(LOGF(M, P), io:format("[~p:~p ~p]  "++M, [?MODULE, ?LINE, ?FUNCTION_NAME] ++ P)).


-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).



-define(TEXT_HEAD,
  #{<<"content-Type">> => <<"text/plain; charset=utf-8">>}).



