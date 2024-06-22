-module(guard).
-compile(export_all).


old_enough(X) when X >= 16 -> true;
old_enough(_) -> false.
