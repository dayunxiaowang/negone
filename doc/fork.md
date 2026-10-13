# NegOne fork and naming

NegOne is an independently maintained fork of [NoirVisor](https://github.com/Zero-Tang/NoirVisor). Its initial Rust baseline is upstream `rust-dev` commit `69f1a459a2ef4182d4ea929bf2126912180ba862` (2026-10-09). NegOne development uses `rust-dev`; the upstream `master` branch is not this Rust baseline.

## Product identity

| Item | NegOne name |
|---|---|
| GitHub repository | `dayunxiaowang/negone` |
| Core Cargo package | `negone-core` |
| Core static library for UEFI | `libnegone_core.a` |
| UEFI runtime driver | `NegOne.efi` |
| UEFI configuration | `NegOneConfig.bin` |
| Disk images | `NegOne-Uefi.img`, `.vhdx`, `.vmdk` |
| Windows driver | `NegOne.sys` / `NegOne-unsigned.sys` |
| Windows service | `NegOne` |
| Windows device / symbolic link | `\Device\NegOne` / `\DosDevices\NegOne` |
| Driver entry symbol | `NegOneDriverEntry` |
| CPUID vendor identity | `NegOne VMM  ` (12 ASCII bytes, including two trailing spaces) |

The loader, build manifests, configuration reader, Windows client library, driver resources, and emulator scripts use these names together. Existing binaries that open the old Windows device path must be rebuilt or adapted.

## Interface compatibility

This naming change preserves the following interfaces:

- The `nvcvm` Cargo package and its `ncv_*` C exports.
- Existing numeric IOCTL and hypercall identifiers, status codes, and structure layouts.
- The UEFI CVM scheduling protocol GUID. `NegOneCvmSchedulingProtocol` is the preferred Rust name; `NoirVisorCvmSchedulingProtocol` remains a type alias for existing source users.
- The `Hv#1` interface signature and existing Hyper-V compatibility feature semantics. The vendor string is product identity, not a declaration of a different TLFS interface.
- Internal `nvc_*` entry points shared between core/platform crates. Internal `noir_*` symbols are renamed consistently to `negone_*` across Rust and assembly.
- The standard UEFI fallback filename `bootx64.efi` and the descriptive scheduler filename `cvsched.efi`.

Renaming protocol numbers, changing GUIDs or layouts, replacing the CVM API, and adding a user-mode communication transport require separate compatibility work. This fork does not claim complete binary compatibility with old NoirVisor clients because the device path and product identity have changed.

## Attribution and historical material

The original MIT and Apache-2.0 license texts and source copyright notices are retained. `doc/events.md`, `doc/nsv.md`, and `doc/parhelion.md` retain upstream history/design terminology and identify themselves as inherited references. Their descriptions are not evidence that a feature is implemented in NegOne.

The inherited `build/ztnxtest.pfx` is the upstream test-signing fixture. Its filename and contents are unchanged; it is not a NegOne release-signing identity.

## Development layout

Windows builds the binaries and images. A separate Linux machine can run QEMU/OVMF and collect guest output. Keep toolchains and caches on a disk with enough space; machine-specific tool paths should stay outside versioned project configuration.

Retain these remotes to make upstream synchronization explicit:

```text
origin    https://github.com/dayunxiaowang/negone.git
upstream  https://github.com/Zero-Tang/NoirVisor.git
```
