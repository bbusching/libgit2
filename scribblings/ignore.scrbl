#lang scribble/manual

@(require (for-label racket))

@title{Ignore}

@defmodule[libgit2/include/ignore]


@defproc[(git_ignore_add_rule
          [repo repository?]
          [rules string?])
         integer?]{
 Add ignore rules for a repository.

 Excludesfile rules (i.e. .gitignore rules) are generally read from .gitignore files in the repository tree or from a shared system file only if a "core.excludesfile" config value is set. The library also keeps a set of per-repository internal ignores that can be configured in-memory and will not persist. This function allows you to add to that internal rules list.

 Example usage:

 error = git_ignore_add_rule(myrepo, "*.c/ with space");
 This would add three rules to the ignores.

}

@defproc[(git_ignore_clear_internal_rules
          [repo repository?])
         integer?]{
 Clear ignore rules that were explicitly added.

 Resets to the default internal ignore rules. This will not turn off rules in .gitignore files that actually exist in the filesystem.

 The default internal ignores ignore ".", ".." and ".git" entries.

}

@defproc[(git_ignore_path_is_ignored
          [ignored ean??]
          [repo repository?]
          [path string?])
         boolean?]{
 Test if the ignore rules apply to a given path.

 This function checks the ignore rules to see if they would apply to the given file. This indicates if the file would be ignored regardless of whether the file is already in the index or committed to the repository.

 One way to think of this is if you were to do "git add ." on the directory containing the file, would it be added or not?
}
