Protocol Buffers - Google's data interchange format
===================================================

Copyright 2008 Google Inc.

Overview
--------

Protocol Buffers (a.k.a., protobuf) are Google's language-neutral,
platform-neutral, extensible mechanism for serializing structured data. You
can learn more about it in [protobuf's documentation](https://protobuf.dev).

This README file contains protobuf installation instructions. To install
protobuf, you need to install the protocol compiler (used to compile .proto
files) and the protobuf runtime for your chosen programming language.

### Fork changes

This fork adds a `build.zig` file to compile `protoc` and its dependencies through the [zig](https://ziglang.org/) tool chain,
see [Maintain it with zig](https://kristoff.it/blog/maintain-it-with-zig/) by Loris Cro for a great overview of the Zig toolchain
used in C/C++ projects.

Protocol Compiler Installation
------------------------------

The protocol compiler is written in C++. If you are using C++, the following steps will build `protoc` and its dependencies

*NOTE:* Using zig build for protobuf has only been tested on linux so far

```
git clone --recursive git@github.com:shailpatels/protobuf.git

cd protobuf 

# run 'zig targets' to see a list of available targets
zig build -Dtarget=<YOUR_OS_TGT> 
```

For non-C++ users, the simplest way to install the protocol compiler is to
download a pre-built binary from our [GitHub release page](https://github.com/protocolbuffers/protobuf/releases).

In the downloads section of each release, you can find pre-built binaries in
zip packages: `protoc-$VERSION-$PLATFORM.zip`. It contains the protoc binary
as well as a set of standard `.proto` files distributed along with protobuf.

If you are looking for an old version that is not available in the release
page, check out the [Maven repository](https://repo1.maven.org/maven2/com/google/protobuf/protoc/).

These pre-built binaries are only provided for released versions. If you want
to use the github main version at HEAD, or you need to modify protobuf code,
or you are using C++, it's recommended to build your own protoc binary from
source.


Protobuf Runtime Installation
-----------------------------

Protobuf supports several different programming languages. For each programming
language, you can find instructions in the corresponding source directory about
how to install protobuf runtime for that specific language:

| Language                             | Source                                                      |
|--------------------------------------|-------------------------------------------------------------|
| C++ (include C++ runtime and protoc) | [src](src)                                                  |
| Java                                 | [java](java)                                                |
| Python                               | [python](python)                                            |
| Objective-C                          | [objectivec](objectivec)                                    |
| C#                                   | [csharp](csharp)                                            |
| Ruby                                 | [ruby](ruby)                                                |
| Go                                   | [protocolbuffers/protobuf-go](https://github.com/protocolbuffers/protobuf-go)|
| PHP                                  | [php](php)                                                  |
| Dart                                 | [dart-lang/protobuf](https://github.com/dart-lang/protobuf) |
| JavaScript                           | [protocolbuffers/protobuf-javascript](https://github.com/protocolbuffers/protobuf-javascript)|

Quick Start
-----------

The best way to learn how to use protobuf is to follow the [tutorials in our
developer guide](https://protobuf.dev/getting-started).

If you want to learn from code examples, take a look at the examples in the
[examples](examples) directory.

Documentation
-------------

The complete documentation is available at the [Protocol Buffers doc site](https://protobuf.dev).

Support Policy
--------------

Read about our [version support policy](https://protobuf.dev/version-support/)
to stay current on support timeframes for the language libraries.

Developer Community
-------------------

To be alerted to upcoming changes in Protocol Buffers and connect with protobuf developers and users,
[join the Google Group](https://groups.google.com/g/protobuf).
