

-define(LOG(M), io:format("[~p:~p]"++M, [?MODULE, ?LINE])).
-define(LOGLN(M), io:format("[~p:~p]"++M++"~n", [?MODULE, ?LINE])).
-define(LOGF(M, P), io:format("[~p:~p]"++M, [?MODULE, ?LINE] ++ P)).


-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).



