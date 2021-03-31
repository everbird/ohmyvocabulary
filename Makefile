ECDICT ?= cache/ecdict-concise-enhanced.mdx

init-db: prepare
	mdict -x ${ECDICT} --exdb -d cache

prepare:
	mkdir -p cache

install:
	pip3 install -r requirements.txt

fetch-ecdict: prepare
	wget -O cache/ecdict.zip https://github.com/skywind3000/ECDICT/releases/download/1.0.28/ecdict-mdx-style-28.zip

unpack-ecdict:
	unzip cache/ecdict.zip -d cache
	mv cache/concise-enhanced.mdx cache/ecdict-concise-enhanced.mdx

clean-ecdict:
	rm cache/ecdict.zip
	rm cache/ecdict-concise-enhanced.mdx

fetch-and-init-db: fetch-ecdict unpack-ecdict init-db clean-ecdict
