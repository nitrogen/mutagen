.PHONY: test

all: rebar3 compile

# Check if rebar3.mk exists, and if not, download it
 ifeq ("$(wildcard rebar3.mk)","")
 $(shell curl -O https://raw.githubusercontent.com/choptastic/rebar3.mk/master/rebar3.mk)
 endif
# rebar3.mk adds a new rebar3 rule to your Makefile
# (see https://github.com/choptastic/rebar3.mk) for full info
include rebar3.mk

CWD=$(shell pwd)
NAME=$(shell basename ${CWD})
CT_LOG=${APP_DIR}/logs
REBAR?=${CWD}/rebar3
COOKIE?=cookie_${NAME}
ERL?=/usr/bin/env erl
ERLARGS=-pa ebin -smp enable -name ${NODE} \
	-setcookie ${COOKIE} -boot start_sasl


# Clean all.
clean: rebar3
	@${REBAR} clean

# Gets dependencies.
get-deps: rebar3
	@${REBAR} get-deps

# Compiles.
compile: rebar3
	@${REBAR} compile

run: rebar3
	$(REBAR) shell

test: rebar3
	$(REBAR) ct

#benchmark:
#	${ERL} ${ERLARGS} +P 60000000 -eval "application:start(nitro_cache)" -eval "nitro_cache:benchmark(1000)"

# This one runs without a release.
shell: compile
	${ERL} ${ERLARGS}

dialyzer: rebar3
	$(REBAR) dialyzer

publish:
	$(REBAR) hex publish

