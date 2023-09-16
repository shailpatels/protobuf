const std = @import("std");
const cpp_files = @import("file_lists.zig");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // option to apply to all compilation units
    const cpp_flags_all = .{"-std=c++17"};

    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const lib_proto = b.addStaticLibrary(.{
        .name = "protobuf",
        .target = target,
        .optimize = optimize,
    });

    const lib_utf8_validity = b.addStaticLibrary(.{
        .name = "utf8_validity",
        .target = target,
        .optimize = optimize,
    });

    const lib_abseil = b.dependency("abseil_cpp", .{
        .target = target,
        .optimize = optimize,
    });

    lib_utf8_validity.linkLibC();
    lib_utf8_validity.addCSourceFiles(&.{"third_party/utf8_range/utf8_validity.cc"}, &.{});
    lib_utf8_validity.linkLibrary(lib_abseil.artifact("abseil-cpp"));
    lib_utf8_validity.installLibraryHeaders(lib_abseil.artifact("abseil-cpp"));

    lib_proto.addIncludePath(.{ .path = "src" });
    lib_proto.addIncludePath(.{ .path = "third_party/utf8_range" });
    lib_proto.linkLibCpp();
    lib_proto.linkLibrary(lib_abseil.artifact("abseil-cpp"));
    lib_proto.linkLibrary(lib_utf8_validity);
    lib_proto.installLibraryHeaders(lib_abseil.artifact("abseil-cpp"));
    lib_proto.addCSourceFiles(&cpp_files.libprotobuf_srcs, &(.{} ++ cpp_flags_all));

    const lib_protoc = b.addStaticLibrary(.{
        .name = "protoc",
        .target = target,
        .optimize = optimize,
    });

    lib_protoc.addIncludePath(.{ .path = "src" });
    lib_protoc.addCSourceFiles(&cpp_files.libprotoc_srcs, &(.{} ++ cpp_flags_all));
    lib_protoc.linkLibCpp();
    lib_protoc.linkLibrary(lib_proto);

    const protoc = b.addExecutable(.{
        .name = "protobufcompiler", //same name with libprotoc causes conflict
        .target = target,
        .optimize = optimize,
    });

    protoc.linkLibrary(lib_proto);
    protoc.linkLibrary(lib_protoc);
    protoc.addIncludePath(.{ .path = "src" });
    protoc.addCSourceFiles(&.{
        "src/google/protobuf/compiler/main.cc",
    }, &(.{} ++ cpp_flags_all));

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib_proto);
    b.installArtifact(lib_protoc);
    b.installArtifact(protoc);
    lib_proto.installHeadersDirectoryOptions(.{
        .source_dir = .{ .path = "src/google/protobuf" },
        .install_dir = .header,
        .install_subdir = "google/protobuf",
        .exclude_extensions = &.{
            "cc",
            "proto",
            "bazel",
        },
    });

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    //const main_tests = b.addTest(.{
    //   .root_source_file = .{ .path = "src/main.zig" },
    //  .target = target,
    // .optimize = optimize,
    //    });

    //const run_main_tests = b.addRunArtifact(main_tests);

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build test`
    // This will evaluate the `test` step rather than the default, which is "install".
    //const test_step = b.step("test", "Run library tests");
    //test_step.dependOn(&run_main_tests.step);
}
