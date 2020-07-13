# Retrieve github information relating to the branch, tag and commit from which the repo
# being used was generated. This relies on cmake being present for a user to execute via `cmake -P gitversion.cmake`
# or more generally as part of the travis build process

execute_process(COMMAND git log --pretty=format:'%h' -n 1
                OUTPUT_VARIABLE GIT_REV
                ERROR_QUIET)

if ("${GIT_REV}" STREQUAL "")
  set(GIT_REV "N/A")
  set(GIT_DIFF "N/A")
  set(GIT_TAG "N/A")
  set(GIT_BRANCH "N/A")
else()
  # Git specific information retrieval
  execute_process(
    COMMAND git describe --exact-match --tags
    OUTPUT_VARIABLE GIT_TAG ERROR_QUIET)

  execute_process(
    COMMAND git rev-parse --abbrev-ref HEAD
    OUTPUT_VARIABLE GIT_BRANCH)
  
  # Windows seems to have issues with the use of the conditional echo used (alternative potentially needed)
  if(WIN32)
    set(GIT_DIFF "N/A")
  else()  
    execute_process(
      COMMAND bash -c "git diff --quiet --exit-code || echo diff-present"
      OUTPUT_VARIABLE GIT_DIFF ERROR_QUIET)
  endif()

  if(WIN32)
    set(OSFLAG "Windows")
  elseif(APPLE)
    set(OSFLAG "MacOS")
  else()
    set(OSFLAG "Linux")
  endif()

  string(STRIP "${OSFLAG}" OSFLAG)
  string(STRIP "${GIT_DIFF}" GIT_DIFF)
  string(STRIP "${GIT_REV}" GIT_REV)
  string(SUBSTRING "${GIT_REV}" 1 7 GIT_REV)
  string(STRIP "${GIT_TAG}" GIT_TAG)
  string(STRIP "${GIT_BRANCH}" GIT_BRANCH)
endif()

# Set the contents to be written to version.txt
set(VERSION "GIT_REV=${GIT_REV}
GIT_TAG=${GIT_TAG}
GIT_BRANCH=${GIT_BRANCH}
GIT_DIFF=${GIT_DIFF}
OS_INFO=${OSFLAG}")

# Check if a version.txt file exists and retrieve its contents
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/q/version.txt)
  file(READ ${CMAKE_CURRENT_SOURCE_DIR}/q/version.txt VERSION_)
else()
  set(VERSION_ "")
endif()

# If the content of the current version.txt does not equal what is contained here overwrite
if (NOT "${VERSION}" STREQUAL "${VERSION_}")
  file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/q/version.txt "${VERSION}")
endif()
