# irmin-graphql

This package provides a GraphQL API on top of a [Irmin](https://github.com/mirage/irmin) store.

Dependencies:

- `irmin-unix`
- `graphql` (version 0.7 or greater)
- `graphql-lwt`

## Installation

```shell
$ opam pin add irmin-graphql https://github.com/andreas/irmin-graphql
```

## Command-line example

To expose a git repo over GraphQL, clone the repo, then run the following:

```
dune exec irmin-graphql -s git --root /path/to/git-repo 8080
```

Now open [http://localhost:8080/graphql](http://localhost:8080/graphql) and enjoy!

For more information about using the command line see the output of `irmin-graphql --help`
