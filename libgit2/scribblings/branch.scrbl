#lang scribble/manual

@(require (for-label racket))

@title{Branch}

@defmodule[libgit2/include/branch]


@defproc[(git_branch_create
          [repo repository?]
          [branch_name string?]
          [target commit?]
          [force boolean?])
         reference?]{
 Create a new branch pointing at a target commit

 A new direct reference will be created pointing to this target commit. If force is true and a reference already exists with the given name, it'll be replaced.

 The returned reference must be freed by the user.

 The branch name will be checked for validity. See git_tag_create() for rules about valid names.

}

@defproc[(git_branch_create_from_annotated
          [repository repository?]
          [branch_name string?]
          [commit annotated_commit?]
          [force boolean?])
         reference?]{
 Create a new branch pointing at a target commit

 This behaves like git_branch_create() but takes an annotated commit, which lets you specify which extended sha syntax string was specified by a user, allowing for more exact reflog messages.

 See the documentation for git_branch_create().

}

@defproc[(git_branch_delete
          [branch reference?])
         integer?]{
 Delete an existing branch reference.

 If the branch is successfully deleted, the passed reference object will be invalidated. The reference must be freed manually by the user.

}

@defproc[(git_branch_is_head
          [branch reference?])
         boolean?]{
 Determine if the current local branch is pointed at by HEAD.

}

@defproc[(git_branch_iterator_free
          [iter branch_iterator?])
         void?]{
 Free a branch iterator

}

@defproc[(git_branch_iterator_new
          [repo repository?]
          [list_flags _git_branch_t])
         branch_iterator?]{
 Create an iterator which loops over the requested branches.

}

@defproc[(git_branch_lookup
          [repo repository?]
          [branch_name string?]
          [branch_type _git_branch_t])
         reference?]{
 Lookup a branch by its name in a repository.

 The generated reference must be freed by the user.

 The branch name will be checked for validity. See git_tag_create() for rules about valid names.

}

@defproc[(git_branch_move
          [branch reference?]
          [new_branch_name string?]
          [force boolean?])
         reference?]{
 Move/rename an existing local branch reference.

 The new branch name will be checked for validity. See git_tag_create() for rules about valid names.

}

@defproc[(git_branch_name
          [ref reference?])
         string?]{
 Return the name of the given local or remote branch.

 The name of the branch matches the definition of the name for git_branch_lookup. That is, if the returned name is given to git_branch_lookup() then the reference is returned that was given to this function.

}

@defproc[(git_branch_next
          [out_type branch_t?]
          [iter branch_iterator?])
         any]{
 Retrieve the next branch and type from the iterator.

 Returns @racket[(values repository? _git_branch_t)]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}


@defproc[(git_branch_set_upstream
          [branch reference?]
          [upstream_name string?])
         integer?]{
 Set the upstream configuration for a given local branch

}

@defproc[(git_branch_upstream
          [branch reference?])
         reference?]{
 Return the reference supporting the remote tracking branch, given a local branch reference.
}
