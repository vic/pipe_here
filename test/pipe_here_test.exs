defmodule PipeHereTest do
  use ExUnit.Case
  doctest PipeHere

  import PipeHere.Assertions
  import PipeHere

  test "non-piped term expands to itself" do
    a = quote do
      a |> pipe_here
    end
    b = quote do
      a
    end
    assert_expands_to a, b, __ENV__
  end

  test "piped term expands to itself" do
    a = quote do
      a |> b |> pipe_here
    end
    b = quote do
      b(a)
    end
    assert_expands_to a, b, __ENV__
  end

  test "call without placeholder expands to itself" do
    a = quote do
      a |> b(1) |> pipe_here
    end
    b = quote do
      b(a, 1)
    end
    assert_expands_to a, b, __ENV__
  end

  test "call with placeholder expands to pipe" do
    a = quote do
      a |> b(_) |> pipe_here
    end
    b = quote do
      b(a)
    end
    assert_expands_to a, b, __ENV__
  end

  test "call with placeholder at second idx expands to pipe" do
    a = quote do
      a |> b(1, _) |> pipe_here
    end
    b = quote do
      b(1, a)
    end
    assert_expands_to a, b, __ENV__
  end

  test "remote call with placeholder expands to pipe" do
    a = quote do
      a |> M.b(_) |> pipe_here
    end
    b = quote do
      M.b(a)
    end
    assert_expands_to a, b, __ENV__
  end

  test "remote call with placeholder at second idx expands to pipe" do
    a = quote do
      a |> M.b(1, _) |> pipe_here
    end
    b = quote do
      M.b(1, a)
    end
    assert_expands_to a, b, __ENV__
  end

  test "replaces placeholder in pipe" do
    a = quote do
      a |> b(1, _, 2) |> M.c(3, _) |> pipe_here
    end
    b = quote do
      M.c(3, b(1, a, 2))
    end
    assert_expands_to a, b, __ENV__
  end

  test "fncall with placeholder expands to pipe" do
    a = quote do
      a |> b.(_) |> pipe_here
    end
    b = quote do
      b.(a)
    end
    assert_expands_to a, b, __ENV__
  end

  test "retmote call with ref and placeholder expands to pipe" do
    a = quote do
      a |> M.b(&x/1, _) |> pipe_here
    end
    b = quote do
      M.b(&x/1, a)
    end
    assert_expands_to a, b, __ENV__
  end
end
