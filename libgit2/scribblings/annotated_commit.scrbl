#lang scribble/manual

@(require (for-label racket))

@title{Annotated Commit}

@defmodule[libgit2/include/annotated_commit]


@defproc[(git_annotated_commit_free
          [commit annotated_commit?])
         void?]{
 Frees a git_annotated_commit.

}

@defproc[(git_annotated_commit_from_fetchhead
          [repo repository?]
          [branch_name string?]
          [remote_url string?]
          [id oid?])
         annotated_commit?]{
 Creates a git_annotated_commit from the given fetch head data. The resulting git_annotated_commit must be freed with git_annotated_commit_free.

}

@defproc[(git_annotated_commit_from_ref
          [repo repository?]
          [ref reference?])
         annotated_commit?]{
 Creates a git_annotated_commit from the given reference. The resulting git_annotated_commit must be freed with git_annotated_commit_free.

}

@defproc[(git_annotated_commit_from_revspec
          [repo repository?]
          [revspec string?])
         annotated_commit?]{
 Creates a git_annotated_comit from a revision string.

 See man gitrevisions, or http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for information on the syntax accepted.

}

@defproc[(git_annotated_commit_id
          [commit annotated_commit?])
         integer?]{
 Gets the commit ID that the given git_annotated_commit refers to.

}

@defproc[(git_annotated_commit_lookup
          [repo repository?]
          [id oid?])
         annotated_commit?]{
 Creates a git_annotated_commit from the given commit id. The resulting git_annotated_commit must be freed with git_annotated_commit_free.

 An annotated commit contains information about how it was looked up, which may be useful for functions like merge or rebase to provide context to the operation. For example, conflict files will include the name of the source or target branches being merged. It is therefore preferable to use the most specific function (eg git_annotated_commit_from_ref) instead of this one when that data is known.
}
