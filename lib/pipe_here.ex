defmodule PipeHere do

  defmacro pipe_here(x) do
    x |> PipeHere.Macro.piped |> PipeHere.Macro.unpipe |> rewrite_pipe
  end

  defp rewrite_pipe([x]), do: x
  defp rewrite_pipe([a | rest]) do
    if Enum.any?(rest, &call_with_placeholder?/1) do
      rest |> Enum.map(&rewrite_call/1) |> List.insert_at(0, a) |> Enum.reduce(&pipe/2)
    else
      [a | rest] |> Enum.reduce(&PipeHere.Macro.rpipe/2)
    end
  end

  defp rewrite_call(call = {a, l, args = [_ | _]}) do
    idx = Enum.find_index(args, &placeholder?/1)
    if idx == nil do
      {call, 0}
    else
      {{a, l, List.delete_at(args, idx)}, idx}
    end
  end

  defp pipe({b, idx}, a) do
    Macro.pipe(a, b, idx)
  end

  defp call_with_placeholder?({_, _, args = [_ | _]}) do
    Enum.any?(args, &placeholder?/1)
  end
  defp call_with_placeholder?(_), do: false


  defp placeholder?({:_, _, x}) when is_atom(x), do: true
  defp placeholder?(_), do: false


end
