-module(what_the_if).
-export([heh_fine/0, oh_god/1]).


% if式
% ガード節の処理自体は必ず成功して何かを返すことが期待される
% elseやdefaultに当たるtrue節がない状態で失敗するとクラッシュする
heh_fine() ->
    if
        1 =:= 1 ->
            works
    end,
    if
        1 =:= 2; 1 =:= 1 ->
            works
    end,
    if
        1 =:= 2, 1 =:= 1 ->  % ここで失敗する
            fails  % ここに到達しない
    end.


oh_god(N) ->
    if
        N =:= 2 -> might_succeed;
        true -> always_does  % クラッシュしないためのcatch-allブランチ。else節的なやつ
    end.
%% Q.なぜelseではなくtrueなのか？ A.else節に相当するものは、そもそも避けるべきだという考え。ifの条件説で網羅してねと。
%% そのために、あんまり使いたくないような名前にした？
