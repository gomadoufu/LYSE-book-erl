%% コンパイル方法
%% シェルから
%% erlc -v -Werror -Wall -DDEBUGMODE useless.erl
%% またはerlang shellから
%% compile:file(useless, [debug_info, export_all, {d, 'DEBUGMODE'}]).
%% または c(useless, [debug_info, export_all, {d, 'DEBUGMODE'}]).
%% useless:module_info(). でメタデータを表示できる

%% moduleはコンパイルするために最低限必要な属性
-module(useless).

%% exportは外部からアクセス可能な関数を指定する
%% 関数名/引数の数(arity)のリストを指定
-export([debug_add/2, hello/0, greet_and_add_two/1, print_info/0]).

-define(HELLO, "Hello, world!").

-ifdef(DEBUGMODE).
-define(DEBUG(X), io:format("Debug: ~p~n", [X])).
-else.
-define(DEBUG(X), ok).
-endif.


debug_add(A, B) -> io:format("~n", A), io:format(B), ?DEBUG(A + B).


%% Shows greetings.
%% io::format/1 is the standard function used to output text.
hello() -> io:format(?HELLO ++ "~n").


greet_and_add_two(X) ->
    hello(),
    debug_add(X, 2).


print_info() ->
    io:format(?MODULE).
