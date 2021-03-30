ECDICT ?= cache/ecdict-concise-enhanced.mdx

init-db: prepare
	mdict -x ${ECDICT} --exdb -d cache

prepare:
	mkdir -p cache

install:
	pip install -r requirements.txt
