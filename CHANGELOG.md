# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Changed

- Operations are applied as soon as they are added to a Classlist instead of being kept pending until the Classlist is rendered.
- Adding to a Classlist or an Operation with `+` returns a new object and never changes either operand.
- `add_operation` is an alias for `+`, so it returns a new object instead of changing the classlist or operation it is called on.
- Adding a plain Classlist, String or Array to a Classlist is the same as adding a `Classlist::Add` with those tokens.
- An operation shared between several classlists, or nested more than once, now gives the same result every time it is applied. Previously its nested operations were only applied the first time.
- Adding, removing, toggling and checking for a token take constant time regardless of the number of tokens in the list.
- Equality requires both sides to be of the same class, so a Classlist is never equal to an Operation.

### Removed

- `Classlist#operations` and `Classlist#resolve_operations`, since a Classlist no longer has pending operations. `Classlist::Operation#operations` remains.
- `Classlist::Operation#resolve`. Custom operations implement the private `apply_self(target)` method instead, which changes target in place.

### Fixed

- Adding a String or Array to a `Classlist::Remove` or `Classlist::Reset` now adds those tokens after the operation, instead of turning the whole thing into an addition.
- Replacing a token with itself leaves the classlist unchanged instead of removing the token.
- `replace` raises `Classlist::ArgumentError` when either token contains whitespace, like `toggle` does, instead of storing a token with whitespace in it.
- `toggle` raises `Classlist::ArgumentError` for tokens containing any whitespace, such as tabs and newlines, not just spaces.

## 1.1.3 - 2026-10-06

### Added

- Add support for Ruby 4.0 (no changes).

### Fixed

- Adding a String or Array to a Classlist with pending operations no longer drops those operations.

## 1.1.2 - 2026-08-06

### Fixed

- v1.1.1 unfortunately included a serious performance regression.

## [1.1.1] - 2025-12-08

### Added

- LICENSE file.
- Code of Conduct.
- Add support for Ruby 3.2, 3.3, 3.4 (no changes).

### Fixed

- Adding a raw `Classlist` to a set of `Classlist::Operation`s would merge the `Classlist` into the last operation, instead of treating the `Classlist` as an implicit `Classlist::Add` operation (which it should be).

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
