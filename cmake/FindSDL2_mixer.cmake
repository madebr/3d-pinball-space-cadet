set(SDL2_mixer_SEARCH_PATH
	~/Library/Frameworks
	/Library/Frameworks
	/usr/local
	/usr
	/sw
	/opt/local
	/opt/csw
	/opt
	${SDL2_mixer_ROOT_DIR})

find_path(SDL2_mixer_INCLUDE_DIR SDL_mixer.h
	PATHS ${SDL2_mixer_SEARCH_PATH} ENV SDL2_mixer_ROOT_DIR
	PATH_SUFFIXES SDL2 include/SDL2 include
	DOC "SDL2_mixer include directory")

find_library(SDL2_mixer_SHARED_LIBRARY_PATH
	NAMES SDL2_mixer
	PATH_SUFFIXES lib64 lib ENV SDL2_mixer_ROOT_DIR
	PATHS ${SDL2_mixer_SEARCH_PATH}
	DOC "SDL2_mixer shared library")

find_library(SDL2_mixer_STATIC_LIBRARY_PATH
	NAMES libSDL2_mixer.lib libSDL2_mixer.a SDL2_mixer.lib SDL2_mixer.a
	PATH_SUFFIXES lib64 lib
	PATHS ${SDL2_mixer_SEARCH_PATH} ENV SDL2_mixer_ROOT_DIR
	DOC "SDL2_mixer static library")

if(SDL2_mixer_STATIC)
	set(SDL2_mixer_LIBRARY_PATH ${SDL2_mixer_STATIC_LIBRARY_PATH})
else()
	set(SDL2_mixer_LIBRARY_PATH ${SDL2_mixer_SHARED_LIBRARY_PATH})
endif()

if(SDL2_mixer_INCLUDE_DIR AND NOT SDL2_mixer_VERSION)
	file(READ "${SDL2_mixer_INCLUDE_DIR}/SDL_mixer.h" _SDL_mixer_VERSION_H)
	set(SDL2_mixer_REGEXES
		"SDL_MIXER_MAJOR_VERSION[ ]+([0-9]+)"
		"SDL_MIXER_MINOR_VERSION[ ]+([0-9]+)"
		"SDL_MIXER_PATCHLEVEL[ ]+([0-9]+)"
		)
	set(_SDL2_mixer_VERSION)
	foreach(_SDL2_mixer_REGEX ${SDL2_mixer_REGEXES})
		string(REGEX MATCH "${_SDL2_mixer_REGEX}" _SDL2_mixer_NUMBER "${_SDL_mixer_VERSION_H}")
		if(NOT _SDL2_mixer_NUMBER)
			message(AUTHOR_WARNING "Cannot detect SDL2 version: regex \"${_SDL2_mixer_REGEX}\" does not match")
		endif()
		list(APPEND _SDL2_mixer_VERSION "${CMAKE_MATCH_1}")
	endforeach()
	string(REPLACE ";" "." SDL2_mixer_VERSION "${_SDL2_mixer_VERSION}")
	set(SDL2_mixer_VERSION "${SDL2_mixer_VERSION}" CACHE STRING "Version of SDL2_mixer")
endif()

find_package(SDL2 REQUIRED)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SDL2_mixer
	FOUND_VAR SDL2_mixer_FOUND
	REQUIRED_VARS SDL2_mixer_LIBRARY_PATH SDL2_mixer_INCLUDE_DIR
	VERSION_VAR SDL2_mixer_VERSION)

mark_as_advanced(SDL2_mixer_LIBRARY_PATH SDL2_mixer_INCLUDE_DIR SDL2_mixer_VERSION)

if(SDL2_mixer_FOUND AND NOT TARGET SDL2_mixer::SDL2_mixer)
	add_library(SDL2_mixer::SDL2_mixer INTERFACE IMPORTED)
	set_property(TARGET SDL2_mixer::SDL2_mixer
		PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${SDL2_mixer_INCLUDE_DIR})
	set_property(TARGET SDL2_mixer::SDL2_mixer
		PROPERTY INTERFACE_LINK_LIBRARIES ${SDL2_mixer_LIBRARY_PATH} SDL2::SDL2)
endif()
