defmodule PipeHereTest do
  use ExUnit.Case
  doctest PipeHere

  import PipeHere.Assertions
  import PipeHere

  # Silence "warning: unused import PipeHere"
  pipe_here(nil)

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

  test "remote call with ref and placeholder expands to pipe" do
    a = quote do
      a |> M.b(&x/1, _) |> pipe_here
    end
    b = quote do
      M.b(&x/1, a)
    end
    assert_expands_to a, b, __ENV__
  end

  test "mixed with non-placeholder calls" do
    a = quote do
      a |> b(1, _) |> c |> d(2, _, 3) |> e.(4) |> pipe_here
    end
    b = quote do
      e.(d(2, c(b(1, a)) ,3), 4)
    end
    assert_expands_to a, b, __ENV__
  end

end
