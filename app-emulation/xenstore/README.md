This is a fork of app-emulation/xen-tools from the Gentoo repo. Our
fork is a really stripped down version of the upstream ebuild:

- It builds only xenstore, so configuration/compilation/installation
  steps are very simplified/rewritten to only handle xenstore.
  - All the patches are dropped and IUSE flags.
  - Configure steps is basically skipped - we provide our own
    generated files (Tools.mk and config.h), and we patch the build
    system to manually disable the warnings-as-errors flags.
  - Compilation and installation steps build and install only stuff
    related to xenstore.
- Adds support for arm64.
