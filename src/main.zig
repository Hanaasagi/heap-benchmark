const std = @import("std");
const zbench = @import("zbench");
const root = @import("./root.zig");

const N = 10000;

const Elem = struct {
    const Self = @This();
    value: i32 = 0,
    heap: root.IntrusiveField(Self) = .{},
};
const PairHeap = root.Intrusive(Elem, void, (struct {
    fn less(ctx: void, a: *Elem, b: *Elem) bool {
        _ = ctx;
        return a.value < b.value;
    }
}).less);

var randomArrayForInsert = std.ArrayList(Elem).init(std.heap.page_allocator);
var randomArrayForDelete = std.ArrayList(Elem).init(std.heap.page_allocator);

var binary_heap_for_insert = root.MinBinaryHeap.init(std.heap.page_allocator);
var quateranry_heap_for_insert = root.MinQuaternaryHeap.init(std.heap.page_allocator);

var binary_heap_for_delete = root.MinBinaryHeap.init(std.heap.page_allocator);
var quateranry_heap_for_delete = root.MinQuaternaryHeap.init(std.heap.page_allocator);
var pair_heap = PairHeap{ .context = {} };

fn before_each() void {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = 36;
        std.posix.getrandom(std.mem.asBytes(&seed)) catch @panic("getrandom failed");
        break :blk seed;
    });
    const rand = prng.random();

    randomArrayForInsert.clearAndFree();
    randomArrayForInsert.ensureTotalCapacity(N + 1) catch @panic("oom");

    randomArrayForDelete.clearAndFree();
    randomArrayForDelete.ensureTotalCapacity(N + 1) catch @panic("oom");

    binary_heap_for_delete.deinit();
    binary_heap_for_delete = root.MinBinaryHeap.init(std.heap.page_allocator);

    quateranry_heap_for_delete.deinit();
    quateranry_heap_for_delete = root.MinQuaternaryHeap.init(std.heap.page_allocator);

    binary_heap_for_insert.deinit();
    binary_heap_for_insert = root.MinBinaryHeap.init(std.heap.page_allocator);

    quateranry_heap_for_insert.deinit();
    quateranry_heap_for_insert = root.MinQuaternaryHeap.init(std.heap.page_allocator);

    pair_heap = PairHeap{ .context = {} };

    for (0..N) |n| {
        const i = rand.int(i32);

        binary_heap_for_delete.insert(i) catch @panic("Insert failed");
        quateranry_heap_for_delete.insert(i) catch @panic("Insert failed");

        randomArrayForInsert.append(Elem{ .value = i }) catch @panic("Insert failed");
        randomArrayForDelete.append(Elem{ .value = i }) catch @panic("Insert failed");

        pair_heap.insert(&randomArrayForDelete.items[n]);
    }
}

// **************** Benchmarks ****************

fn benchmarkBinaryHeapInsert(allocator: std.mem.Allocator) void {
    // var heap = root.MinBinaryHeap.init(allocator);

    // defer heap.deinit();

    _ = allocator;
    for (0..N) |n| {
        binary_heap_for_insert.insert(randomArrayForInsert.items[n].value) catch @panic("Insert failed");
    }
}

fn benchmarkBinaryHeapInsertWithAlloc(allocator: std.mem.Allocator) void {
    var heap = root.MinBinaryHeap.init(allocator);

    defer heap.deinit();

    for (0..N) |n| {
        heap.insert(randomArrayForInsert.items[n].value) catch @panic("Insert failed");
    }
}

fn benchmarkBinaryHeapDeleteMin(allocator: std.mem.Allocator) void {
    _ = allocator;
    for (0..N) |_| {
        _ = binary_heap_for_delete.deleteMin().?;
    }
}

fn benchmarkQuaternaryHeapInsert(allocator: std.mem.Allocator) void {
    _ = allocator;
    for (0..N) |n| {
        quateranry_heap_for_insert.insert(randomArrayForInsert.items[n].value) catch @panic("Insert failed");
    }
}

fn benchmarkQuaternaryHeapInsertWithAlloc(allocator: std.mem.Allocator) void {
    var heap = root.MinQuaternaryHeap.init(allocator);

    defer heap.deinit();

    for (0..N) |n| {
        heap.insert(randomArrayForInsert.items[n].value) catch @panic("Insert failed");
    }
}

fn benchmarkQuaternaryHeapDeleteMin(allocator: std.mem.Allocator) void {
    _ = allocator;
    for (0..N) |_| {
        _ = quateranry_heap_for_delete.deleteMin().?;
    }
}

fn benchmarkPairHeapInsert(allocator: std.mem.Allocator) void {
    _ = allocator;

    var heap: PairHeap = .{ .context = {} };
    for (0..N) |i| {
        heap.insert(&randomArrayForInsert.items[i]);
    }
}

fn benchmarkPairHeapDeleteMin(allocator: std.mem.Allocator) void {
    _ = allocator;

    for (0..N) |_| {
        _ = pair_heap.deleteMin().?;
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("\n\n{}\n", .{try zbench.getSystemInfo()});

    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{ .hooks = .{ .before_each = before_each } });
    defer bench.deinit();

    try bench.add("B_HeapInsert", benchmarkBinaryHeapInsert, .{});
    try bench.add("B_HeapInsertWithAlloc", benchmarkBinaryHeapInsertWithAlloc, .{});
    try bench.add("B_HeapDeleteMin", benchmarkBinaryHeapDeleteMin, .{});

    try bench.add("Q_HeapInsert", benchmarkQuaternaryHeapInsert, .{});
    try bench.add("Q_HeapInsertWithAlloc", benchmarkQuaternaryHeapInsertWithAlloc, .{});
    try bench.add("Q_HeapDeleteMin", benchmarkQuaternaryHeapDeleteMin, .{});

    try bench.add("P_HeapInsert", benchmarkPairHeapInsert, .{});
    try bench.add("P_HeapDeleteMin", benchmarkPairHeapDeleteMin, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
