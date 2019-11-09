if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(DirectXSDK_HOST_ARCHITECTURE x64)
else()
	set(DirectXSDK_HOST_ARCHITECTURE x86)
endif()

if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86")
	set(DirectXSDK_BUILD_ARCHITECTURE "x86")
else()
	set(DirectXSDK_BUILD_ARCHITECTURE "x64")
endif()

find_path(DirectXSDK_ROOT_DIR
	NAMES Include/D3D9.h Include/d3d9.h include/D3D9.h include/d3d9.h
	PATHS
		"$ENV{DirectXSDK_DIR}"
		"${DirectXSDK_DIR}"
		"${ProgramFiles}/Microsoft DirectX SDK (June 2010)"
		"${ProgramFiles}/Microsoft DirectX SDK (February 2010)"
		"${ProgramFiles}/Microsoft DirectX SDK (March 2009)"
		"${ProgramFiles}/Microsoft DirectX SDK (August 2008)"
		"${ProgramFiles}/Microsoft DirectX SDK (June 2008)"
		"${ProgramFiles}/Microsoft DirectX SDK (March 2008)"
		"${ProgramFiles}/Microsoft DirectX SDK (November 2007)"
		"${ProgramFiles}/Microsoft DirectX SDK (August 2007)"
		"${ProgramFiles}/Microsoft DirectX SDK"
	DOC "DirectX SDK root directory")

if(DirectXSDK_ROOT_DIR)
	set(DirectXSDK_INC_SEARCH_PATH "${DirectXSDK_ROOT_DIR}/Include")
	set(DirectX_LIB_SEARCH_PATH "${DirectXSDK_ROOT_DIR}/Lib/${DirectX_HOST_ARCHITECTURE}")
	set(DirectX_BIN_SEARCH_PATH "${DirectXSDK_ROOT_DIR}/Utilities/bin/x86")
	if(DirectX_BUILD_ARCHITECTURE STREQUAL "x64")
		list(INSERT DirectX_BUILD_ARCHITECTURE 0 "${DirectXSDK_ROOT_DIR}/Utilities/bin/x64")
	endif()
endif()

find_path(DirectXSDK_INCLUDE_DIR NAMES d3d9.h D3D9.h
	PATH_SUFFIXES include Include
	PATHS ${DirectXSDK_ROOT_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DirectXSDK
	FOUND_VAR DirectXSDK_FOUND
	REQUIRED_VARS DirectXSDK_ROOT_DIR DirectXSDK_INCLUDE_DIR)

mark_as_advanced(DirectXSDK_ROOT_DIR DirectXSDK_INCLUDE_DIR)
