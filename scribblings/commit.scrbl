#lang scribble/manual

@(require (for-label racket))

@title{Commit}

@defmodule[libgit2/include/commit]


@defproc[(git_commit_amend
          [id oid?]
          [commit_to_amend commit?]
          [update_ref (or/c string? #f)]
          [author (or/c signature? #f)]
          [committer (or/c signature? #f)]
          [message_encoding (or/c string? #f)]
          [message (or/c string? #f)]
          [tree (or/c tree? #f)])
         integer?]{
 Amend an existing commit by replacing only non-NULL values.

 This creates a new commit that is exactly the same as the old commit, except that any non-NULL values will be updated. The new commit has the same parents as the old commit.

 The update_ref value works as in the regular git_commit_create(), updating the ref to point to the newly rewritten commit. If you want to amend a commit that is not currently the tip of the branch and then rewrite the following commits to reach a ref, pass this as NULL and update the rest of the commit chain and ref separately.

 Unlike git_commit_create(), the author, committer, message, message_encoding, and tree parameters can be NULL in which case this will use the values from the original commit_to_amend.

 All parameters have the same meanings as in git_commit_create().
}

@defproc[(git_commit_author
          [commit commit?])
         signature?]{
 Get the author of a commit.

}

@defproc[(git_commit_body
          [commit commit?])
         string?]{
 Get the long "body" of the git commit message.

 The returned message is the body of the commit, comprising everything but the first paragraph of the message. Leading and trailing whitespaces are trimmed.

}

@defproc[(git_commit_committer
          [commit commit?])
         signature?]{
 Get the committer of a commit.

}

@defproc[(git_commit_create
          [id oid?]
          [repo repository?]
          [update_ref (or/c string? #f)]
          [author signature?]
          [committer signature?]
          [message_encoding (or/c string? #f)]
          [message string?]
          [tree tree?]
          [parent_count exact-positive-integer?]
          [parents (or/c (_cpointer _commit) #f)])
         integer?]{
 Create new commit in the repository from a list of git_object pointers

 The message will not be cleaned up automatically. You can do that with the git_message_prettify() function.

}

@defproc[(git_commit_create_buffer
          [out buf?]
          [repo repository?]
          [author signature?]
          [committer signature?]
          [message_encoding (or/c string? #f)]
          [message string?]
          [tree tree?]
          [parent_count exact-positive-integer?]
          [parents (or/c (_cpointer _commit) #f)])
         integer?]{
 Create a commit and write it into a buffer

 Create a commit as with git_commit_create() but instead of writing it to the objectdb, write the contents of the object into a buffer.

}

@defproc[(git_commit_create_from_callback
          [id oid?]
          [repo repository?]
          [update_ref (or/c string? #f)]
          [author signature?]
          [committer signature?]
          [message_encoding (or/c string? #f)]
          [message string?]
          [tree oid?]
          [parent_cb git_commit_parent_callback]
          [parent_payload (or/c (_cpointer _void) #f)])
         integer?]{
 Create a new commit in the repository with an callback to supply parents.

 See documentation for git_commit_create() for information about the parameters, as the meaning is identical excepting that tree takes a git_oid and doesn't check for validity, and parent_cb is invoked with parent_payload and should return git_oid values or NULL to indicate that all parents are accounted for.

}

@defproc[(git_commit_create_from_ids
          [id oid?]
          [repo repository?]
          [update_ref (or/c string? #f)]
          [author signature?]
          [committer signature?]
          [message_encoding (or/c string? #f)]
          [message string?]
          [tree oid?]
          [parent_count size_t]
          [parents (_cpointer _oid)])
         integer?]{
 Create new commit in the repository from a list of git_oid values.

 See documentation for git_commit_create() for information about the parameters, as the meaning is identical excepting that tree and parents now take git_oid. This is a dangerous API in that nor the tree, neither the parents list of git_oids are checked for validity.

}

@defproc[(git_commit_create_v
          [id oid?]
          [repo repository?]
          [update_ref (or/c string? #f)]
          [author signature?]
          [committer signature?]
          [message_encoding (or/c string? #f)]
          [message string?]
          [tree tree?]
          [parent_count exact-positive-integer?])
         integer?]{
 Create new commit in the repository using a variable argument list.

 The message will not be cleaned up automatically. You can do that with the git_message_prettify() function.

 The parents for the commit are specified as a variable list of pointers to const git_commit *. Note that this is a convenience method which may not be safe to export for certain languages or compilers

 All other parameters remain the same as git_commit_create().

}

@defproc[(git_commit_create_with_signature
          [out oid?]
          [repo repository?]
          [commit_content string?]
          [signature string?]
          [signature_field (or/c string? #f)])
         integer?]{
 Create a commit object from the given buffer and signature

 Given the unsigned commit object's contents, its signature and the header field in which to store the signature, attach the signature to the commit and write it into the given repository.

 'signature_field' defaults to "gpgsig"
}

@defproc[(git_commit_dup
          [source commit?])
         commit?]{
 Create an in-memory copy of a commit. The copy must be explicitly free'd or it will leak.

}

@defproc[(git_commit_extract_signature
          [signature buf?]
          [signed_data buf?]
          [repo repository?]
          [commit_id oid?]
          [field (or/c string? #f)])
         integer?]{
 Extract the signature from a commit

 If the id is not for a commit, the error class will be GITERR_INVALID. If the commit does not have a signature, the error class will be GITERR_OBJECT.

 'field' defaults to "gpgsig"
}

@defproc[(git_commit_free
          [commit commit?])
         void?]{
 Close an open commit

 This is a wrapper around git_object_free()

 IMPORTANT: It is necessary to call this method when you stop using a commit. Failure to do so will cause a memory leak.

}

@defproc[(git_commit_header_field
          [out buf?]
          [commit commit?]
          [field string?])
         integer?]{
 Get an arbitrary header field

}

@defproc[(git_commit_id
          [commit commit?])
         oid?]{
 Get the id of a commit.

}

@defproc[(git_commit_lookup
          [repo repository?]
          [id oid?])
         commit?]{
 Lookup a commit object from a repository.

 The returned object should be released with git_commit_free when no longer needed.

}

@defproc[(git_commit_lookup_prefix
          [repo repository?]
          [id oid?]
          [len exact-positive-integer?])
         commit?]{
 Lookup a commit object from a repository, given a prefix of its identifier (short id).

 The returned object should be released with git_commit_free when no longer needed.

}

@defproc[(git_commit_message
          [commit commit?])
         string?]{
 Get the full message of a commit.

 The returned message will be slightly prettified by removing any potential leading newlines.

}

@defproc[(git_commit_message_encoding
          [commit commit?])
         string?]{
 Get the encoding for the message of a commit, as a string representing a standard encoding name.

 The encoding may be NULL if the encoding header in the commit is missing; in that case UTF-8 is assumed.

}

@defproc[(git_commit_message_raw
          [commit commit?])
         bytes?]{
 Get the full raw message of a commit.

}

@defproc[(git_commit_nth_gen_ancestor
          [commit commit?]
          [int unsigned])
         commit?]{
 Get the commit object that is the <n

 th generation ancestor of the named commit object, following only the first parents. The returned commit has to be freed by the caller.

 Passing 0 as the generation number returns another instance of the base commit itself.

}

@defproc[(git_commit_owner
          [commit commit?])
         repository?]{
 Get the repository that contains the commit.

}

@defproc[(git_commit_parent
          [commit commit?]
          [int unsigned])
         commit?]{
 Get the specified parent of the commit.

}

@defproc[(git_commit_parent_id
          [commit commit?]
          [int unsigned])
         oid?]{
 Get the oid of a specified parent for a commit. This is different from git_commit_parent, which will attempt to load the parent commit from the ODB.

}

@defproc[(git_commit_parentcount
          [commit commit?])
         integer?]{
 Get the number of parents of this commit

}

@defproc[(git_commit_raw_header
          [commit commit?])
         string?]{
 Get the full raw text of the commit header.

}

@defproc[(git_commit_summary
          [commit commit?])
         string?]{
 Get the short "summary" of the git commit message.

 The returned message is the summary of the commit, comprising the first paragraph of the message with whitespace trimmed and squashed.

}

@defproc[(git_commit_time
          [commit commit?])
         git_time_t?]{
 Get the commit time (i.e. committer time) of a commit.

}

@defproc[(git_commit_time_offset
          [commit commit?])
         integer?]{
 Get the commit timezone offset (i.e. committer's preferred timezone) of a commit.

}

@defproc[(git_commit_tree
          [commit commit?])
         tree?]{
 Get the tree pointed to by a commit.

}

@defproc[(git_commit_tree_id
          [commit commit?])
         oid?]{
 Get the id of the tree pointed to by a commit. This differs from git_commit_tree in that no attempts are made to fetch an object from the ODB.
}
