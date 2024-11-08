const std = @import("std");

extern fn NasmGreet() void;

pub fn main() !void {
    std.debug.print("hello\n", .{});
    NasmGreet();
    std.debug.print("end\n", .{});
}
