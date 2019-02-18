#lang scribble/manual

@(require (for-label racket))

@title{Indexer}

@defmodule[libgit2/include/indexer]


@defproc[(git_indexer_append
          [idx indexer?]
          [data bytes?]
          [size integer?]
          [stats git_transfer_progress?])
         integer?]{
 Add data to the indexer

}

@defproc[(git_indexer_commit
          [idx indexer?]
          [stats transfer_progress?])
         integer?]{
 Finalize the pack and index

 Resolve any pending deltas and write out the index file

}

@defproc[(git_indexer_free
          [idx indexer?])
         void?]{
 Free the indexer and its resources

}

@defproc[(git_indexer_hash
          [idx indexer?])
         oid?]{
 Get the packfile's hash

 A packfile's name is derived from the sorted hashing of all object names. This is only correct after the index has been finalized.

}

@defproc[(git_indexer_new
          [path string?]
          [int unsigned]
          [odb (or/c odb? #f)]
          [progress_cb git_transfer_progress_cb]
          [progress_cb_payload bytes?])
         indexer?]{
 Create a new indexer instance
}
