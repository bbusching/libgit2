#lang scribble/manual

@(require (for-label racket))

@title{Tree}

@defmodule[libgit2/include/tree]


@defproc[(git_tree_create_updated
          [out oid?]
          [repo repository?]
          [baseline tree?]
          [nupdates integer?]
          [updates tree_update?])
         integer?]{
 Create a tree based on another one with the specified modifications

 Given the baseline perform the changes described in the list of updates and create a new tree.

 This function is optimized for common file/directory addition, removal and replacement in trees. It is much more efficient than reading the tree into a git_index and modifying that, but in exchange it is not as flexible.

 Deleting and adding the same entry is undefined behaviour, changing a tree to a blob or viceversa is not supported.

}

@defproc[(git_tree_dup
          [source tree?])
         tree?]{
 Create an in-memory copy of a tree. The copy must be explicitly free'd or it will leak.

}

@defproc[(git_tree_entry_byid
          [tree tree?]
          [id oid?])
         tree_entry?]{
 Lookup a tree entry by SHA value.

 This returns a git_tree_entry that is owned by the git_tree. You don't have to free it, but you must not use it after the git_tree is released.

 Warning: this must examine every entry in the tree, so it is not fast.

}

@defproc[(git_tree_entry_byindex
          [tree tree?]
          [idx integer?])
         tree_entry?]{
 Lookup a tree entry by its position in the tree

 This returns a git_tree_entry that is owned by the git_tree. You don't have to free it, but you must not use it after the git_tree is released.

}

@defproc[(git_tree_entry_byname
          [tree tree?]
          [filename string?])
         tree_entry?]{
 Lookup a tree entry by its filename

 This returns a git_tree_entry that is owned by the git_tree. You don't have to free it, but you must not use it after the git_tree is released.

}

@defproc[(git_tree_entry_bypath
          [root tree?]
          [path string?])
         tree_entry?]{
 Retrieve a tree entry contained in a tree or in any of its subtrees, given its relative path.

 Unlike the other lookup functions, the returned tree entry is owned by the user and must be freed explicitly with git_tree_entry_free().

}

@defproc[(git_tree_entry_cmp
          [e1 tree_entry?]
          [e2 tree_entry?])
         integer?]{
 Compare two tree entries

}

@defproc[(git_tree_entry_dup
          [source tree_entry?])
         tree_entry?]{
 Duplicate a tree entry

 Create a copy of a tree entry. The returned copy is owned by the user, and must be freed explicitly with git_tree_entry_free().

}

@defproc[(git_tree_entry_filemode
          [entry tree_entry?])
         _git_filemode_t]{
 Get the UNIX file attributes of a tree entry

}

@defproc[(git_tree_entry_filemode_raw
          [entry tree_entry?])
         _git_filemode_t]{
 Get the raw UNIX file attributes of a tree entry

 This function does not perform any normalization and is only useful if you need to be able to recreate the original tree object.

}

@defproc[(git_tree_entry_free
          [entry tree_entry?])
         void?]{
 Free a user-owned tree entry

 IMPORTANT: This function is only needed for tree entries owned by the user, such as the ones returned by git_tree_entry_dup() or git_tree_entry_bypath().

}

@defproc[(git_tree_entry_id
          [entry tree_entry?])
         oid?]{
 Get the id of the object pointed by the entry

}

@defproc[(git_tree_entry_name
          [entry tree_entry?])
         string?]{
 Get the filename of a tree entry

}

@defproc[(git_tree_entry_to_object
          [repo repository?]
          [entry tree_entry?])
         object?]{
 Convert a tree entry to the git_object it points to.

 You must call git_object_free() on the object when you are done with it.

}

@defproc[(git_tree_entry_type
          [entry tree_entry?])
         _git_otype]{
 Get the type of the object pointed by the entry

}

@defproc[(git_tree_entrycount
          [tree tree?])
         integer?]{
 Get the number of entries listed in a tree

}

@defproc[(git_tree_free
          [tree tree?])
         void?]{
 Close an open tree

 You can no longer use the git_tree pointer after this call.

 IMPORTANT: You MUST call this method when you stop using a tree to release memory. Failure to do so will cause a memory leak.

}

@defproc[(git_tree_id
          [tree tree?])
         oid?]{
 Get the id of a tree.

}

@defproc[(git_tree_lookup
          [repo repository?]
          [id oid?])
         tree?]{
 Lookup a tree object from the repository.

}

@defproc[(git_tree_lookup_prefix
          [repo repository?]
          [id oid?]
          [len integer?])
         tree?]{
 Lookup a tree object from the repository, given a prefix of its identifier (short id).

}

@defproc[(git_tree_owner
          [tree tree?])
         repository?]{
 Get the repository that contains the tree.

}

@defproc[(git_tree_walk
          [tree tree?]
          [mode _git_treewalk_mode]
          [callback _git_treewalk_cb]
          [payload bytes?])
         integer?]{
 Traverse the entries in a tree and its subtrees in post or pre order.

 The entries will be traversed in the specified order, children subtrees will be automatically loaded as required, and the callback will be called once per entry with the current (relative) root for the entry and the entry data itself.

 If the callback returns a positive value, the passed entry will be skipped on the traversal (in pre mode). A negative value stops the walk.
}
