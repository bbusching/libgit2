#lang scribble/manual

@(require (for-label racket))

@title{Index}

@defmodule[libgit2/include/index]


@defproc[(git_index_add
          [index index?]
          [source_entry index_entry?])
         integer?]{
 Add or update an index entry from an in-memory struct

 If a previous index entry exists that has the same path and stage as the given 'source_entry', it will be replaced. Otherwise, the 'source_entry' will be added.

 A full copy (including the 'path' string) of the given 'source_entry' will be inserted on the index.

}

@defproc[(git_index_add_all
          [index index?]
          [pathspec strarray?]
          [flags _git_index_add_option_t]
          [callback git_index_matched_path_cb]
          [payload bytes?])
         integer?]{
 Add or update index entries matching files in the working directory.

 This method will fail in bare index instances.

 The pathspec is a list of file names or shell glob patterns that will matched against files in the repository's working directory. Each file that matches will be added to the index (either updating an existing entry or adding a new entry). You can disable glob expansion and force exact matching with the GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH flag.

 Files that are ignored will be skipped (unlike git_index_add_bypath). If a file is already tracked in the index, then it will be updated even if it is ignored. Pass the GIT_INDEX_ADD_FORCE flag to skip the checking of ignore rules.

 To emulate git add -A and generate an error if the pathspec contains the exact path of an ignored file (when not using FORCE), add the GIT_INDEX_ADD_CHECK_PATHSPEC flag. This checks that each entry in the pathspec that is an exact match to a filename on disk is either not ignored or already in the index. If this check fails, the function will return GIT_EINVALIDSPEC.

 To emulate git add -A with the "dry-run" option, just use a callback function that always returns a positive value. See below for details.

 If any files are currently the result of a merge conflict, those files will no longer be marked as conflicting. The data about the conflicts will be moved to the "resolve undo" (REUC) section.

 If you provide a callback function, it will be invoked on each matching item in the working directory immediately before it is added to / updated in the index. Returning zero will add the item to the index, greater than zero will skip the item, and less than zero will abort the scan and return that value to the caller.

}

@defproc[(git_index_add_bypath
          [index index?]
          [path string?])
         integer?]{
 Add or update an index entry from a file on disk

 The file path must be relative to the repository's working folder and must be readable.

 This method will fail in bare index instances.

 This forces the file to be added to the index, not looking at gitignore rules. Those rules can be evaluated through the git_status APIs (in status.h) before calling this.

 If this file currently is the result of a merge conflict, this file will no longer be marked as conflicting. The data about the conflict will be moved to the "resolve undo" (REUC) section.

}

@defproc[(git_index_add_frombuffer
          [index index?]
          [entry index_entry?]
          [buffer bytes?]
          [len integer?])
         integer?]{
 Add or update an index entry from a buffer in memory

 This method will create a blob in the repository that owns the index and then add the index entry to the index. The path of the entry represents the position of the blob relative to the repository's root folder.

 If a previous index entry exists that has the same path as the given 'entry', it will be replaced. Otherwise, the 'entry' will be added. The id and the file_size of the 'entry' are updated with the real value of the blob.

 This forces the file to be added to the index, not looking at gitignore rules. Those rules can be evaluated through the git_status APIs (in status.h) before calling this.

 If this file currently is the result of a merge conflict, this file will no longer be marked as conflicting. The data about the conflict will be moved to the "resolve undo" (REUC) section.

}

@defproc[(git_index_caps
          [index index?])
         _git_indexcap_t]{
 Read index capabilities flags.

}

@defproc[(git_index_checksum
          [index index?])
         oid?]{
 Get the checksum of the index

 This checksum is the SHA-1 hash over the index file (except the last 20 bytes which are the checksum itself). In cases where the index does not exist on-disk, it will be zeroed out.

}

@defproc[(git_index_clear
          [index index?])
         integer?]{
 Clear the contents (all the entries) of an index object.

 This clears the index object in memory; changes must be explicitly written to disk for them to take effect persistently.

}

@defproc[(git_index_conflict_add
          [index index?]
          [ancestor_entry index_entry?]
          [our_entry index_entry?]
          [their_entry index_entry?])
         integer?]{
 Add or update index entries to represent a conflict. Any staged entries that exist at the given paths will be removed.

 The entries are the entries from the tree included in the merge. Any entry may be null to indicate that that file was not present in the trees during the merge. For example, ancestor_entry may be NULL to indicate that a file was added in both branches and must be resolved.

}

@defproc[(git_index_conflict_cleanup
          [index index?])
         integer?]{
 Remove all conflicts in the index (entries with a stage greater than 0).

}

@defproc[(git_index_conflict_get
          [index index?]
          [path string?])
         integer?]{
 Get the index entries that represent a conflict of a single file.

 The entries are not modifiable and should not be freed. Because the git_index_entry struct is a publicly defined struct, you should be able to make your own permanent copy of the data if necessary.

 Returns @racket[(values (ancestor_out : index_entry?)
                         (our_out : index_entry?)
                         (their_out : index_entry?))]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}

@defproc[(git_index_conflict_iterator_free
          [iterator index_conflict_iterator?])
         void?]{
 Frees a git_index_conflict_iterator.

}

@defproc[(git_index_conflict_iterator_new
          [index index?])
         index_conflict_iterator?]{
 Create an iterator for the conflicts in the index.

 The index must not be modified while iterating; the results are undefined.

}

@defproc[(git_index_conflict_next
          [iterator index_conflict_iterator?])
         integer?]{
 Returns the current conflict (ancestor, ours and theirs entry) and advance the iterator internally to the next value.

 Returns @racket[(values (ancestor_out : index_entry?)
                         (our_out : index_entry?)
                         (their_out : index_entry?))]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}

@defproc[(git_index_conflict_remove
          [index index?]
          [path string?])
         integer?]{
 Removes the index entries that represent a conflict of a single file.

}

@defproc[(git_index_entry_is_conflict
          [entry index_entry?])
         boolean?]{
 Return whether the given index entry is a conflict (has a high stage entry). This is simply shorthand for git_index_entry_stage > 0.

}

@defproc[(git_index_entry_stage
          [entry index_entry?])
         integer?]{
 Return the stage number from a git index entry

 This entry is calculated from the entry's flag attribute like this:

 (entry->flags & GIT_IDXENTRY_STAGEMASK) >> GIT_IDXENTRY_STAGESHIFT
}

@defproc[(git_index_entrycount
          [index index?])
         integer?]{
 Get the count of entries currently in the index

}

@defproc[(git_index_find
          [index index?]
          [path string?])
         integer?]{
 Find the first position of any entries which point to given path in the Git index.

}

@defproc[(git_index_find_prefix
          [index index?]
          [prefix string?])
         integer?]{
 Find the first position of any entries matching a prefix. To find the first position of a path inside a given folder, suffix the prefix with a '/'.

}

@defproc[(git_index_free
          [index index?])
         void?]{
 Free an existing index object.

}

@defproc[(git_index_get_byindex
          [index index?]
          [n integer?])
         index_entry?]{
 Get a pointer to one of the entries in the index

 The entry is not modifiable and should not be freed. Because the git_index_entry struct is a publicly defined struct, you should be able to make your own permanent copy of the data if necessary.

}

@defproc[(git_index_get_bypath
          [index index?]
          [path string?]
          [stage integer?])
         index_entry?]{
 Get a pointer to one of the entries in the index

 The entry is not modifiable and should not be freed. Because the git_index_entry struct is a publicly defined struct, you should be able to make your own permanent copy of the data if necessary.

}

@defproc[(git_index_has_conflicts
          [index index?])
         boolean?]{
 Determine if the index contains entries representing file conflicts.

}

@defproc[(git_index_new)
         index?]{
 Create an in-memory index object.

 This index object cannot be read/written to the filesystem, but may be used to perform in-memory index operations.

 The index must be freed once it's no longer in use.

}

@defproc[(git_index_open
          [index_path string?])
         index?]{
 Create a new bare Git index object as a memory representation of the Git index file in 'index_path', without a repository to back it.

 Since there is no ODB or working directory behind this index, any Index methods which rely on these (e.g. index_add_bypath) will fail with the GIT_ERROR error code.

 If you need to access the index of an actual repository, use the git_repository_index wrapper.

 The index must be freed once it's no longer in use.

}

@defproc[(git_index_owner
          [index index?])
         repository?]{
 Get the repository this index relates to

}

@defproc[(git_index_path
          [index index?])
         string?]{
 Get the full path to the index file on disk.

}

@defproc[(git_index_read
          [index index?]
          [force boolean?])
         integer?]{
 Update the contents of an existing index object in memory by reading from the hard disk.

 If force is true, this performs a "hard" read that discards in-memory changes and always reloads the on-disk index data. If there is no on-disk version, the index will be cleared.

 If force is false, this does a "soft" read that reloads the index data from disk only if it has changed since the last time it was loaded. Purely in-memory index data will be untouched. Be aware: if there are changes on disk, unwritten in-memory changes are discarded.

}

@defproc[(git_index_read_tree
          [index index?]
          [tree tree?])
         integer?]{
 Read a tree into the index file with stats

 The current index contents will be replaced by the specified tree.

}

@defproc[(git_index_remove
          [index index?]
          [path string?]
          [stage integer?])
         integer?]{
 Remove an entry from the index

}

@defproc[(git_index_remove_all
          [index index?]
          [pathspec strarray?]
          [callback git_index_matched_path_cb]
          [payload bytes?])
         integer?]{
 Remove all matching index entries.

 If you provide a callback function, it will be invoked on each matching item in the index immediately before it is removed. Return 0 to remove the item, > 0 to skip the item, and < 0 to abort the scan.

}

@defproc[(git_index_remove_bypath
          [index index?]
          [path string?])
         integer?]{
 Remove an index entry corresponding to a file on disk

 The file path must be relative to the repository's working folder. It may exist.

 If this file currently is the result of a merge conflict, this file will no longer be marked as conflicting. The data about the conflict will be moved to the "resolve undo" (REUC) section.

}

@defproc[(git_index_remove_directory
          [index index?]
          [dir string?]
          [stage integer?])
         integer?]{
 Remove all entries from the index under a given directory

}

@defproc[(git_index_set_caps
          [index index?]
          [caps _git_indexcap_t])
         integer?]{
 Set index capabilities flags.

 If you pass GIT_INDEXCAP_FROM_OWNER for the caps, then the capabilities will be read from the config of the owner object, looking at core.ignorecase, core.filemode, core.symlinks.

}

@defproc[(git_index_set_version
          [index index?]
          [version int?])
         integer?]{
 Set index on-disk version.

 Valid values are 2, 3, or 4. If 2 is given, git_index_write may write an index with version 3 instead, if necessary to accurately represent the index.

}

@defproc[(git_index_update_all
          [index index?]
          [pathspec strarray?]
          [callback git_index_matched_path_cb]
          [payload bytes?])
         integer?]{
 Update all index entries to match the working directory

 This method will fail in bare index instances.

 This scans the existing index entries and synchronizes them with the working directory, deleting them if the corresponding working directory file no longer exists otherwise updating the information (including adding the latest version of file to the ODB if needed).

 If you provide a callback function, it will be invoked on each matching item in the index immediately before it is updated (either refreshed or removed depending on working directory state). Return 0 to proceed with updating the item, > 0 to skip the item, and < 0 to abort the scan.

}

@defproc[(git_index_version
          [index index?])
         integer?]{
 Get index on-disk version.

 Valid return values are 2, 3, or 4. If 3 is returned, an index with version 2 may be written instead, if the extension data in version 3 is not necessary.

}

@defproc[(git_index_write
          [index index?])
         integer?]{
 Write an existing index object from memory back to disk using an atomic file lock.

}

@defproc[(git_index_write_tree
          [out oid?]
          [index index?])
         integer?]{
 Write the index as a tree

 This method will scan the index and write a representation of its current state back to disk; it recursively creates tree objects for each of the subtrees stored in the index, but only returns the OID of the root tree. This is the OID that can be used e.g. to create a commit.

 The index instance cannot be bare, and needs to be associated to an existing repository.

 The index must not contain any file in conflict.

}

@defproc[(git_index_write_tree_to
          [out oid?]
          [index index?]
          [repo repository?])
         integer?]{
 Write the index as a tree to the given repository

 This method will do the same as git_index_write_tree, but letting the user choose the repository where the tree will be written.

 The index must not contain any file in conflict.
}
