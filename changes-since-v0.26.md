# Changes Since 0.26

## Breaking API Changes

### 0.27

* Signatures now distinguish between +0000 and -0000 UTC offsets.

* The certificate check callback in the WinHTTP transport will now receive the
  `message_cb_payload` instead of the `cred_acquire_payload`.

* We are now reading symlinked directories under .git/refs.

* We now refuse creating branches named "HEAD".

* We now refuse reading and writing all-zero object IDs into the
  object database.

* We now read the effective user's configuration file instead of the real user's
  configuration in case libgit2 runs as part of a setuid binary.

* The `git_odb_open_rstream` function and its `readstream` callback in the
  `git_odb_backend` interface have changed their signatures to allow providing
  the object's size and type to the caller.

### v0.28

* The default checkout strategy changed from `DRY_RUN` to `SAFE` (#4531).

* Adding a symlink as .gitmodules into the index from the workdir or checking
  out such files is not allowed as this can make a Git implementation write
  outside of the repository and bypass the fsck checks for CVE-2018-11235.

## API Removals

### v0.28

* The `git_buf_free` API is deprecated; it has been renamed to
  `git_buf_dispose` for consistency.  The `git_buf_free` API will be
  retained for backward compatibility for the foreseeable future.

* The `git_otype` enumeration and its members are deprecated and have
  been renamed for consistency.  The `GIT_OBJ_` enumeration values are
  now prefixed with `GIT_OBJECT_`.  The old enumerations and macros
  will be retained for backward compatibility for the foreseeable future.

* Several index-related APIs have been renamed for consistency.  The
  `GIT_IDXENTRY_` enumeration values and macros have been renamed to
  be prefixed with `GIT_INDEX_ENTRY_`.  The `GIT_INDEXCAP` enumeration
  values are now prefixed with `GIT_INDEX_CAPABILITY_`.  The old
  enumerations and macros will be retained for backward compatibility
  for the foreseeable future.

* The error functions and enumeration values have been renamed for
  consistency.  The `giterr_` functions and values prefix have been
  renamed to be prefixed with `git_error_`; similarly, the `GITERR_`
  constants have been renamed to be prefixed with `GIT_ERROR_`.
  The old enumerations and macros will be retained for backward
  compatibility for the foreseeable future.




## API Additions

### v0.27

* The `git_merge_file_options` structure now contains a new setting,
  `marker_size`.  This allows users to set the size of markers that
  delineate the sides of merged files in the output conflict file.
  By default this is 7 (`GIT_MERGE_CONFLICT_MARKER_SIZE`), which
  produces output markers like `<<<<<<<` and `>>>>>>>`.

* `git_remote_create_detached()` creates a remote that is not associated
  to any repository (and does not apply configuration like 'insteadof' rules).
  This is mostly useful for e.g. emulating `git ls-remote` behavior.

* `git_diff_patchid()` lets you generate patch IDs for diffs.

* `git_status_options` now has an additional field `baseline` to allow creating
  status lists against different trees.

* New family of functions to allow creating notes for a specific notes commit
  instead of for a notes reference.

* New family of functions to allow parsing message trailers. This API is still
  experimental and may change in future releases.

### v0.28

* The index may now be iterated atomically using `git_index_iterator`.

* Remote objects can now be created with extended options using the
  `git_remote_create_with_opts` API.

* Diff objects can now be applied as changes to the working directory,
  index or both, emulating the `git apply` command.  Additionally,
  `git_apply_to_tree` can apply those changes to a tree object as a
  fully in-memory operation.

* You can now swap out memory allocators via the
  `GIT_OPT_SET_ALLOCATOR` option with `git_libgit2_opts()`.

* You can now ensure that functions do not discard unwritten changes to the
  index via the `GIT_OPT_ENABLE_UNSAVED_INDEX_SAFETY` option to
  `git_libgit2_opts()`.  This will cause functions that implicitly re-read
  the index (eg, `git_checkout`) to fail if you have staged changes to the
  index but you have not written the index to disk.  (Unless the checkout
  has the FORCE flag specified.)

  At present, this defaults to off, but we intend to enable this more
  broadly in the future, as a warning or error.  We encourage you to
  examine your code to ensure that you are not relying on the current
  behavior that implicitly removes staged changes.

* Reference specifications can be parsed from an arbitrary string with
  the `git_refspec_parse` API.

* You can now get the name and path of worktrees using the
  `git_worktree_name` and `git_worktree_path` APIs, respectively.

* The `ref` field has been added to `git_worktree_add_options` to enable
  the creation of a worktree from a pre-existing branch.

* It's now possible to analyze merge relationships between any two
  references, not just against `HEAD`, using `git_merge_analysis_for_ref`.

## Changes or Improvements

### v0.27

* Improved `p_unlink` in `posix_w32.c` to try and make a file writable
  before sleeping in the retry loop to prevent unnecessary calls to sleep.

* The CMake build infrastructure has been improved to speed up building time.

* A new CMake option "-DUSE_HTTPS=<backend>" makes it possible to explicitly
  choose an HTTP backend.

* A new CMake option "-DSHA1_BACKEND=<backend>" makes it possible to explicitly
  choose an SHA1 backend. The collision-detecting backend is now the default.

* A new CMake option "-DUSE_BUNDLED_ZLIB" makes it possible to explicitly use
  the bundled zlib library.

* A new CMake option "-DENABLE_REPRODUCIBLE_BUILDS" makes it possible to
  generate a reproducible static archive. This requires support from your
  toolchain.

* The minimum required CMake version has been bumped to 2.8.11.

* Writing to a configuration file now preserves the case of the key given by the
  caller for the case-insensitive portions of the key (existing sections are
  used even if they don't match).

* We now support conditional includes in configuration files.

* Fix for handling re-reading of configuration files with includes.

* Fix for reading patches which contain exact renames only.

* Fix for reading patches with whitespace in the compared files' paths.

* We will now fill `FETCH_HEAD` from all passed refspecs instead of overwriting
  with the last one.

* There is a new diff option, `GIT_DIFF_INDENT_HEURISTIC` which activates a
  heuristic which takes into account whitespace and indentation in order to
  produce better diffs when dealing with ambiguous diff hunks.

* Fix for pattern-based ignore rules where files ignored by a rule cannot be
  un-ignored by another rule.

* Sockets opened by libgit2 are now being closed on exec(3) if the platform
  supports it.

* Fix for peeling annotated tags from packed-refs files.

* Fix reading huge loose objects from the object database.

* Fix files not being treated as modified when only the file mode has changed.

* We now explicitly reject adding submodules to the index via
  `git_index_add_frombuffer`.

* Fix handling of `GIT_DIFF_FIND_RENAMES_FROM_REWRITES` raising `SIGABRT` when
  one file has been deleted and another file has been rewritten.

* Fix for WinHTTP not properly handling NTLM and Negotiate challenges.

* When using SSH-based transports, we now repeatedly ask for the passphrase to
  decrypt the private key in case a wrong passphrase is being provided.

* When generating conflict markers, they will now use the same line endings as
  the rest of the file.

### v0.28

* The library is now always built with cdecl calling conventions on
  Windows; the ability to build a stdcall library has been removed.

* Reference log creation now honors `core.logallrefupdates=always`.

* Fix some issues with the error-reporting in the OpenSSL backend.

* HTTP proxy support is now builtin; libcurl is no longer used to support
  proxies and is removed as a dependency.

* Certificate and credential callbacks can now return `GIT_PASSTHROUGH`
  to decline to act; libgit2 will behave as if there was no callback set
  in the first place.

* The line-ending filtering logic - when checking out files - has been
  updated to match newer git (>= git 2.9) for proper interoperability.

* Symbolic links are now supported on Windows when `core.symlinks` is set
  to `true`.

* Submodules with names which attempt to perform path traversal now have their
  configuration ignored. Such names were blindly appended to the
  `$GIT_DIR/modules` and a malicious name could lead to an attacker writing to
  an arbitrary location. This matches git's handling of CVE-2018-11235.

* Object validation is now performed during tree creation in the
  `git_index_write_tree_to` API.

* Configuration variable may now be specified on the same line as a section
  header; previously this was erroneously a parser error.

* When an HTTP server supports both NTLM and Negotiate authentication
  mechanisms, we would previously fail to authenticate with any mechanism.

* The `GIT_OPT_SET_PACK_MAX_OBJECTS` option can now set the maximum
  number of objects allowed in a packfile being downloaded; this can help
  limit the maximum memory used when fetching from an untrusted remote.

* Line numbers in diffs loaded from patch files were not being populated;
  they are now included in the results.

* The repository's index is reloaded from disk at the beginning of
  `git_merge` operations to ensure that it is up-to-date.

* Mailmap handling APIs have been introduced, and the new commit APIs
  `git_commit_committer_with_mailmap` and `git_commit_author_with_mailmap`
  will use the mailmap to resolve the committer and author information.
  In addition, blame will use the mailmap given when the
  `GIT_BLAME_USE_MAILMAP` option.

* Ignore handling for files in ignored folders would be ignored.

* Worktrees can now be backed by bare repositories.

* Trailing spaces are supported in `.gitignore` files, these spaces were
  previously (and erroneously) treated as part of the pattern.

* The library can now be built with mbedTLS support for HTTPS.

* The diff status character 'T' will now be presented by the
  `git_diff_status_char` API for diff entries that change type.

* Revision walks previously would sometimes include commits that should
  have been ignored; this is corrected.

* Revision walks are now more efficient when the output is unsorted;
  we now avoid walking all the way to the beginning of history unnecessarily.

* Error-handling around index extension loading has been fixed. We were
  previously always misreporting a truncated index (#4858).

