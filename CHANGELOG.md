# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- LICENSE file.
- Code of Conduct.
- Add support for Ruby 3.2 and 3.3 (no changes).

## [1.1.0] - 2022-11-07

### Added

- Support for chains of operations longer than the most simple cases.
- Introduce Classlist::Operation as a common super class for Classlist::Add, Classlist::Remove, Classlist::Reset.
- Classlist::Add that adds all entries when merged

## [1.0.0]

### Added

- Classlist::Reset that replaces all entries when merged
- Classlist::Remove that removes entries when merged
- DOMTokenList compatible Classlist class.
