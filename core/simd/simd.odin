package simd

import "core:builtin"
import "core:intrinsics"

// boolx16 :: #simd[16]bool
// b8x16   :: #simd[16]b8
// b16x8   :: #simd[8]b16
// b32x4   :: #simd[4]b32
// b64x2   :: #simd[2]b64

// u8x16 :: #simd[16]u8
// i8x16 :: #simd[16]i8
// u16x8 :: #simd[8]u16
// i16x8 :: #simd[8]i16
// u32x4 :: #simd[4]u32
// i32x4 :: #simd[4]i32
// u64x2 :: #simd[2]u64
// i64x2 :: #simd[2]i64

// f16x8 :: #simd[8]f16
// f32x4 :: #simd[4]f32
// f64x2 :: #simd[2]f64


add :: intrinsics.simd_add
sub :: intrinsics.simd_sub
mul :: intrinsics.simd_mul
div :: intrinsics.simd_div
rem :: intrinsics.simd_rem

// Keeps Odin's Behaviour
// (x << y) if y <= mask else 0
shl :: intrinsics.simd_shl
shr :: intrinsics.simd_shr

// Similar to C's Behaviour
// x << (y & mask)
shl_masked :: intrinsics.simd_shl_masked
shr_masked :: intrinsics.simd_shr_masked

and :: intrinsics.simd_and
or  :: intrinsics.simd_or
xor :: intrinsics.simd_xor

neg :: intrinsics.simd_neg

abs :: intrinsics.simd_abs
min :: intrinsics.simd_min
max :: intrinsics.simd_max

// Return an unsigned integer of the same size as the input type
// NOT A BOOLEAN
// element-wise:
//     false => 0x00...00
//     true  => 0xff...ff
eq :: intrinsics.simd_eq
ne :: intrinsics.simd_ne
lt :: intrinsics.simd_lt
le :: intrinsics.simd_le
gt :: intrinsics.simd_gt
ge :: intrinsics.simd_ge

// extract :: proc(a: #simd[N]T, idx: uint) -> T
extract :: intrinsics.simd_extract
// replace :: proc(a: #simd[N]T, idx: uint, elem: T) -> #simd[N]T
replace :: intrinsics.simd_replace

reduce_add_ordered :: intrinsics.simd_reduce_add_ordered
reduce_mul_ordered :: intrinsics.simd_reduce_mul_ordered
reduce_min         :: intrinsics.simd_reduce_min
reduce_max         :: intrinsics.simd_reduce_max
reduce_and         :: intrinsics.simd_reduce_and
reduce_or          :: intrinsics.simd_reduce_or
reduce_xor         :: intrinsics.simd_reduce_xor

// swizzle :: proc(a: #simd[N]T, indices: ..int) -> #simd[len(indices)]T
swizzle :: builtin.swizzle

// shuffle :: proc(a, b: #simd[N]T, indices: #simd[max 2*N]u32) -> #simd[len(indices)]T
shuffle :: intrinsics.simd_shuffle

// select :: proc(cond: #simd[N]boolean_or_integer, true, false: #simd[N]T) -> #simd[N]T
select :: intrinsics.simd_select

splat :: #force_inline proc "contextless" ($T: typeid/#simd[$LANES]$E, value: E) -> T {
	return T{0..<LANES = value}
}

to_array_ptr :: #force_inline proc "contextless" (v: ^#simd[$LANES]$E) -> ^[LANES]E {
	return (^[LANES]E)(v)
}
to_array :: #force_inline proc "contextless" (v: #simd[$LANES]$E) -> [LANES]E {
	return transmute([LANES]E)(v)
}
from_array :: #force_inline proc "contextless" (v: $A/[$LANES]$E) -> #simd[LANES]E {
	return transmute(#simd[LANES]E)v
}

from_slice :: proc($T: typeid/#simd[$LANES]$E, slice: []E) -> T {
	assert(len(slice) >= LANES, "slice length must be a least the number of lanes")
	array: [LANES]E
	#no_bounds_check for i in 0..<LANES {
		array[i] = slice[i]
	}
	return transmute(T)array
}
