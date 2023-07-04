#lang scribble/manual

@(require (for-label racket))

@title{Packbuilder}

@defmodule[libgit2/include/packbuilder]


@defproc[(git_packbuilder_foreach
          [pb packbuilder?]
          [cb git_packbuilder_foreach_cb]
          [payload bytes?])
         integer?]{
 Create the new pack and pass each object to the callback

}

@defproc[(git_packbuilder_free
          [pb packbuilder?])
         void?]{
 Free the packbuilder and all associated data

}

@defproc[(git_packbuilder_hash
          [pb packbuilder?])
         oid?]{
 Get the packfile's hash

 A packfile's name is derived from the sorted hashing of all object names. This is only correct after the packfile has been written.

}

@defproc[(git_packbuilder_insert
          [pb packbuilder?]
          [id oid?]
          [name string?])
         integer?]{
 Insert a single object

 For an optimal pack it's mandatory to insert objects in recency order, commits followed by trees and blobs.

}

@defproc[(git_packbuilder_insert_commit
          [pb packbuilder?]
          [id oid?])
         integer?]{
 Insert a commit object

 This will add a commit as well as the completed referenced tree.

}

@defproc[(git_packbuilder_insert_recur
          [pb packbuilder?]
          [id oid?]
          [name string?])
         integer?]{
 Recursively insert an object and its referenced objects

 Insert the object as well as any object it references.

}

@defproc[(git_packbuilder_insert_tree
          [pb packbuilder?]
          [id oid?])
         integer?]{
 Insert a root tree object

 This will add the tree as well as all referenced trees and blobs.

}

@defproc[(git_packbuilder_insert_walk
          [pb packbuilder?]
          [walk revwalk?])
         integer?]{
 Insert objects as given by the walk

 Those commits and all objects they reference will be inserted into the packbuilder.

}

@defproc[(git_packbuilder_new
          [repo repository?])
         packbuilder?]{
 Initialize a new packbuilder

}

@defproc[(git_packbuilder_object_count
          [pb packbuilder?])
         integer?]{
 Get the total number of objects the packbuilder will write out

}

@defproc[(git_packbuilder_set_callbacks
          [pb packbuilder?]
          [progress_cb git_packbuilder_progress]
          [progress_cb_payload bytes?])
         integer?]{
 Set the callbacks for a packbuilder

}

@defproc[(git_packbuilder_set_threads
          [pb packbuilder?]
          [threads integer?])
         integer?]{
 Set number of threads to spawn

 By default, libgit2 won't spawn any threads at all; when set to 0, libgit2 will autodetect the number of CPUs.

}

@defproc[(git_packbuilder_write
          [pb packbuilder?]
          [path string?]
          [mode integer?]
          [progress_cb git_transfer_progress_cb]
          [progress_cb_payload bytes?])
         integer?]{
 Write the new pack and corresponding index file to path.

}

@defproc[(git_packbuilder_written
          [pb packbuilder?])
         integer?]{
 Get the number of objects the packbuilder has already written out
}
