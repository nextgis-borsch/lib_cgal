if ( NOT CGAL_Boost_Setup )

  include(CGAL_TweakFindBoost)

  set ( CGAL_requires_Boost_libs TRUE )
  if ( DEFINED  MSVC_VERSION AND "${MSVC_VERSION}" GREATER 1800)
    set ( CGAL_requires_Boost_libs FALSE )
  endif()

  if ( CMAKE_COMPILER_IS_GNUCXX
      AND(
        #CMAKE_CXX_STANDARD_DEFAULT is available starting cmake 3.4
        ( DEFINED CMAKE_CXX_STANDARD_DEFAULT
          AND ${CMAKE_CXX_STANDARD_DEFAULT} GREATER 03
          AND ${CMAKE_CXX_STANDARD_DEFAULT} LESS 98 )
        #GCC 4.8+ with c++11 on
        OR ( NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.8
          AND CMAKE_CXX_FLAGS MATCHES "\\-std=(c|gnu)\\+\\+[01][14yxz]")
        #GCC 6.0+ without c++03 on
        OR ( NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 6.0
             AND NOT CMAKE_CXX_FLAGS MATCHES "\\-std=(c|gnu)\\+\\+[90][83]"
             AND NOT CMAKE_CXX_FLAGS MATCHES "\\-ansi")
      ) )
    set ( CGAL_requires_Boost_libs FALSE )
  endif()

  if ( ANDROID
      # using regular Clang or AppleClang
      AND CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set ( CGAL_requires_Boost_libs FALSE )
  endif()

  include(FindAnyProject)

  if (CGAL_requires_Boost_libs)
    # TODO: change to find_anyproject after full cmaked boost
    find_package( Boost 1.48 REQUIRED thread system )
    #find_anyproject( Boost VERSION 1.48 REQUIRED COMPONENTS thread system )
  else()
    find_anyproject( Boost VERSION 1.48 REQUIRED )
  endif()

  if(Boost_FOUND)
    if(DEFINED Boost_DIR AND NOT Boost_DIR)
      # Unset that cache variable that is set in the cache by FindBoost
      # (while it was searching for boost-cmake).
      unset(Boost_DIR CACHE)
      set(Boost_NO_BOOST_CMAKE TRUE CACHE INTERNAL "Avoid future search of boost-cmake")
    endif()
  endif()
  
  message( STATUS "Boost include:     ${Boost_INCLUDE_DIRS}" )
  message( STATUS "Boost libraries:   ${Boost_LIBRARIES}" )
  message( STATUS "Boost definitions: ${Boost_DEFINITIONS}" )
  
  set ( CGAL_USE_BOOST 1 )
  
  include(CGAL_Macros)
  
  add_to_cached_list(CGAL_3RD_PARTY_INCLUDE_DIRS   ${Boost_INCLUDE_DIRS} )
  add_to_cached_list(CGAL_3RD_PARTY_LIBRARIES_DIRS ${Boost_LIBRARY_DIRS} )
  add_to_cached_list(CGAL_3RD_PARTY_DEFINITIONS    ${Boost_DEFINITIONS}  )
  
  if ( NOT MSVC )
    add_to_cached_list(CGAL_3RD_PARTY_LIBRARIES ${Boost_LIBRARIES} )
  endif()
  
  message( STATUS "USING BOOST_VERSION = '${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION}'" )
  
  set ( CGAL_Boost_Setup TRUE )
  
endif()

