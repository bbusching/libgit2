#lang scribble/manual

@(require (for-label racket))

@title{Reference}

@defmodule[libgit2/include/refs]


@defproc[(git_reference__alloc
          [name string?]
          [oid oid?]
          [peel (or/c oid? #f)])
         reference?]{
Create a new direct reference from an OID.

}

@defproc[(git_reference__alloc_symbolic
          [name string?]
          [target string?])
         reference?]{
Create a new symbolic reference.

}

@defproc[(git_reference_cmp
          [ref1 reference?]
          [ref2 reference?])
         integer?]{
 Compare two references.

}

@defproc[(git_reference_create
          [repo repository?]
          [name string?]
          [id oid?]
          [force boolean?]
          [log_message string?])
         reference?]{
 Create a new direct reference.

 A direct reference (also called an object id reference) refers directly to a specific object id (a.k.a. OID or SHA) in the repository. The id permanently refers to the object (although the reference itself can be moved). For example, in libgit2 the direct ref "refs/tags/v0.17.0" refers to OID 5b9fac39d8a76b9139667c26a63e6b3f204b3977.

 The direct reference will be created in the repository and written to the disk. The generated reference object must be freed by the user.

 Valid reference names must follow one of two patterns:

 Top-level names must contain only capital letters and underscores, and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD"). 2. Names prefixed with "refs/" can be almost anything. You must avoid the characters '~', '^', ':', '\', '?', '[', and '*', and the sequences ".." and @"@{" which have special meaning to revparse.
 This function will return an error if a reference already exists with the given name unless force is true, in which case it will be overwritten.

 The message for the reflog will be ignored if the reference does not belong in the standard set (HEAD, branches and remote-tracking branches) and and it does not have a reflog.

}

@defproc[(git_reference_create_matching
          [repo repository?]
          [name string?]
          [id oid?]
          [force boolean?]
          [current_id oid?]
          [log_message string?])
         reference?]{
 Conditionally create new direct reference

 A direct reference (also called an object id reference) refers directly to a specific object id (a.k.a. OID or SHA) in the repository. The id permanently refers to the object (although the reference itself can be moved). For example, in libgit2 the direct ref "refs/tags/v0.17.0" refers to OID 5b9fac39d8a76b9139667c26a63e6b3f204b3977.

 The direct reference will be created in the repository and written to the disk. The generated reference object must be freed by the user.

 Valid reference names must follow one of two patterns:

 Top-level names must contain only capital letters and underscores, and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD"). 2. Names prefixed with "refs/" can be almost anything. You must avoid the characters '~', '^', ':', '\', '?', '[', and '*', and the sequences ".." and @"@{" which have special meaning to revparse.
 This function will return an error if a reference already exists with the given name unless force is true, in which case it will be overwritten.

 The message for the reflog will be ignored if the reference does not belong in the standard set (HEAD, branches and remote-tracking branches) and and it does not have a reflog.

 It will return GIT_EMODIFIED if the reference's value at the time of updating does not match the one passed through current_id (i.e. if the ref has changed since the user read it).

}

@defproc[(git_reference_delete
          [ref reference?])
         integer?]{
 Delete an existing reference.

 This method works for both direct and symbolic references. The reference will be immediately removed on disk but the memory will not be freed. Callers must call git_reference_free.

 This function will return an error if the reference has changed from the time it was looked up.

}

@defproc[(git_reference_dup
          [source reference?])
         reference?]{
 Create a copy of an existing reference.

 Call git_reference_free to free the data.

}

@defproc[(git_reference_dwim
          [repo repository?]
          [shorthand string?])
         reference?]{
 Lookup a reference by DWIMing its short name

 Apply the git precendence rules to the given shorthand to determine which reference the user is referring to.

}

@defproc[(git_reference_ensure_log
          [repo repository?]
          [refname string?])
         integer?]{
 Ensure there is a reflog for a particular reference.

 Make sure that successive updates to the reference will append to its log.

}

@defproc[(git_reference_foreach
          [repo repository?]
          [callback git_reference_foreach_cb]
          [payload bytes?])
         integer?]{
 Perform a callback on each reference in the repository.

 The callback function will be called for each reference in the repository, receiving the reference object and the payload value passed to this method. Returning a non-zero value from the callback will terminate the iteration.

}

@defproc[(git_reference_foreach_glob
          [repo repository?]
          [glob string?]
          [callback git_reference_foreach_name_cb]
          [payload bytes?])
         integer?]{
 Perform a callback on each reference in the repository whose name matches the given pattern.

 This function acts like git_reference_foreach() with an additional pattern match being applied to the reference name before issuing the callback function. See that function for more information.

 The pattern is matched using fnmatch or "glob" style where a '*' matches any sequence of letters, a '?' matches any letter, and square brackets can be used to define character ranges (such as "[0-9]" for digits).

}

@defproc[(git_reference_foreach_name
          [repo repository?]
          [callback git_reference_foreach_name_cb]
          [payload bytes?])
         integer?]{
 Perform a callback on the fully-qualified name of each reference.

 The callback function will be called for each reference in the repository, receiving the name of the reference and the payload value passed to this method. Returning a non-zero value from the callback will terminate the iteration.

}

@defproc[(git_reference_free
          [ref reference?])
         void?]{
 Free the given reference.

}

@defproc[(git_reference_has_log
          [repo repository?]
          [refname string?])
         boolean?]{
 Check if a reflog exists for the specified reference.

}

@defproc[(git_reference_is_branch
          [ref reference?])
         boolean?]{
 Check if a reference is a local branch.

}

@defproc[(git_reference_is_note
          [ref reference?])
         boolean?]{
 Check if a reference is a note

}

@defproc[(git_reference_is_remote
          [ref reference?])
         boolean?]{
 Check if a reference is a remote tracking branch

}

@defproc[(git_reference_is_tag
          [ref reference?])
         boolean?]{
 Check if a reference is a tag

}

@defproc[(git_reference_is_valid_name
          [refname string?])
         boolean?]{
 Ensure the reference name is well-formed.

 Valid reference names must follow one of two patterns:

 Top-level names must contain only capital letters and underscores, and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD"). 2. Names prefixed with "refs/" can be almost anything. You must avoid the characters '~', '^', ':', '\', '?', '[', and '*', and the sequences ".." and @"@{" which have special meaning to revparse.
}

@defproc[(git_reference_iterator_free
          [iter reference_iterator?])
         void?]{
 Free the iterator and its associated resources

}

@defproc[(git_reference_iterator_glob_new
          [repo repository?]
          [glob string?])
         reference_iterator?]{
 Create an iterator for the repo's references that match the specified glob

}

@defproc[(git_reference_iterator_new
          [repo repository?])
         reference_iterator?]{
 Create an iterator for the repo's references

}

@defproc[(git_reference_list
          [array strarray?]
          [repo repository?])
         integer?]{
 Fill a list with all the references that can be found in a repository.

 The string array will be filled with the names of all references; these values are owned by the user and should be free'd manually when no longer needed, using git_strarray_free().

}

@defproc[(git_reference_lookup
          [repo repository?]
          [name string?])
         reference?]{
 Lookup a reference by name in a repository.

 The returned reference must be freed by the user.

 The name will be checked for validity. See git_reference_symbolic_create() for rules about valid names.

}

@defproc[(git_reference_name
          [ref reference?])
         integer?]{
 Get the full name of a reference.

 See git_reference_symbolic_create() for rules about valid names.

}

@defproc[(git_reference_name_to_id
          [out oid?]
          [repo repository?]
          [name string?])
         integer?]{
 Lookup a reference by name and resolve immediately to OID.

 This function provides a quick way to resolve a reference name straight through to the object id that it refers to. This avoids having to allocate or free any git_reference objects for simple situations.

 The name will be checked for validity. See git_reference_symbolic_create() for rules about valid names.

}

@defproc[(git_reference_next
          [iter reference_iterator?])
         reference?]{
 Get the next reference

}

@defproc[(git_reference_next_name
          [iter reference_iterator?])
         string?]{
 Get the next reference's name

 This function is provided for convenience in case only the names are interesting as it avoids the allocation of the git_reference object which git_reference_next() needs.

}

@defproc[(git_reference_normalize_name
          [buffer_out string?]
          [buffer_size integer?]
          [name string?]
          [flags integer?])
         integer?]{
 Normalize reference name and check validity.

 This will normalize the reference name by removing any leading slash '/' characters and collapsing runs of adjacent slashes between name components into a single slash.

 Once normalized, if the reference name is valid, it will be returned in the user allocated buffer.

 See git_reference_symbolic_create() for rules about valid names.

}

@defproc[(git_reference_owner
          [ref reference?])
         repository?]{
 Get the repository where a reference resides.

}

@defproc[(git_reference_peel
          [ref reference?]
          [type _git_otype])
         object?]{
 Recursively peel reference until object of the specified type is found.

 The retrieved peeled object is owned by the repository and should be closed with the git_object_free method.

 If you pass GIT_OBJ_ANY as the target type, then the object will be peeled until a non-tag object is met.

}

@defproc[(git_reference_remove
          [repo repository?]
          [name string?])
         integer?]{
 Delete an existing reference by name

 This method removes the named reference from the repository without looking at its old value.

}

@defproc[(git_reference_rename
          [ref reference?]
          [new_name string?]
          [force boolean?]
          [log_message string?])
         reference?]{
 Rename an existing reference.

 This method works for both direct and symbolic references.

 The new name will be checked for validity. See git_reference_symbolic_create() for rules about valid names.

 If the force flag is not enabled, and there's already a reference with the given name, the renaming will fail.

 IMPORTANT: The user needs to write a proper reflog entry if the reflog is enabled for the repository. We only rename the reflog if it exists.

}

@defproc[(git_reference_resolve
          [ref reference?])
         reference?]{
 Resolve a symbolic reference to a direct reference.

 This method iteratively peels a symbolic reference until it resolves to a direct reference to an OID.

 The peeled reference is returned in the resolved_ref argument, and must be freed manually once it's no longer needed.

 If a direct reference is passed as an argument, a copy of that reference is returned. This copy must be manually freed too.

}

@defproc[(git_reference_set_target
          [ref reference?]
          [id oid?]
          [log_message string?])
         reference?]{
 Conditionally create a new reference with the same name as the given reference but a different OID target. The reference must be a direct reference, otherwise this will fail.

 The new reference will be written to disk, overwriting the given reference.

}

@defproc[(git_reference_shorthand
          [ref reference?])
         string?]{
 Get the reference's short name

 This will transform the reference name into a name "human-readable" version. If no shortname is appropriate, it will return the full name.

 The memory is owned by the reference and must not be freed.

}

@defproc[(git_reference_symbolic_create
          [repo repository?]
          [name string?]
          [target string?]
          [force boolean?]
          [log_message string?])
         reference?]{
 Create a new symbolic reference.

 A symbolic reference is a reference name that refers to another reference name. If the other name moves, the symbolic name will move, too. As a simple example, the "HEAD" reference might refer to "refs/heads/master" while on the "master" branch of a repository.

 The symbolic reference will be created in the repository and written to the disk. The generated reference object must be freed by the user.

 Valid reference names must follow one of two patterns:

 Top-level names must contain only capital letters and underscores, and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD"). 2. Names prefixed with "refs/" can be almost anything. You must avoid the characters '~', '^', ':', '\', '?', '[', and '*', and the sequences ".." and @"@{" which have special meaning to revparse.
 This function will return an error if a reference already exists with the given name unless force is true, in which case it will be overwritten.

 The message for the reflog will be ignored if the reference does not belong in the standard set (HEAD, branches and remote-tracking branches) and it does not have a reflog.

}

@defproc[(git_reference_symbolic_create_matching
          [repo repository?]
          [name string?]
          [target string?]
          [force boolean?]
          [current_value string?]
          [log_message string?])
         reference?]{
 Conditionally create a new symbolic reference.

 A symbolic reference is a reference name that refers to another reference name. If the other name moves, the symbolic name will move, too. As a simple example, the "HEAD" reference might refer to "refs/heads/master" while on the "master" branch of a repository.

 The symbolic reference will be created in the repository and written to the disk. The generated reference object must be freed by the user.

 Valid reference names must follow one of two patterns:

 Top-level names must contain only capital letters and underscores, and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD"). 2. Names prefixed with "refs/" can be almost anything. You must avoid the characters '~', '^', ':', '\', '?', '[', and '*', and the sequences ".." and @"@{" which have special meaning to revparse.
 This function will return an error if a reference already exists with the given name unless force is true, in which case it will be overwritten.

 The message for the reflog will be ignored if the reference does not belong in the standard set (HEAD, branches and remote-tracking branches) and it does not have a reflog.

 It will return GIT_EMODIFIED if the reference's value at the time of updating does not match the one passed through current_value (i.e. if the ref has changed since the user read it).

}

@defproc[(git_reference_symbolic_set_target
          [ref reference?]
          [target string?]
          [log_message string?])
         reference?]{
 Create a new reference with the same name as the given reference but a different symbolic target. The reference must be a symbolic reference, otherwise this will fail.

 The new reference will be written to disk, overwriting the given reference.

 The target name will be checked for validity. See git_reference_symbolic_create() for rules about valid names.

 The message for the reflog will be ignored if the reference does not belong in the standard set (HEAD, branches and remote-tracking branches) and and it does not have a reflog.

}

@defproc[(git_reference_symbolic_target
          [ref reference?])
         string?]{
 Get full name to the reference pointed to by a symbolic reference.

 Only available if the reference is symbolic.

}

@defproc[(git_reference_target
          [ref reference?])
         oid?]{
 Get the OID pointed to by a direct reference.

 Only available if the reference is direct (i.e. an object id reference, not a symbolic one).

 To find the OID of a symbolic ref, call git_reference_resolve() and then this function (or maybe use git_reference_name_to_id() to directly resolve a reference name all the way through to an OID).

}

@defproc[(git_reference_target_peel
          [ref reference?])
         oid?]{
 Return the peeled OID target of this reference.

 This peeled OID only applies to direct references that point to a hard Tag object: it is the result of peeling such Tag.

}

@defproc[(git_reference_type
          [ref reference?])
         _git_ref_t]{
 Get the type of a reference.

 Either direct (GIT_REF_OID) or symbolic (GIT_REF_SYMBOLIC)


}
