%% Erlangの並行性にとって必要な3つの原則
%% 1. プロセスを生成する
%%   プロセスは単なる関数。プロセスは関数を実行し、実行が終わったら消える。
%%   新しいプロセスを開始するために、Erlangではspawn/1という関数を使う。
%%   spawn(Fun) -> Pid
%%   spawn/3もある。
%%   spawn(Module, Function, Args) -> Pid
%% 2. メッセージを送信する
%%   !演算子(bangシンボル)で、プロセスに対してメッセージパッシングが行える。
%%   Pid ! Message(任意のErlang項)
%%   goのチャネルと気持ちは近いかも。
%%   メッセージは突っ込まれた順に読まれる(キュー)。
%% 3. メッセージを受信する
%%   メールボックスの内容を見るには、flush/0という関数を使う。
%%   メッセージを受信する(読む)には、receive式を使う。
%%   receive
%%     Pattern1 -> Expression1;
%%     Pattern2 -> Expression2;
%%     ...
%%   end

-module(dolphins).
-compile(export_all).


dolphin1() ->
    receive
        do_a_flip ->
            io:format("How about no?~n");
        fish ->
            io:format("So long and thanks for all the fish!~n");
        _ ->
            io:format("Heh, we're smarter than you humans.~n")
    end.


%% プロセスから返り値を受け取る
%% メッセージを送るときに、送信元のプロセスのPidをタプルに詰めて渡すことで実現する。
%% 手紙に送信元の住所を書いて送るイメージ。 {From, Message}.
dolphin2() ->
    receive
        {From, do_a_flip} ->
            From ! "How about no?";
        {From, fish} ->
            From ! "So long and thanks for all the fish!";
        _ ->
            io:format("Heh, we're smarter than you humans.~n")
    end.


%% 再帰により、常にメッセージを受け取れるようにする。
dolphin3() ->
    receive
        {From, do_a_flip} ->
            From ! "How about no?",
            dolphin3();
        {From, fish} ->
            From ! "So long and thanks for all the fish!";
        _ ->
            io:format("Heh, we're smarter than you humans.~n"),
            dolphin3()
    end.
