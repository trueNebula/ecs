package ecs

import "core:prof/spall"
import u "game:util"

/** 
 * Queries
 * Runs a proc over every entity that has the given components
 */
Query1 :: proc(world: ^World, system: proc(c1: ^$T1)) {
	spall.SCOPED_EVENT(&u.spall_ctx, &u.spall_buf, "query.Query1")

	tids := []typeid{typeid_of(T1)}
	mask := computeMask(world, tids)

	for arch in world.archetypes {
		if !maskIncludes(&arch.mask, &mask) do continue

		col1 := arch.columns[typeid_of(T1)]

		s1 := world.meta[typeid_of(T1)].size

		for _, entIdx in arch.entities {
			p1 := (^T1)(&col1[entIdx * s1])

			system(p1)
		}
	}
}

Query2 :: proc(world: ^World, system: proc(c1: ^$T1, c2: ^$T2)) {
	tids := []typeid{typeid_of(T1), typeid_of(T2)}
	mask := computeMask(world, tids)

	for arch in world.archetypes {
		if !maskIncludes(&arch.mask, &mask) do continue

		col1 := arch.columns[typeid_of(T1)]
		col2 := arch.columns[typeid_of(T2)]

		s1 := world.meta[typeid_of(T1)].size
		s2 := world.meta[typeid_of(T2)].size

		for _, entIdx in arch.entities {
			p1 := (^T1)(&col1[entIdx * s1])
			p2 := (^T2)(&col2[entIdx * s2])

			system(p1, p2)
		}
	}
}

Query3 :: proc(world: ^World, system: proc(c1: ^$T1, c2: ^$T2, c3: ^$T3)) {
	tids := []typeid{typeid_of(T1), typeid_of(T2), typeid_of(T3)}
	mask := computeMask(world, tids)

	for arch in world.archetypes {
		if !maskIncludes(&arch.mask, &mask) do continue

		col1 := arch.columns[typeid_of(T1)]
		col2 := arch.columns[typeid_of(T2)]
		col3 := arch.columns[typeid_of(T3)]

		s1 := world.meta[typeid_of(T1)].size
		s2 := world.meta[typeid_of(T2)].size
		s3 := world.meta[typeid_of(T3)].size

		for _, entIdx in arch.entities {
			p1 := (^T1)(&col1[entIdx * s1])
			p2 := (^T2)(&col2[entIdx * s2])
			p3 := (^T3)(&col3[entIdx * s3])

			system(p1, p2, p3)
		}
	}
}
