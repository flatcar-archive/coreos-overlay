This package provides a wrapper for kubelet - it launches kubelet
inside a rkt container. The reason this package is in coreos-overlay
is that this package is specific to Flatcar. There is not much of a
reason to update this package other than fixes in the wrapper script
or in recipes. The updates seem to happen through the
quay.io/coreos/hyperkube docker package. Which seems to be quite old.
