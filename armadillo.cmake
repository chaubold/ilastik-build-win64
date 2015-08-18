#
# Install armadillo from source
#

if (NOT armadillo_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (openblas)
include (hdf5)

external_source (armadillo
    4.320.0
    armadillo-4.320.0.tar.gz
    d174ebcb5bffde6c8da8f47f06147386
    http://sourceforge.net/projects/arma/files/
    FORCE)
    
if(${ILASTIK_BITNESS} STREQUAL "64")
    set(ARMA_USE_64BIT_WORD "-DARMA_64BIT_WORD=1")
    set(CMAKE_SHARED_LINKER_FLAGS "/machine:x64")
endif()
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ILASTIK_DEPENDENCY_DIR}/lib/emulate_c99.lib ${ILASTIK_DEPENDENCY_DIR}/lib/libgcc.lib  ${ILASTIK_DEPENDENCY_DIR}/lib/libgfortran-3.lib")

set(PATCH_ARMADILLO_CONFIG "${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_armadillo.py ${ILASTIK_DEPENDENCY_DIR}/share/Armadillo/CMake/ArmadilloLibraryDepends-release.cmake ${ILASTIK_DEPENDENCY_DIR}/lib")
    
message ("Installing ${armadillo_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${armadillo_NAME}
    DEPENDS             ${openblas_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${armadillo_URL}
    URL_MD5             ${armadillo_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${PATCH_EXE} -p0 -i ${PROJECT_SOURCE_DIR}/patches/armadillo.patch
    LIST_SEPARATOR ^^
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${armadillo_SRC_DIR} 
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DCMAKE_PREFIX_PATH=${ILASTIK_DEPENDENCY_DIR}
        -DOpenBLAS_NAMES=libopenblas
		-DCMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}
        -DCMAKE_MODULE_PATH=${ILASTIK_DEPENDENCY_DIR}/cmake/hdf5/
        ${ARMA_USE_64BIT_WORD}
    BUILD_COMMAND       devenv armadillo.sln /build Release /project ALL_BUILD
    INSTALL_COMMAND     devenv armadillo.sln /build Release /project INSTALL
                      \n${PATCH_ARMADILLO_CONFIG}
)

set_target_properties(${armadillo_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT armadillo_NAME)
