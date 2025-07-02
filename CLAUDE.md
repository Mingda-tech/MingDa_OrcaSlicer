# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MingDa OrcaSlicer is a 3D printing slicer based on OrcaSlicer, which itself is derived from Bambu Studio and PrusaSlicer. This is a C++ application with a wxWidgets GUI for processing 3D models into G-code for FDM 3D printers.

## Building the Project

### Windows
```bash
# Prerequisites: Visual Studio 2019, CMake, git, git-lfs, Strawberry Perl
# Run in x64 Native Tools Command Prompt for VS 2019
build_release.bat

# Build only dependencies
build_release.bat deps

# Build only slicer (after deps are built)
build_release.bat slicer

# Debug build
build_release.bat debug
```

### Linux (Ubuntu)
```bash
# First time setup (updates packages, requires sudo)
sudo ./BuildLinux.sh -u

# Build dependencies and slicer
./BuildLinux.sh -dsi

# Build with AppImage generation
./BuildLinux.sh -dsi

# Debug build
./BuildLinux.sh -dsib

# Skip RAM check for low memory systems
./BuildLinux.sh -dsir
```

### macOS
```bash
# Prerequisites: Xcode, CMake, git, gettext, libtool, automake, autoconf, texinfo
brew install cmake gettext libtool automake autoconf texinfo

# Build release
./build_release_macos.sh

# For Apple Silicon cross-compilation
# The build system automatically handles IS_CROSS_COMPILE
```

## Project Structure

- `/src/` - Main source code directory
  - `libslic3r/` - Core slicing library (no GUI dependencies)
  - `slic3r/` - GUI application code using wxWidgets
  - `libigl/` - Geometry processing library
  - `admesh/` - STL mesh processing
  - `agg/` - Anti-grain geometry library
  - `clipper/` - Polygon clipping library
- `/deps/` - Third-party dependencies managed by CMake
- `/resources/` - Application resources (profiles, images, translations)
  - `profiles/MingDa/` - MingDa printer profiles
  - `images/` - UI icons and graphics
  - `i18n/` - Internationalization files
- `/tests/` - Unit tests using Catch2 framework
- `/build/` - Build output directory (generated)

## Common Development Tasks

### Running Tests
```bash
# After building, tests are in the build directory
cd build
ctest

# Run specific test suite
./tests/libslic3r/libslic3r_tests

# Run with extra arguments
ctest --extra-verbose
```

### Translations/Localization
```bash
# Windows - Update pot file and merge translations
run_gettext.bat --full

# Generate only mo files from existing po files
run_gettext.bat
```

### Cleaning and Rebuilding
```bash
# Windows
rmdir /s /q build deps\build
build_release.bat

# Linux
rm -rf build deps/build
./BuildLinux.sh -dsi
```

## Key Architecture Points

### Core Slicing Engine (libslic3r)
- Platform-independent C++ library
- Handles all geometry processing, slicing algorithms, and G-code generation
- Key classes: `Model`, `Print`, `PrintObject`, `Layer`, `GCode`
- Uses Eigen for linear algebra, Clipper for 2D operations

### GUI Application (slic3r)
- Built with wxWidgets 3.2
- Main window class: `MainFrame`
- 3D view uses OpenGL with custom shaders
- Communicates with libslic3r through `Plater` class

### Configuration System
- Printer/filament/print profiles stored as JSON in resources/profiles/
- User settings in platform-specific locations
- Configuration keys defined in `PrintConfig.hpp`

### Build Configuration
- CMake-based build system with dependency management
- Static linking preferred on Windows/macOS
- Precompiled headers enabled by default
- Supports parallel compilation on MSVC

## Important Notes

- Always run `git lfs pull` after cloning on Windows to download required tools
- The project name is "mingda-slicer" in CMake but displays as "MINGDA-Slicer"
- Version info is in `version.inc` (currently 2.2.6)
- For Klipper firmware, users should enable `[exclude_object]` and `[gcode_arcs]` in printer.cfg