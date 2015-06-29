#
# Install tifffile Python package
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)

####################################################################

if (NOT tifffile_NAME)

external_git_repo (tifffile
    05b51f398b2c18eacf9dce674631707763f7e94e
    git://github.com/ilastik/tifffile.git)


message ("Installing ${tifffile_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${tifffile_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${tifffile_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${tifffile_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT tifffile_NAME)
