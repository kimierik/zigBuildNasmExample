const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // make sure user has nasm installed
    _ = b.findProgram(&.{"nasm"}, &.{ "/bin/", "/usr/bin/", "/usr/local/bin/" }) catch {
        std.debug.print("this example depends on nasm\n", .{});
        std.debug.print("please make sure nasm is available in $path\n", .{});
        std.process.exit(1);
    };

    const exe = b.addExecutable(.{
        .name = "buildTesting",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const nasm_cmd = b.addSystemCommand(&.{"nasm"});
    nasm_cmd.addArg("-f elf64"); // propper format
    nasm_cmd.addFileArg(b.path("src/nsm.asm")); // path to file
    //
    nasm_cmd.addArg("-o");
    const output = nasm_cmd.addOutputFileArg("nsm.o"); // output file as nsm.o
    b.getInstallStep().dependOn(&nasm_cmd.step); // depend on this step

    exe.addObjectFile(output);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
