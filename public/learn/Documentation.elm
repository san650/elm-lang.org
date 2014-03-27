import Website.Skeleton (skeleton)
import Window

intro = [markdown|

<style type="text/css">
h3 { padding-top: 1em; }
pre {
  background-color: white;
  padding: 10px;
  border: 1px solid rgb(216, 221, 225);
  border-radius: 4px;
}
code > span.kw { color: #268BD2; }
code > span.dt { color: #268BD2; }
code > span.dv, code > span.bn, code > span.fl { color: #D33682; }
code > span.ch { color: #DC322F; }
code > span.st { color: #2AA198; }
code > span.co { color: #93A1A1; }
code > span.ot { color: #A57800; }
code > span.al { color: #CB4B16; font-weight: bold; }
code > span.fu { color: #268BD2; }
code > span.re { }
code > span.er { color: #D30102; font-weight: bold; }
</style>

# Documentation

The `elm-doc` command-line tool extracts documentation as JSON.
This document describes [the format for Elm documentation](#documenting-elm-code)
and [the format of the JSON produced by `elm-doc`](#resulting-json).

## Documenting Elm code

This documentation format strives for simplicity and regularity. It should
be easy for readers to glance through a file and find the information they
need.

Check out the two files—[Maybe](https://github.com/elm-lang/Elm/blob/master/libraries/Maybe.elm)
and [Either](https://github.com/elm-lang/Elm/blob/master/libraries/Either.elm)—before
reading the following prose description of how it works.

Did you look at those files? Do that now.

General Facts:

 * All documentation lives in comment blocks that start with `{-|` and end with `-}`
 * All documentation allows the same kind of markdown that Elm allows
 * The documentation begins directly after the vertical bar. Using the first line is recommended. It sort of looks like a paragraph indent that way, and is generally less awkward.
 * Documentation for values and functions always sits directly above the type annotation.

When documenting the whole module:

 * Structure is independent of the order of functions in the file.
 * The documentation for the whole module comes directly *below* the module declaration.
   This means the module name is always the first thing you see in a file.
 * The module documentation allows the "@docs head, tail, map, fold" syntax to
   indicate that the relevant documentation should now appear in the given order.
 * Infix ops with custom associativity and precedence are parsed and that info is
   incorporated into the docs.

## Resulting JSON

When you run `elm-doc` on a file, the output is a JSON file. There is a default way
to display it on [docs.elm-lang.org](http://docs.elm-lang.org/), but it is easy to
parse and you can display it however you please. This also means an IDE could easily
read the JSON docs and use that information for inline docs or autocompletion.
Or a library search feature could crawl over this info.

#### Actual Structure

A module maps to a record that has: name, document, aliases, datatypes, values.
The "document" field is the markdown description the structure of the documentation.

Documentation for values, aliases, and datatypes include a "raw" field that just shows
how the original author typeset things. This lets us use the author's typesetting in
user facing docs. It also has a "type" field which gives a structured representation
of this info. This will be convenient for dev tools. The JSON representation of types
works as follows:

 * Type variables are strings.
 * ADT's are lists. The first element is a string that is the name of the type. The other elements are any arguments to that ADT.
 * Records are objects. An extended record has a "_" field that holds another record.

Some translations from Elm types to JSON:

```javascript
Int             == ["Int"]
Maybe a         == ["Maybe", "a"]
Either String a == ["Either",["String"],"a"]
a -> b          == ["->", "a", "b"]
a -> Maybe a    == ["->", "a", ["Maybe","a"]]
{x:Int, y:Int}  == { "x":["Int"], "y":["Int"] }
```

The goal is to make types pretty easy to work with in whatever language you happen to be using,
so no one has to do parsing in whatever tool or service they base on this data :)

|]

content w = width (min 600 w) intro

main = lift (skeleton content) Window.dimensions
