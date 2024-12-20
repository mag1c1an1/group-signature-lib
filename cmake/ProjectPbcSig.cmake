include(ExternalProject)
set(PBC_SIG_PATCH cp ${CMAKE_SOURCE_DIR}/patch/pbc_sig.patch ${CMAKE_SOURCE_DIR}/deps/src/pbc_sig && patch -f -p1 < ${CMAKE_SOURCE_DIR}/deps/src/pbc_sig/pbc_sig.patch && cp ${CMAKE_CURRENT_LIST_DIR}/config.guess <SOURCE_DIR>)

ExternalProject_Add(pbc_sig
    PREFIX ${CMAKE_SOURCE_DIR}/deps
    DOWNLOAD_NAME pbc_sig-0.0.8.tar.gz
    DOWNLOAD_NO_PROGRESS 1
    URL https://github.com/mag1c1an1/pbc_sig/releases/download/v0.0.8/pbc_sig-0.0.8.tar.gz
    URL_HASH SHA256=f9c141ece84c1591c11fea326084f2ffcdb94ceba9034e2f65add5eef5224c66
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${PBC_SIG_PATCH}
    CMAKE_COMMAND ${CMAKE_COMMAND}
    CMAKE_ARGS --debug-output
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
    INSTALL_COMMAND bash -c "/bin/cp -f libpbc_sig.a ${CMAKE_SOURCE_DIR}/deps/lib/libpbc_sig.a && /bin/cp -f include/* ${CMAKE_SOURCE_DIR}/deps/include/pbc/"
)

add_dependencies(pbc_sig pbc)
ExternalProject_Get_Property(pbc_sig SOURCE_DIR)
ExternalProject_Get_Property(pbc_sig INSTALL_DIR)

add_library(Pbc_sig STATIC IMPORTED)
set(PBC_SIG_INCLUDE_DIR ${INSTALL_DIR}/include)
set(PBC_SIG_LIBRARY ${INSTALL_DIR}/lib/libpbc_sig.a)
file(MAKE_DIRECTORY ${PBC_SIG_INCLUDE_DIR})  # Must exist.
file(MAKE_DIRECTORY ${INSTALL_DIR}/lib)  # Must exist.
set_property(TARGET Pbc_sig PROPERTY IMPORTED_LOCATION ${PBC_SIG_LIBRARY})
set_property(TARGET Pbc_sig PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${PBC_SIG_INCLUDE_DIR})
add_dependencies(Pbc_sig pbc_sig)
unset(INSTALL_DIR)
