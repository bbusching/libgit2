#lang scribble/manual

@(require (for-label racket))

@title{Treebuilder}

@defmodule[libgit2/include/treebuilder]


@defproc[(git_treebuilder_clear
          [bld treebuilder?])
         void?]{
 Clear all the entires in the builder

}

@defproc[(git_treebuilder_entrycount
          [bld treebuilder?])
         integer?]{
 Get the number of entries listed in a treebuilder

}

@defproc[(git_treebuilder_filter
          [bld treebuilder?]
          [filter _git_treebuilder_filter_cb]
          [payload bytes?])
         integer?]{
 Selectively remove entries in the tree

 The filter callback will be called for each entry in the tree with a pointer to the entry and the provided payload; if the callback returns non-zero, the entry will be filtered (removed from the builder).

}

@defproc[(git_treebuilder_free
          [bld treebuilder?])
         void?]{
 Free a tree builder

 This will clear all the entries and free to builder. Failing to free the builder after you're done using it will result in a memory leak

}

@defproc[(git_treebuilder_get
          [bld treebuilder?]
          [filename string?])
         tree_entry?]{
 Get an entry from the builder from its filename

 The returned entry is owned by the builder and should not be freed manually.

}

@defproc[(git_treebuilder_insert
          [bld treebuilder?]
          [filename string?]
          [id oid?]
          [filemode _git_filemode_t])
         tree_entry?]{
 Add or update an entry to the builder

 Insert a new entry for filename in the builder with the given attributes.

 If an entry named filename already exists, its attributes will be updated with the given ones.

 The optional pointer out can be used to retrieve a pointer to the newly created/updated entry. Pass NULL if you do not need it. The pointer may not be valid past the next operation in this builder. Duplicate the entry if you want to keep it.

 No attempt is being made to ensure that the provided oid points to an existing git object in the object database, nor that the attributes make sense regarding the type of the pointed at object.

}

@defproc[(git_treebuilder_new
          [repo repository?]
          [source tree?])
         treebuilder?]{
 Create a new tree builder.

 The tree builder can be used to create or modify trees in memory and write them as tree objects to the database.

 If the source parameter is not NULL, the tree builder will be initialized with the entries of the given tree.

 If the source parameter is NULL, the tree builder will start with no entries and will have to be filled manually.

}

@defproc[(git_treebuilder_remove
          [bld treebuilder?]
          [filename string?])
         integer?]{
 Remove an entry from the builder by its filename

}

@defproc[(git_treebuilder_write
          [id oid?]
          [bld treebuilder?])
         integer?]{
 Write the contents of the tree builder as a tree object

 The tree builder will be written to the given repo, and its identifying SHA1 hash will be stored in the id pointer.
}
