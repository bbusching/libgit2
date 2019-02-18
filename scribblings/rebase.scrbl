#lang scribble/manual

@(require (for-label racket))

@title{Rebase}

@defmodule[libgit2/include/rebase]


@defproc[(git_rebase_abort
          [rebase rebase?])
         integer?]{
 Aborts a rebase that is currently in progress, resetting the repository and working directory to their state before rebase began.

}

@defproc[(git_rebase_commit
          [id oid?]
          [rebase rebase?]
          [author (or/c signature? #f)]
          [committer signature?]
          [message_encoding (or/c string? #f)]
          [message (or/c string? #f)])
         integer?]{
 Commits the current patch. You must have resolved any conflicts that were introduced during the patch application from the git_rebase_next invocation.

}

@defproc[(git_rebase_finish
          [rebase rebase?]
          [signature (or/c signature? #f)])
         integer?]{
 Finishes a rebase that is currently in progress once all patches have been applied.

}

@defproc[(git_rebase_free
          [rebase rebase?])
         void?]{
 Frees the git_rebase object.

}

@defproc[(git_rebase_init
          [repo repository?]
          [branch annotated_commit?]
          [upstream annotated_commit?]
          [onto annotated_commit?]
          [opts git_rebase_opts?])
         rebase?]{
 Initializes a rebase operation to rebase the changes in branch relative to upstream onto another branch. To begin the rebase process, call git_rebase_next. When you have finished with this object, call git_rebase_free.

}

@defproc[(git_rebase_init_options
          [opts git_rebase_opts?]
          [version integer?])
         integer?]{
 Initializes a git_rebase_options with default values. Equivalent to creating an instance with GIT_REBASE_OPTIONS_INIT.

}

@defproc[(git_rebase_inmemory_index
          [rebase rebase?])
         index?]{
 Gets the index produced by the last operation, which is the result of git_rebase_next and which will be committed by the next invocation of git_rebase_commit. This is useful for resolving conflicts in an in-memory rebase before committing them. You must call git_index_free when you are finished with this.

 This is only applicable for in-memory rebases; for rebases within a working directory, the changes were applied to the repository's index.

}

@defproc[(git_rebase_next
          [rebase rebase?])
         rebase_operation?]{
 Performs the next rebase operation and returns the information about it. If the operation is one that applies a patch (which is any operation except GIT_REBASE_OPERATION_EXEC) then the patch will be applied and the index and working directory will be updated with the changes. If there are conflicts, you will need to address those before committing the changes.

}

@defproc[(git_rebase_open
          [repo repository?]
          [opts git_rebase_opts?])
         rebase?]{
 Opens an existing rebase that was previously started by either an invocation of git_rebase_init or by another client.

}

@defproc[(git_rebase_operation_byindex
          [rebase rebase?]
          [idx integer?])
         rebase_operation?]{
 Gets the rebase operation specified by the given index.

}

@defproc[(git_rebase_operation_current
          [rebase rebase?])
         integer?]{
 Gets the index of the rebase operation that is currently being applied. If the first operation has not yet been applied (because you have called init but not yet next) then this returns GIT_REBASE_NO_OPERATION.

}

@defproc[(git_rebase_operation_entrycount
          [rebase rebase?])
         integer?]{
 Gets the count of rebase operations that are to be applied.
}
