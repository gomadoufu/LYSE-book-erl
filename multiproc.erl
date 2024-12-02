-module(multiproc).
-compile(export_all).


sleep(T) ->
    receive
    after
        T ->
            ok
    end.


flush() ->
    receive
        _ ->
            flush()
    after
        0 ->
            ok
    end.


%% 選択的受信
%% 安全ではない場合があるとのこと。
important() ->
    receive
        {Priority, Message} when Priority > 10 ->
            [Message | important()]
    after
        0 ->
            normal()
    end.


normal() ->
    receive
        {_, Message} ->
            [Message | normal()]
    after
        0 ->
            []
    end.
