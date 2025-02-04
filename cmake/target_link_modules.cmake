# Link a library to its modules (see: `add_module`)
# and remove the module sources from the library's sources.
#
# add_module(parent a)
# add_module(parent b)
# target_link_libraries(project.libparent.b PUBLIC project.libparent.a)
# add_library(project.libparent)
# target_link_modules(parent PUBLIC a b)
function(target_link_modules parent scope)
  set(library ${PROJECT_NAME}.lib${parent})
  foreach(name ${ARGN})
    set(module ${library}.${name})
    get_target_property(sources ${library} SOURCES)
    list(LENGTH sources before)
    get_target_property(dupes ${module} SOURCES)
    list(LENGTH dupes expected)
    list(REMOVE_ITEM sources ${dupes})
    list(LENGTH sources after)
    math(EXPR actual "${before} - ${after}")
    message(STATUS "${module} with ${expected} sources took ${actual} sources from ${library}")
    set_target_properties(${library} PROPERTIES SOURCES "${sources}")
    target_link_libraries(${library} ${scope} ${module})
  endforeach()
endfunction()
