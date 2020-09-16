This is a package for amazon systems manager agent. It's a package
specific for Flatcar, thus not packaged by Gentoo. Updating the
package usually means updating the version in the ebuild filename to
one matching a release on https://github.com/aws/amazon-ssm-agent.

When updating, care should be taken to make sure that the build steps
in src_compile() match more or less actions done by upstream build
system, but without network access.
