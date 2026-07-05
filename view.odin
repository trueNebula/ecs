package ecs

import "base:runtime"
import "core:fmt"
import "core:prof/spall"
import u "game:util"

/** 
 * Entity Views
 * Returns a list of entityID - components structs
 */
EntityView1 :: struct($T1: typeid) {
	id: u32,
	c1: ^T1,
}

View1 :: proc(world: ^World, $T1: typeid) -> [dynamic]EntityView1(T1) {
	tids := []typeid{typeid_of(T1)}
	mask := computeMask(world, tids)
	views := make([dynamic]EntityView1(T1), context.temp_allocator)

	for arch in world.archetypes {
		if !maskIncludes(&arch.mask, &mask) do continue

		col1 := arch.columns[T1]

		size1 := world.meta[T1].size

		for entId, entIdx in arch.entities {
			view: EntityView1(T1)
			view.id = entId
			view.c1 = (^T1)(&col1[entIdx * size1])

			append(&views, view)
		}
	}

	return views
}

EntityView2 :: struct($T1: typeid, $T2: typeid) {
	id: u32,
	c1: ^T1,
	c2: ^T2,
}

View2 :: proc(world: ^World, $T1: typeid, $T2: typeid) -> [dynamic]EntityView2(T1, T2) {
	spall.SCOPED_EVENT(&u.spall_ctx, &u.spall_buf, "view.View2")

	tids := []typeid{typeid_of(T1), typeid_of(T2)}
	mask := computeMask(world, tids)
	views := make([dynamic]EntityView2(T1, T2), context.temp_allocator)

	for arch in world.archetypes {
		if !maskIncludes(&arch.mask, &mask) do continue

		col1 := arch.columns[T1]
		col2 := arch.columns[T2]

		size1 := world.meta[T1].size
		size2 := world.meta[T2].size

		for entId, entIdx in arch.entities {
			view: EntityView2(T1, T2)
			view.id = entId
			view.c1 = (^T1)(&col1[entIdx * size1])
			view.c2 = (^T2)(&col2[entIdx * size2])

			append(&views, view)
		}
	}

	return views
}

EntityView3 :: struct($T1: typeid, $T2: typeid, $T3: typeid) {
	id: u32,
	c1: ^T1,
	c2: ^T2,
	c3: ^T3,
}

View3 :: proc(
	world: ^World,
	$T1: typeid,
	$T2: typeid,
	$T3: typeid,
) -> [dynamic]EntityView3(T1, T2, T3) {
	tids := []typeid{typeid_of(T1), typeid_of(T2), typeid_of(T3)}
	mask := computeMask(world, tids)

	views := make([dynamic]EntityView3(T1, T2, T3), context.temp_allocator)

	for arch in world.archetypes {
		if !maskIncludes(&arch.mask, &mask) do continue

		col1 := arch.columns[T1]
		col2 := arch.columns[T2]
		col3 := arch.columns[T3]

		size1 := world.meta[T1].size
		size2 := world.meta[T2].size
		size3 := world.meta[T3].size

		for entId, entIdx in arch.entities {
			view: EntityView3(T1, T2, T3)
			view.id = entId

			view.c1 = (^T1)(&col1[entIdx * size1])
			view.c2 = (^T2)(&col2[entIdx * size2])
			view.c3 = (^T3)(&col3[entIdx * size3])

			append(&views, view)
		}
	}

	return views
}

/**
 * Single Entity Views
 * Returns a single struct containing requested components for 
 * a given entity ID
 */
SingleEntityView1 :: struct($T1: typeid) {
	c1: ^T1,
}

SingleView1 :: proc(world: ^World, entityId: u32, $T1: typeid) -> SingleEntityView1(T1) {
	record := getRecord(world, entityId)
	arch := record.archetype
	row := record.row

	col1 := arch.columns[T1]

	size1 := world.meta[T1].size

	view := SingleEntityView1 {
		c1 = (^T1)(&col1[row * size1]),
	}

	return view
}

SingleEntityView2 :: struct($T1: typeid, $T2: typeid) {
	c1: ^T1,
	c2: ^T2,
}

SingleView2 :: proc(
	world: ^World,
	entityId: u32,
	$T1: typeid,
	$T2: typeid,
) -> SingleEntityView1(T1) {
	record := getRecord(world, entityId)
	arch := record.archetype
	row := record.row

	col1 := arch.columns[T1]
	col1 := arch.columns[T2]

	size1 := world.meta[T1].size
	size1 := world.meta[T2].size

	view := SingleEntityView1 {
		c1 = (^T1)(&col1[row * size1]),
		c2 = (^T2)(&col2[row * size2]),
	}

	return view
}


SingleEntityView3 :: struct($T1: typeid, $T2: typeid, $T3: typeid) {
	c1: ^T1,
	c2: ^T2,
	c3: ^T3,
}

SingleView3 :: proc(
	world: ^World,
	entityId: u32,
	$T1: typeid,
	$T2: typeid,
	$T3: typeid,
) -> SingleEntityView1(T1) {
	record := getRecord(world, entityId)
	arch := record.archetype
	row := record.row

	col1 := arch.columns[T1]
	col2 := arch.columns[T2]
	col3 := arch.columns[T3]

	size1 := world.meta[T1].size
	size2 := world.meta[T2].size
	size3 := world.meta[T3].size

	view := SingleEntityView1 {
		c1 = (^T1)(&col1[row * size1]),
		c2 = (^T2)(&col2[row * size2]),
		c3 = (^T3)(&col3[row * size3]),
	}

	return view
}
