# PipeHere <a href="https://travis-ci.org/vic/pipe_here"><img src="https://travis-ci.org/vic/pipe_here.svg"></a>

An Elixir macro for easily piping arguments at any position.

## Usage

```elixir
import PipeHere
```

The `pipe_here` macro lets you specify the argument position
while piping values by using the `_` placeholder.

For example:

```elixir
pipe_here( 2 |> x(1, _, 3) )

# expands to

x(1, 2, 3)
```

The `pipe_here` macro can also be used at the end of a pipe:

```elixir
2 |> x(1, _, 3) |> pipe_here
```

Note that while you can do stuff like:

```elixir
a |> b(1, _) |> c |> d(2, _, 3) |> pipe_here
```

every member of the pipe can at most have just one `_` placeholder.


## Installation

[Available in Hex](https://hex.pm/packages/pipe_here), the package can be installed as:

  1. Add pipe_here to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:pipe_here, "~> 1.0.0"}]
end
```

## Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434)

##### マクロス Makurosu

[[Elixir macros](https://github.com/h4cc/awesome-elixir#macros),] The things I do for beautiful code
― George Martin, Game of Thrones

[#myelixirstatus](https://twitter.com/hashtag/myelixirstatus?src=hash)
[#FridayLiterally](http://futurice.com/blog/friday-literally)
