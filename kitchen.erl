-module(kitchen).
-compile(export_all).

%% 冷蔵庫を作る(?)


fridge1() ->
    receive
        {From, {store, _Food}} ->
            From ! {self(), ok},
            fridge1();
        {From, {take, _Food}} ->
            From ! {self(), not_found},
            fridge1();
        terminate ->
            ok
    end.


%% 冷蔵庫の状態を表さないと役に立たない！
%% 再帰を使って、プロセスの状態を関数のパラメータの中に保持する
fridge2(FoodList) ->
    receive
        {From, {store, Food}} ->
            From ! {self(), ok},
            fridge2([Food | FoodList]);
        {From, {take, Food}} ->
            case lists:member(Food, FoodList) of
                true ->
                    From ! {self(), {ok, Food}},
                    fridge2(lists:delete(Food, FoodList));
                false ->
                    From ! {self(), not_found},
                    fridge2(FoodList)
            end;
        {From, {list}} ->
            From ! {self(), FoodList},
            fridge2(FoodList);
        close ->
            ok
    end.


store(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
        {Pid, Msg} ->
            Msg
    end.


take(Pid, Food) ->
    Pid ! {self(), {take, Food}},
    receive
        {Pid, Msg} ->
            Msg
    end.


start(FoodList) ->
    spawn(?MODULE, fridge2, [FoodList]).


client(DestPid) ->
    Input = string:chomp(io:get_line("Give me some input (store/take/list/close):\n")),
    case string:split(Input, " ") of
        %% 食品を保存する
        ["store", Food] ->
            DestPid ! {self(), {store, Food}},
            receive
                {_, ok} ->
                    io:format("Food stored~n"),
                    client(DestPid)
            after
                5000 ->
                    io:format("Timeout while storing food~n"),
                    client(DestPid)
            end;

        %% 食品を取り出す
        ["take", Food] ->
            DestPid ! {self(), {take, Food}},
            receive
                {_, {ok, FoodTaken}} ->
                    io:format("Took ~s~n", [FoodTaken]),
                    client(DestPid);
                {_, not_found} ->
                    io:format("Food not found~n"),
                    client(DestPid)
            after
                5000 ->
                    io:format("Timeout while taking food~n"),
                    client(DestPid)
            end;

        %% 食品リストを取得する
        ["list"] ->
            DestPid ! {self(), {list}},
            receive
                {_, FoodList} ->
                    io:format("Food List: ~p~n", [FoodList]),
                    client(DestPid)
            after
                5000 ->
                    io:format("Timeout while listing food~n"),
                    client(DestPid)
            end;

        %% 冷蔵庫プロセスを終了する
        ["close"] ->
            DestPid ! terminate,
            io:format("Terminating fridge process~n"),
            io:format("Exiting client~n"),
            ok;

        %% 無効なコマンド
        _ ->
            io:format("Unknown command. Try again.~n"),
            client(DestPid)
    end.
