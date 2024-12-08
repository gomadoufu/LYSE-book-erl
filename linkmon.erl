-module(linkmon).
-compile(export_all).


myproc() ->
    timer:sleep(5000),
    exit(reason).


chain(0) ->
    receive
        _ -> ok
    after
        2000 ->
            exit("chain dies here")
    end;
chain(N) ->
    Pid = spawn(fun() -> chain(N - 1) end),
    link(Pid),
    io:format("chain ~p linked to ~p~n", [self(), Pid]),
    receive
        _ -> ok
    end.


start_critic() ->
    spawn(?MODULE, critic, []).


judge(Pid, Band, Album) ->
    Pid ! {self(), {Band, Album}},
    receive
        {Pid, Criticism} -> Criticism
    after
        2000 ->
            timeout
    end.


critic() ->
    receive
        {From, {"Rage Against the Turing Machine", "Unit Testify"}} ->
            From ! {self(), "They are great!"};
        {From, {"System of a Downtime", "Memoize"}} ->
            From ! {self(), "Tey're not Johnney Crash but they're good."};
        {From, {"Jonney Crash", "The Token Ring of Fire"}} ->
            From ! {self(), "Simply incredible"};
        {From, {_Band, _Album}} ->
            From ! {self(), "They are terrible!"}
    end,
    critic().


start_critic2() ->
    spawn(?MODULE, restarter, []).


restarter() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, critic2, []),
    register(critic, Pid),
    receive
        {'EXIT', Pid, normal} ->  % not a crash
            io:format("Critic exited normally~n", []),
            ok;
        {'EXIT', Pid, shutdown} ->  % manual termination, not a crash
            io:format("Critic exited on shutdown~n", []),
            ok;
        {'EXIT', Pid, _} ->
            io:format("Critic crashed; restarting~n", []),
            restarter()
    end.


judge2(Band, Album) ->
    Ref = make_ref(),
    critic ! {self(), Ref, {Band, Album}},
    receive
        {Ref, Criticism} -> Criticism
    after
        2000 ->
            timeout
    end.


critic2() ->
    receive
        {From, Ref, {"Rage Against the Turing Machine", "Unit Testify"}} ->
            From ! {Ref, "They are great!"};
        {From, Ref, {"System of a Downtime", "Memoize"}} ->
            From ! {Ref, "Tey're not Johnney Crash but they're good."};
        {From, Ref, {"Jonney Crash", "The Token Ring of Fire"}} ->
            From ! {Ref, "Simply incredible"};
        {From, Ref, {_Band, _Album}} ->
            From ! {Ref, "They are terrible!"}
    end,
    critic2().
