#
# Install ilastiktools libraries from source
#

if (NOT ilastiktools_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (numpy)
include (vigra)

external_git_repo (ilastiktools
    afd850125a40e027e78eae1a78e03c20a961ea6a
    git://github.com/ilastik/ilastiktools.git
)

message ("Installing ${ilastiktools_NAME} into build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${ilastiktools_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${vigra_NAME} 
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${ilastiktools_URL}
    GIT_TAG             ${ilastiktools_TAG}
    UPDATE_COMMAND      ${GIT_EXECUTABLE} fetch origin 
                     \n ${GIT_EXECUTABLE} checkout ${ilastiktools_TAG} 
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${ilastiktools_SRC_DIR}
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR} 
        -DCMAKE_PREFIX_PATH=${ILASTIK_DEPENDENCY_DIR} 
        -DPYTHON_EXECUTABLE=${PYTHON_EXE} 
        -DVIGRA_INCLUDE_DIR=${ILASTIK_DEPENDENCY_DIR}/include 
        -DWITH_OPENMP=ON            
    BUILD_COMMAND       cmake --build . --target INSTALL --config Release
    INSTALL_COMMAND     ""
)

endif (NOT ilastiktools_NAME)

