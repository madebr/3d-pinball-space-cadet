set(SDL2_image_SEARCH_PATH
	~/Library/Frameworks
	/Library/Frameworks
	/usr/local
	/usr
	/sw
	/opt/local
	/opt/csw
	/opt
	${SDL2_image_ROOT_DIR})

find_path(SDL2_image_INCLUDE_DIR SDL_image.h
	PATHS ${SDL2_image_SEARCH_PATH} ENV SDL2_image_ROOT_DIR
	PATH_SUFFIXES SDL2 include/SDL2 include
	DOC "SDL2_image include directory")

find_library(SDL2_image_SHARED_LIBRARY_PATH
	NAMES SDL2_image
	PATH_SUFFIXES lib64 lib
	PATHS ${SDL2_image_SEARCH_PATH} ENV SDL2_image_ROOT_DIR
	DOC "SDL2_image shared library")

find_library(SDL2_image_STATIC_LIBRARY_PATH
	NAMES libSDL2_image.lib libSDL2_image.a SDL2_image.lib SDL2_image.a
	PATH_SUFFIXES lib64 lib
	PATHS ${SDL2_image_SEARCH_PATH} ENV SDL2_image_ROOT_DIR
	DOC "SDL2_image static library")

if(SDL2_image_STATIC)
	set(SDL2_image_LIBRARY_PATH ${SDL2_image_STATIC_LIBRARY_PATH})
else()
	set(SDL2_image_LIBRARY_PATH ${SDL2_image_SHARED_LIBRARY_PATH})
endif()

if(SDL2_image_INCLUDE_DIR AND NOT SDL2_image_VERSION)
	file(READ "${SDL2_image_INCLUDE_DIR}/SDL_image.h" _SDL_image_VERSION_H)
	set(SDL2_image_REGEXES
		"SDL_IMAGE_MAJOR_VERSION[ ]+([0-9]+)"
		"SDL_IMAGE_MINOR_VERSION[ ]+([0-9]+)"
		"SDL_IMAGE_PATCHLEVEL[ ]+([0-9]+)"
		)
	set(_SDL2_image_VERSION)
	foreach(_SDL2_image_REGEX ${SDL2_image_REGEXES})
		string(REGEX MATCH "${_SDL2_image_REGEX}" _SDL2_image_NUMBER "${_SDL_image_VERSION_H}")
		if(NOT _SDL2_image_NUMBER)
			message(AUTHOR_WARNING "Cannot detect SDL2 version: regex \"${_SDL2_image_REGEX}\" does not match")
		endif()
		list(APPEND _SDL2_image_VERSION "${CMAKE_MATCH_1}")
	endforeach()
	string(REPLACE ";" "." SDL2_image_VERSION "${_SDL2_image_VERSION}")
	set(SDL2_image_VERSION "${SDL2_image_VERSION}" CACHE STRING "Version of SDL2_image")
endif()

find_package(SDL2 REQUIRED)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SDL2_image
	FOUND_VAR SDL2_image_FOUND
	REQUIRED_VARS SDL2_image_LIBRARY_PATH SDL2_image_INCLUDE_DIR
	VERSION_VAR SDL2_image_VERSION)

mark_as_advanced(SDL2_image_LIBRARY_PATH SDL2_image_INCLUDE_DIR SDL2_image_VERSION)

if(SDL2_image_FOUND AND NOT TARGET SDL2_image::SDL2_image)
	add_library(SDL2_image::SDL2_image INTERFACE IMPORTED)
	set_property(TARGET SDL2_image::SDL2_image
		PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${SDL2_image_INCLUDE_DIR})
	set_property(TARGET SDL2_image::SDL2_image
		PROPERTY INTERFACE_LINK_LIBRARIES ${SDL2_image_LIBRARY_PATH} SDL2::SDL2)
endif()
