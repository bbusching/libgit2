#lang scribble/manual

@(require (for-label racket))

@title{Revwalk}

@defmodule[libgit2/include/revwalk]


@defproc[(git_revwalk_add_hide_cb
          [walk revwalk?]
          [hide_cb git_revwalk_hide_cb]
          [payload bytes?])
         integer?]{
 Adds a callback function to hide a commit and its parents

}

@defproc[(git_revwalk_free
          [walk revwalk?])
         void?]{
 Free a revision walker previously allocated.

}

@defproc[(git_revwalk_hide
          [walk revwalk?]
          [commit_id oid?])
         integer?]{
 Mark a commit (and its ancestors) uninteresting for the output.

 The given id must belong to a committish on the walked repository.

 The resolved commit and all its parents will be hidden from the output on the revision walk.

}

@defproc[(git_revwalk_hide_glob
          [walk revwalk?]
          [glob string?])
         integer?]{
 Hide matching references.

 The OIDs pointed to by the references that match the given glob pattern and their ancestors will be hidden from the output on the revision walk.

 A leading 'refs/' is implied if not present as well as a trailing '/*' if the glob lacks '?', '*' or '['.

 Any references matching this glob which do not point to a committish will be ignored.

}

@defproc[(git_revwalk_hide_head
          [walk revwalk?])
         integer?]{
 Hide the repository's HEAD

}

@defproc[(git_revwalk_hide_ref
          [walk revwalk?]
          [refname string?])
         integer?]{
 Hide the OID pointed to by a reference

 The reference must point to a committish.

}

@defproc[(git_revwalk_new
          [repo repository?])
         revwalk?]{
 Allocate a new revision walker to iterate through a repo.

 This revision walker uses a custom memory pool and an internal commit cache, so it is relatively expensive to allocate.

 For maximum performance, this revision walker should be reused for different walks.

 This revision walker is not thread safe: it may only be used to walk a repository on a single thread; however, it is possible to have several revision walkers in several different threads walking the same repository.

}

@defproc[(git_revwalk_next
          [out oid?]
          [walk revwalk?])
         integer?]{
 Get the next commit from the revision walk.

 The initial call to this method is not blocking when iterating through a repo with a time-sorting mode.

 Iterating with Topological or inverted modes makes the initial call blocking to preprocess the commit list, but this block should be mostly unnoticeable on most repositories (topological preprocessing times at 0.3s on the git.git repo).

 The revision walker is reset when the walk is over.

}

@defproc[(git_revwalk_push
          [walk revwalk?]
          [id oid?])
         integer?]{
 Add a new root for the traversal

 The pushed commit will be marked as one of the roots from which to start the walk. This commit may not be walked if it or a child is hidden.

 At least one commit must be pushed onto the walker before a walk can be started.

 The given id must belong to a committish on the walked repository.

}

@defproc[(git_revwalk_push_glob
          [walk revwalk?]
          [glob string?])
         integer?]{
 Push matching references

 The OIDs pointed to by the references that match the given glob pattern will be pushed to the revision walker.

 A leading 'refs/' is implied if not present as well as a trailing '/*' if the glob lacks '?', '*' or '['.

 Any references matching this glob which do not point to a committish will be ignored.

}

@defproc[(git_revwalk_push_head
          [walk revwalk?])
         integer?]{
 Push the repository's HEAD

}

@defproc[(git_revwalk_push_range
          [walk revwalk?]
          [range string?])
         integer?]{
 Push and hide the respective endpoints of the given range.

 The range should be of the form .. where each is in the form accepted by 'git_revparse_single'. The left-hand commit will be hidden and the right-hand commit pushed.

}

@defproc[(git_revwalk_push_ref
          [walk revwalk?]
          [refname string?])
         integer?]{
 Push the OID pointed to by a reference

 The reference must point to a committish.

}

@defproc[(git_revwalk_repository
          [walk revwalk?])
         repository?]{
 Return the repository on which this walker is operating.

}

@defproc[(git_revwalk_reset
          [walker revwalk?])
         void?]{
 Reset the revision walker for reuse.

 This will clear all the pushed and hidden commits, and leave the walker in a blank state (just like at creation) ready to receive new commit pushes and start a new walk.

 The revision walk is automatically reset when a walk is over.

}

@defproc[(git_revwalk_simplify_first_parent
          [walk revwalk?])
         void?]{
 Simplify the history by first-parent

 No parents other than the first for each commit will be enqueued.

}

@defproc[(git_revwalk_sorting
          [walk revwalk?]
          [sort_mode _git_sort_t])
         void?]{
 Change the sorting mode when iterating through the repository's contents.

 Changing the sorting mode resets the walker.
}
