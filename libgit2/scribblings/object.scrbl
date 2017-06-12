#lang scribble/manual

@(require (for-label racket))

@title{Object}

@defmodule[libgit2/include/object]


@defproc[(git_object__size
          [type _git_otype])
         integer?]{
Get the size in bytes for the structure which acts as an in-memory representation of any given object type.

For all the core types, this would the equivalent of calling sizeof(git_commit) if the core types were not opaque on the external API.

}

@defproc[(git_object_dup
          [source object?])
         object?]{
 Create an in-memory copy of a Git object. The copy must be explicitly free'd or it will leak.

}

@defproc[(git_object_free
          [object object?])
         void?]{
 Close an open object

 This method instructs the library to close an existing object; note that git_objects are owned and cached by the repository so the object may or may not be freed after this library call, depending on how aggressive is the caching mechanism used by the repository.

 IMPORTANT: It is necessary to call this method when you stop using an object. Failure to do so will cause a memory leak.

}

@defproc[(git_object_id
          [obj object?])
         integer?]{
 Get the id (SHA1) of a repository object

}

@defproc[(git_object_lookup
          [repo repository?]
          [id oid?]
          [type _git_otype])
         object?]{
 Lookup a reference to one of the objects in a repository.

 The generated reference is owned by the repository and should be closed with the git_object_free method instead of free'd manually.

 The 'type' parameter must match the type of the object in the odb; the method will fail otherwise. The special value 'GIT_OBJ_ANY' may be passed to let the method guess the object's type.

}

@defproc[(git_object_lookup_bypath
          [treeish object?]
          [path string?]
          [type _git_otype])
         object?]{
 Lookup an object that represents a tree entry.

}

@defproc[(git_object_lookup_prefix
          [repo repository?]
          [id oid?]
          [len integer?]
          [type _git_otype])
         object?]{
 Lookup a reference to one of the objects in a repository, given a prefix of its identifier (short id).

 The object obtained will be so that its identifier matches the first 'len' hexadecimal characters (packets of 4 bits) of the given 'id'. 'len' must be at least GIT_OID_MINPREFIXLEN, and long enough to identify a unique object matching the prefix; otherwise the method will fail.

 The generated reference is owned by the repository and should be closed with the git_object_free method instead of free'd manually.

 The 'type' parameter must match the type of the object in the odb; the method will fail otherwise. The special value 'GIT_OBJ_ANY' may be passed to let the method guess the object's type.

}

@defproc[(git_object_owner
          [obj object?])
         repository?]{
 Get the repository that owns this object

 Freeing or calling git_repository_close on the returned pointer will invalidate the actual object.

 Any other operation may be run on the repository without affecting the object.

}

@defproc[(git_object_peel
          [object object?]
          [target_type _git_otype])
         object?]{
 Recursively peel an object until an object of the specified type is met.

 If the query cannot be satisfied due to the object model, GIT_EINVALIDSPEC will be returned (e.g. trying to peel a blob to a tree).

 If you pass GIT_OBJ_ANY as the target type, then the object will be peeled until the type changes. A tag will be peeled until the referenced object is no longer a tag, and a commit will be peeled to a tree. Any other object type will return GIT_EINVALIDSPEC.

 If peeling a tag we discover an object which cannot be peeled to the target type due to the object model, GIT_EPEEL will be returned.

 You must free the returned object.

}

@defproc[(git_object_short_id
          [out buf?]
          [obj object?])
         integer?]{
 Get a short abbreviated OID string for the object

 This starts at the "core.abbrev" length (default 7 characters) and iteratively extends to a longer string if that length is ambiguous. The result will be unambiguous (at least until new objects are added to the repository).

}

@defproc[(git_object_string2type
          [str string?])
         _git_otype]{
 Convert a string object type representation to it's git_otype.

}

@defproc[(git_object_type
          [obj object?])
         _git_otype?]{
 Get the object type of an object

 }
@defproc[(git_object_type2string
          [type _git_otype])
         string?]{
 Convert an object type to its string representation.

 The result is a pointer to a string in static memory and should not be free()'ed.

}

@defproc[(git_object_typeisloose
          [type git_otype])
         boolean?]{
 Determine if the given git_otype is a valid loose object type.
}
