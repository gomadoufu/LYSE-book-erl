-module(guard).
-export([old_enough/1, right_age/1]).


%% ガード
%% 成功時にはtrueを返す。それ以外ならfalseか例外を投げる
%% ガード節にユーザ定義の関数は利用できない
old_enough(X) when X >= 16 -> true;
old_enough(_) -> false.


right_age(X) when X >= 16, X < 104 -> true;
right_age(_) -> false.
