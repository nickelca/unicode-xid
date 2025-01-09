pub fn build(b: *std.Build) void {
    _ = b.addModule("unicode-xid", .{
        .root_source_file = b.path("xid_identifier.zig"),
    });
}

const std = @import("std");
