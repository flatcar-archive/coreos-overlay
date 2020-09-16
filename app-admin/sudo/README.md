This is a fork of app-admin/sudo package from Gentoo. The reasons that
this package is in coreos-overlay are:

1. Dropping a dependency on Perl for LDAP since it seems like it was
   only pulled in for an optional script that is no longer present.

2. The schema files are dropped from the installation since our
   OpenLDAP package has USE=minimal which skips the schema directory.
   (It still installs a default config file in /etc, but it contains
   only comments since there are a few others like that already.)
