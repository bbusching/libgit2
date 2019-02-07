#lang scribble/manual

@(require (for-label racket))

@title{Merge}

@defmodule[libgit2/include/merge]


@defproc[(git_merge
          [repo repository?]
          [their_heads (_cpointer annotated_commit?)]
          [their_heads_len integer?]
          [merge_opts git_merge_opts?]
          [checkout_opts git_checkout_opts?])
         integer?]{
 Merges the given commit(s) into HEAD, writing the results into the working directory. Any changes are staged for commit and any conflicts are written to the index. Callers should inspect the repository's index after this completes, resolve any conflicts and prepare a commit.

 For compatibility with git, the repository is put into a merging state. Once the commit is done (or if the uses wishes to abort), you should clear this state by calling git_repository_state_cleanup().

}

@defproc[(git_merge_analysis
          [analysis_out (_cpointer _git_merge_analysis_t)]
          [preference_out (_cpointer _gitmerge_preference_t)]
          [repo repository?]
          [their_heads (_cpointer annotated_commit?)]
          [their_heads_len integer?])
         integer?]{
 Analyzes the given branch(es) and determines the opportunities for merging them into the HEAD of the repository.

}

@defproc[(git_merge_base
          [out oid?]
          [repo repository?]
          [one oid?]
          [two oid?])
         integer?]{
 Find a merge base between two commits

}

@defproc[(git_merge_base_many
          [out oid?]
          [repo repository?]
          [length integer?]
          [input_array (_cpointer oid?)])
         integer?]{
 Find a merge base given a list of commits

}

@defproc[(git_merge_base_octopus
          [out oid?]
          [repo repository?]
          [length integer?]
          [input_array (_cpointer oid?)])
         integer?]{
 Find a merge base in preparation for an octopus merge

}

@defproc[(git_merge_bases
          [out oidarray?]
          [repo repository?]
          [one oid?]
          [two oid?])
         integer?]{
 Find merge bases between two commits

}

@defproc[(git_merge_bases_many
          [out oidarray?]
          [repo repository?]
          [length integer?]
          [input_array (_cpointer oid?)])
         integer?]{
 Find all merge bases given a list of commits

}

@defproc[(git_merge_commits
          [repo repository?]
          [our_commit commit?]
          [their_commit commit?]
          [opts (or/c git_merge_opts? #f)])
         index?]{
 Merge two commits, producing a git_index that reflects the result of the merge. The index may be written as-is to the working directory or checked out. If the index is to be converted to a tree, the caller should resolve any conflicts that arose as part of the merge.

 The returned index must be freed explicitly with git_index_free.

}

@defproc[(git_merge_file
          [out git_merge_file_result?]
          [ancestor merge_file_input?]
          [ours merge_file_input?]
          [theirs merge_file_input?]
          [opts (or/c git_merge_file_opts?)])
         integer?]{
 Merge two files as they exist in the in-memory data structures, using the given common ancestor as the baseline, producing a git_merge_file_result that reflects the merge result. The git_merge_file_result must be freed with git_merge_file_result_free.

 Note that this function does not reference a repository and any configuration must be passed as git_merge_file_options.

}

@defproc[(git_merge_file_from_index
          [out merge_file_result?]
          [repo repository?]
          [ancestor index_entry?]
          [ours index_entry?]
          [theirs index_entry?]
          [opts (or/c git_merge_file_opts? #f)])
         integer?]{
 Merge two files as they exist in the index, using the given common ancestor as the baseline, producing a git_merge_file_result that reflects the merge result. The git_merge_file_result must be freed with git_merge_file_result_free.

}

@defproc[(git_merge_file_init_input
          [opts merge_file_input?]
          [version integer?])
         integer?]{
 Initializes a git_merge_file_input with default values. Equivalent to creating an instance with GIT_MERGE_FILE_INPUT_INIT.

}

@defproc[(git_merge_file_init_options
          [opts merge_file_options?]
          [version integer?])
         integer?]{
 Initializes a git_merge_file_options with default values. Equivalent to creating an instance with GIT_MERGE_FILE_OPTIONS_INIT.

}

@defproc[(git_merge_file_result_free
          [result merge_file_result?])
         void?]{
 Frees a git_merge_file_result.

}

@defproc[(git_merge_init_options
          [opts git_merge_opts?]
          [version integer?])
         integer?]{
 Initializes a git_merge_options with default values. Equivalent to creating an instance with GIT_MERGE_OPTIONS_INIT.

}

@defproc[(git_merge_trees
          [repo repository?]
          [ancestor_tree tree?]
          [our_tree tree?]
          [their_tree tree?]
          [opts (or/c git_merge_options? #f)])
         index?]{
 Merge two trees, producing a git_index that reflects the result of the merge. The index may be written as-is to the working directory or checked out. If the index is to be converted to a tree, the caller should resolve any conflicts that arose as part of the merge.

 The returned index must be freed explicitly with git_index_free.
}
