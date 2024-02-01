# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Simple build script
- Tests for simple directives functionality
- Debug logs that are useful for both tests and debugging

### Fixed

- Fix servers and ignore_codes configs override
- Fix request tags configs merging
- Fix request timers configs merging

### Changed

- Disallow using variables in request/timer tags names

### Removed

- Useless pinba_buffer_size directive

## [1.0.0] - 2023-05-26

Basic version of this module that works for years in Bumble.
