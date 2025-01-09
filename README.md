# unicode-xid

Determine if a unicode codepoint is a valid identifier for a lexer according to
[Unicode Standard Annex #31](http://www.unicode.org/reports/tr31/)

# adding dependency

Run the following to resolve the package in `build.zig.zon`

```bash
zig fetch --save=unicode-xid git+https://github.com/nickelca/unicode-xid#master
```

And add the following to your `build.zig`

```zig
const unicode_xid = b.dependency("unicode-xid");
exe.root_module.addImport("xid", unicode_xid.module("unicode-xid"));
```

# example program (valid identifier checker)

```zig
pub fn main() !void {
    var arena_state: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const stdout = std.io.getStdOut().writer();

    var args = try std.process.argsWithAllocator(arena);
    defer args.deinit();

    _ = args.skip();
    const input = args.next() orelse return error.TooFewArguments;
    if (Is_Valid_Identifier(input)) {
        try stdout.writeAll("Valid identifier.\n");
    } else {
        try stdout.writeAll("Invalid identifier.\n");
    }
}

fn Is_Valid_Identifier(ident: []const u8) bool {
    const codepoints: std.unicode.Utf8View = try .init(ident);
    var itt = codepoints.iterator();
    if (itt.nextCodepoint()) |c| if (!xid.Is_XID_Start(c)) {
        return false;
    };
    while (itt.nextCodepoint()) |c| if (!xid.Is_XID_Continue(c)) {
        return false;
    };
    return true;
}

const std = @import("std");
const xid = @import("xid");
```
