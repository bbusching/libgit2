#lang scribble/manual

@(require (for-label racket))

@title{Reflog}

@defmodule[libgit2/include/reflog]


@defproc[(git_reflog_append
          [reflog reflog?]
          [id oid?]
          [committer signature?]
          [msg string?])
         integer?]{
 Add a new entry to the in-memory reflog.

 msg is optional and can be NULL.

}

@defproc[(git_reflog_delete
          [repo repository?]
          [name string?])
         integer?]{
 Delete the reflog for the given reference

}

@defproc[(git_reflog_drop
          [reflog reflog?]
          [idx size_t]
          [rewrite_previous_entry boolean?])
         integer?]{
 Remove an entry from the reflog by its index

 To ensure there's no gap in the log history, set rewrite_previous_entry param value to 1. When deleting entry n, member old_oid of entry n-1 (if any) will be updated with the value of member new_oid of entry n+1.

}

@defproc[(git_reflog_entry_byindex
          [reflog reflog?]
          [idx size_t])
         integer?]{
 Lookup an entry by its index

 Requesting the reflog entry with an index of 0 (zero) will return the most recently created entry.

}

@defproc[(git_reflog_entry_committer
          [entry reflog_entry?])
         integer?]{
 Get the committer of this entry

}

@defproc[(git_reflog_entry_id_new
          [entry reflog_entry?])
         integer?]{
 Get the new oid

}

@defproc[(git_reflog_entry_id_old
          [entry reflog_entry?])
         integer?]{
 Get the old oid

}

@defproc[(git_reflog_entry_message
          [entry reflog_entry?])
         integer?]{
 Get the log message

}

@defproc[(git_reflog_entrycount
          [reflog reflog?])
         integer?]{
 Get the number of log entries in a reflog

}

@defproc[(git_reflog_free
          [reflog reflog?])
         void?]{
 Free the reflog

}

@defproc[(git_reflog_read
          [repo repository?]
          [name string?])
         reflog?]{
 Read the reflog for the given reference

 If there is no reflog file for the given reference yet, an empty reflog object will be returned.

 The reflog must be freed manually by using git_reflog_free().

}

@defproc[(git_reflog_rename
          [repo repository?]
          [old_name string?]
          [name string?])
         integer?]{
 Rename a reflog

 The reflog to be renamed is expected to already exist

 The new name will be checked for validity. See git_reference_create_symbolic() for rules about valid names.

}

@defproc[(git_reflog_write
          [reflog reflog?])
         integer?]{
 Write an existing in-memory reflog object back to disk using an atomic file lock.
}
