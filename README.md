# NegOne

NegOne is a Rust Type-1 hypervisor for x86-64 processors. Its name refers to the conventional "Ring -1" description of hardware virtualization mode.

NegOne is an independently maintained fork of [NoirVisor](https://github.com/Zero-Tang/NoirVisor), based on the upstream `rust-dev` branch at commit `69f1a459a2ef4182d4ea929bf2126912180ba862`. Original copyright notices and the MIT / Apache-2.0 licenses are retained.

- Repository: [dayunxiaowang/negone](https://github.com/dayunxiaowang/negone)
- Development branch: `rust-dev`
- Fork history and interface compatibility: [doc/fork.md](doc/fork.md)
- Initial build/check results and remaining environment gaps: [doc/validation.md](doc/validation.md)
- Build instructions: [doc/make.md](doc/make.md)
- Configuration and debugging: [doc/configuration.md](doc/configuration.md), [doc/debug.md](doc/debug.md)

## Architecture and current status

The UEFI application loads `NegOne.efi` before the operating system starts. The hypervisor initializes Intel VT-x / EPT or AMD-V / NPT and continues booting the operating system inside the virtualized environment.

The Windows driver, `NegOne.sys`, supplies the Customizable VM (CVM) scheduler and management interface. Loading this driver alone does not start the UEFI hypervisor or virtualize an already-running Windows installation.

The inherited Rust implementation is still under development:

- Both Intel and AMD have system virtualization backends.
- AMD has CVM VM/vCPU and memory-mapping implementations; Intel CVM operations remain incomplete.
- The upstream documentation limits booting Windows from UEFI to a single-core scenario.
- The retained NSV and Parhelion documents describe upstream designs, not completed NegOne features.

This fork does not claim stealth or production readiness.

## Build

Use Rust nightly with Clippy, rustfmt, and the `x86_64-unknown-uefi` target. The build also uses LLVM tools and NASM; image packaging uses GNU mtools and, for VHDX/VMDK conversion, `qemu-img`. See [the build guide](doc/make.md) for the complete prerequisites.

```text
python make.py check
python make.py test
python make.py /target uefi
python make.py /target windows
```

The core Cargo package is `negone-core`. The public CVM crate remains `nvcvm` for source compatibility.

Windows can produce the build artifacts while a separate Linux machine runs QEMU. Transfer the UEFI image to the same relative location expected by `tests/run_qemu.py`, for example `bin/compchk_uefix64/NegOne-Uefi.img` for a checked build. On Linux, use `python3` where appropriate.

## UEFI boot files

The generated image contains:

```text
\EFI\BOOT\bootx64.efi
\NegOne.efi
\NegOneConfig.bin
\cvsched.efi
```

`bootx64.efi` keeps its standard UEFI fallback filename. The loader and configuration paths are updated together with the build manifests.

## Windows CVM driver

After the UEFI hypervisor has booted and the driver has been prepared for the target Windows environment:

```text
sc create NegOne type= kernel binPath= <absolute path to NegOne.sys>
sc start NegOne
```

To stop or remove the driver service:

```text
sc stop NegOne
sc delete NegOne
```

The driver exposes `\Device\NegOne` and `\DosDevices\NegOne`. Applications should rebuild against this fork's `nvcvm` library to use the new device path. The driver service above is distinct from any future user-mode management service.

## Contributing and security

Submit NegOne changes to this repository's `rust-dev` branch. See [contributing.md](contributing.md) and [AGENTS.md](AGENTS.md) for development requirements.

Report vulnerabilities through the private channel described in [security.md](security.md).

## License and attribution

NegOne retains the upstream [MIT](LICENSE-MIT) / [Apache-2.0](LICENSE-APACHE) dual licensing. The `nvcvm` crate retains its MIT license. Original code is copyright Zero Tang and its respective contributors; the Git history records subsequent NegOne changes.

The original project, publications, and historical designs remain credited to their authors. This fork is maintained separately from the upstream NoirVisor project.
