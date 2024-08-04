-module(functions).
-export([greet/2, head/1, second/1, same/2]).


%% パターンマッチ
%% io.formatの~sは文字列を表示、~nは改行, ~pでデバッグ用に表示
greet(male, Name) ->
    io:format("Hello, Mr. ~s!~n", [Name]);
greet(female, Name) ->
    io:format("Hello, Mrs. ~s!~n", [Name]);
greet(_, Name) ->
    io:format("Hello, ~s!~n", [Name]).


head([H | _]) -> H.


second([_, X | _]) -> X.


same(X, X) ->
    true;
same(_, _) ->
    false.
