include ../../../config.mk

#==============================================================================
# Specific variables
#==============================================================================
SHELL=/bin/bash

#==============================================================================
# Targets
#==============================================================================


# Using following targets requires artifact of a "pages" stage
# it means a "public" dir unzipped in PF root

.PHONY: all
all: test-pfcen7dev-dev test-pfdeb9dev-dev test-pfcen7dev-release test-pfdeb9dev-release

### Targets used in pipeline
.PHONY: test
test: clean
	./vagrant-wrapper.sh run

.PHONY: clean
clean:
	./vagrant-wrapper.sh teardown

### Targets used for local tests
# test
.PHONY: test-pfcen7dev-dev
test-pfcen7dev-dev:
	make PF_VM_NAME=pfcen7dev \
	PERL_UNIT_TESTS=yes \
	GOLANG_UNIT_TESTS=yes \
	test

.PHONY: test-pfdeb9dev-dev
test-pfdeb9dev-dev:
	make PF_VM_NAME=pfdeb9dev \
	PERL_UNIT_TESTS=no \
	GOLANG_UNIT_TESTS=yes \
	test

.PHONY: test-pfcen7dev-release
test-pfcen7dev-release:
	make PF_VM_NAME=pfcen7dev \
	CI_COMMIT_TAG=vX.Y.Z \
	test

.PHONY: test-pfdeb9dev-release
test-pfdeb9dev-release:
	make PF_VM_NAME=pfdeb9dev \
	CI_COMMIT_TAG=vX.Y.Z \
	test

.PHONY: test-int-pfcen7dev-dev
test-int-pfcen7dev-dev:
	make PF_VM_NAME=pfcen7dev \
	INT_TEST_VM_NAMES='ad switch01 node01' \
	PERL_UNIT_TESTS=yes \
	GOLANG_UNIT_TESTS=yes \
	INTEGRATION_TESTS=yes \
	test

.PHONY: test-int-pfdeb9dev-dev
test-int-pfdeb9dev-dev:
	make PF_VM_NAME=pfdeb9dev \
	INT_TEST_VM_NAMES='ad switch01 node01' \
	PERL_UNIT_TESTS=no \
	GOLANG_UNIT_TESTS=yes \
	INTEGRATION_TESTS=yes \
	test
