#
# Install itk libraries from source
#

if (NOT itk_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (hdf5)
include (libpng)
include (jpeg)
include (tiff)
include (zlib)

external_source (itk
    4.6.1
    InsightToolkit-4.6.1.tar.gz
    2c84eae50ab2452cdad32aaadced3c37
    http://iweb.dl.sourceforge.net/project/itk/itk/4.6
    FORCE)

message ("Installing ${itk_NAME} into build area: ${ILASTIK_DEPENDENCY_DIR} ...")

# update paths if a new version of itk is used!
# set (itk_LIBPATH ${ILASTIK_DEPENDENCY_DIR}/lib/itk-4.6)
set (itk_CONFIG_DIR ${ILASTIK_DEPENDENCY_DIR}/lib/cmake/ITK-4.6)
# include_directories (${ILASTIK_DEPENDENCY_DIR}/include/itk-4.6)

##
## For now, we do not bother building the python bindings...
##
ExternalProject_Add(${itk_NAME}
    DEPENDS             ${hdf5_NAME} ${libpng_NAME} ${libjpeg_NAME} ${libtiff_NAME} ${zlib_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${itk_URL}
    URL_MD5             ${itk_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${itk_SRC_DIR}
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DBUILD_TESTING:BOOL=OFF
        -DITK_BUILD_DEFAULT_MODULES=0
        -DBUILD_EXAMPLES=0
        -DITKGroup_Core=1
        -DITKGroup_Segmentation=1
        -DModule_ITKConvolution=1
        -DModule_ITKEigen=1
    
        # hdf5
        -DITK_USE_SYSTEM_HDF5=ON
        -DHDF5_C_LIBRARY:FILEPATH=${ILASTIK_DEPENDENCY_DIR}/lib/hdf5.lib 
        -DHDF5_DIR:PATH=${ILASTIK_DEPENDENCY_DIR}/cmake/hdf5
        # libpng
        -DITK_USE_SYSTEM_PNG=ON
        -DPNG_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/libpng15.lib
        # libjpeg
        -DITK_USE_SYSTEM_JPEG=ON
        -DJPEG_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/jpeg.lib
        # libtiff
        -DITK_USE_SYSTEM_TIFF=ON
        -DTIFF_LIBRARY:FILEPATH=${ILASTIK_DEPENDENCY_DIR}/lib/libtiff_i.lib    
        # zlib
        -DITK_USE_SYSTEM_ZLIB=ON
        -DZLIB_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/zlib.lib
    
    # BUILD_COMMAND       devenv itk.sln /build Release /project INSTALL
    BUILD_COMMAND       cmake --build . --target INSTALL --config Release
    #TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ""
)

set_target_properties(${itk_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT itk_NAME)