ECDICT ?= cache/ecdict-concise-enhanced.mdx

init-db: prepare
	mdict -x ${ECDICT} --exdb -d cache

prepare:
	mkdir -p cache

install:
	pip3 install -r requirements.txt
