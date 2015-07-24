#
# Install iiboost libraries from source
#

if (NOT iiboost_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (itk)
include (python)
include (numpy)

external_git_repo (iiboost
    fb3fd0b972ab5cbf2b837e3ecea937ef1e2fd096
    https://github.com/cbecker/iiboost)

message ("Installing ${iiboost_NAME} into build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${iiboost_NAME}
    DEPENDS             ${itk_NAME} ${python_NAME} ${numpy_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${iiboost_URL}
    GIT_TAG             ${iiboost_TAG}
    UPDATE_COMMAND      ${GIT_EXECUTABLE} fetch origin
                     \n ${GIT_EXECUTABLE} checkout ${iiboost_TAG}   
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${iiboost_SRC_DIR}
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DBUILD_PYTHON_WRAPPER=1
        -DITK_DIR=${itk_CONFIG_DIR}
            
    BUILD_COMMAND       cmake --build . --target INSTALL --config Release
    INSTALL_COMMAND     ""
)

endif (NOT iiboost_NAME)

