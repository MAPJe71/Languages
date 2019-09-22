%
%http://erlang.org/documentation/doc-5.3.6.13/doc/getting_started/getting_started.html
%
-module(ping_pong).
-export([ping/0, pong/0]).

ping() ->
    Pong = spawn(ping_pong, pong, []),
    Pong ! {self(), ping},
    receive
        pong ->
            pong
    end.

pong() ->
    receive
        {Ping, ping} ->
            Ping ! pong
    end.