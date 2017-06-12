#lang scribble/manual

@(require (for-label racket))

@title{Refdb}

@defmodule[libgit2/include/refdb]


@defproc[(git_refdb_backend_fs
          [repo repository?])
         refdb_backend?]{
 Constructors for default filesystem-based refdb backend

 Under normal usage, this is called for you when the repository is opened / created, but you can use this to explicitly construct a filesystem refdb backend for a repository.

}

@defproc[(git_refdb_compress
          [refdb refdb?])
         integer?]{
 Suggests that the given refdb compress or optimize its references. This mechanism is implementation specific. For on-disk reference databases, for example, this may pack all loose references.

}

@defproc[(git_refdb_free
          [refdb refdb?])
         void?]{
 Close an open reference database.

}

@defproc[(git_refdb_init_backend
          [backend refdb_backend?]
          [version integer?])
         integer?]{
 Initializes a git_refdb_backend with default values. Equivalent to creating an instance with GIT_REFDB_BACKEND_INIT.

}

@defproc[(git_refdb_new
          [repo repository?])
         refdb?]{
 Create a new reference database with no backends.

 Before the Ref DB can be used for read/writing, a custom database backend must be manually set using git_refdb_set_backend()

}

@defproc[(git_refdb_open
          [repo repository?])
         refdb?]{
 Create a new reference database and automatically add the default backends:

 git_refdb_dir: read and write loose and packed refs from disk, assuming the repository dir as the folder
}

@defproc[(git_refdb_set_backend
          [refdb refdb?]
          [backend refdb_backend?])
         integer?]{
 Sets the custom backend to an existing reference DB

 The git_refdb will take ownership of the git_refdb_backend so you should NOT free it after calling this function.
}
