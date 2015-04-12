PROJECT = govmem

ERLC_OPTS ?= -Werror +debug_info +warn_export_vars +warn_shadow_vars +warn_obsolete_guard +{parse_transform,lager_transform}

DEPS = elli lager
dep_elli =  git https://github.com/knutin/elli master

PLT_APPS = ssl crypto compiler inets

include erlang.mk
