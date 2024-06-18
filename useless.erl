-module(useless).

-export([add/2, hello/0, greet_and_add_two/1]).

-define(HELLO, "Hello, world!").

-ifdef(DEBUGMODE).
-define(DEBUG(X), io:format("Debug: ~p~n", [X])).
-else.
-define(DEBUG(X), ok).
-endif.


add(A, B) -> ?DEBUG(A + B).


%% Shows greetings.
%% io::format/1 is the standard function used to output text.
hello() -> io:format(?HELLO ++ "~n").


greet_and_add_two(X) ->
    hello(),
    add(X, 2).
