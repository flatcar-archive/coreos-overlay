This is a fork of app-crypt/trousers package from Gentoo. The reasons
to carry it in overlay are:

1. Create and install system.data

  - It serves as a system persistent storage for tcsd.

  - I'm not sure it's correct, though. The original was a binary file
    with size 606, now it's a text file with "/" as its contents.

2. Systemd unit fixes:

  - Added condition for /dev/tpm0 to files.tscd.service and enable the
    service by default.

  - Regenerate tcsd.config and systemd.data through tmpfiles.

3. Drop openrc config and init files.
