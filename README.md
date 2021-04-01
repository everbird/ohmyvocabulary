# &#128214; oh-my-vocabulary

A lightweight personal vocabulary management tool taking the advantages of GoldenDict, Anki, and Dropbox.

## What problem does it solve? (aka. Motivation)

GoldenDict is an highly customizable dictionary lookup program. Anki is a powerful flashcard program. Both of them are great, but the experience of putting them together is meh :(

As a user of both, I would like to: 

1. Use **GoldenDict** to lookup a new word.
2. Import the new word into **Anki** automagically.
3. Mark the new word as known when learned in **Anki**.
4. Maintain a list of my "known" words for further usage.
5. Sync between devices (mbp, ubuntu@thinkpad, iOS etc.)

Furthermore, it would great if I can do above in a program-friendly, automatable way.

Unfortunatly, I didn't find an out-of-box solution to meet my needs yet. So I build it on my own :)


## How does it work?

### 1) Collect my lookup history from **GoldenDict**

A script `tosink` is configured in `Dictionaries->Sources->Programs` to be called when lookup a word. The word will be appended in `sink.txt`, which is a plain txt file managed in Dropbox.

### 2) Import new words from above into **Anki**

**ECDICT** is a well maintained open-source En-Zh dictionary. First, `omv` uses **mdict-utils** to extracts a sqlite database from the mdx file as cache to speedup query. Then it queries each words in `sink.txt`to get the HTML of paraphrases. Finally, **apy** is called to add a new `Note` to **Anki** for each word, with the word as front, and the HTML-format paraphrase as back.

### 3) Sync **Anki** to AnkiWeb
`omv` calls `apy sync` to do so. (Credits to **apy**)

### 4) Update the known.txt
When a word is learned, we manually mark it as "suspended" in **Anki** so that it won't show up in further reviews. `omv` calls `apy list` to get such "learned" word and append it to the known.txt, which is yet another plain txt file managed in Dropbox.

## Getting Started 

### Prerequisites
- A Unix-like operating system: macOS, Linux, BSD.
- `Anki` should be installed (it works with 2.1.42 as of March 2021)
- `GoldenDict` should be installed (it works with 1.5.0-RC2 as of March 2021)
- `git` should be installed
- `wget` should be installed
- `pyenv` is optional but recommended

### Installation

#### Hook in GoldenDict
Configure `tosink` in "Dictionaries->Sources->Programs" **GoldenDict**, such as:
```shell
/home/everbird/bin/tosink "%GDWORD%"
```
As of March 2021, `~` can not be expanded to user's home yet in **GoldenDict** so please use absolute path here.


#### Run Install

```shell
(optional)pyenv virtualenv 3.9.2 ohmyvocabulary-run
(optional)pyenv activate ohmyvocabulary-run
git clone https://github.com/everbird/ohmyvocabulary.git
cd ohmyvocabulary
make install
make fetch-and-init-db
cp ohmyvocabularyrc ~/.ohmyvocabularyrc
(modify .ohmyvocabularyrc to set your Anki base, profile, deck, and paths for sink.txt known.txt etc. managed in Dropbox)
(optional)pyenv deactivate 
```

#### Addtional Styling
To apply the css from **ECDICT**:

```shell
cat cache/concise-enhanced.css
```
Copy & paste the css to the styling of your Card Type.
(Find the styling editor at `Tools->Manage Note Types->Select default "Basic" and click "Cards..."->Styling`)

### Using Oh My Vocabulary

Run `omv`.

> ❯ pyenv activate ohmyvocabulary-run; omv; pyenv deactivate
> Checking dependencies ...
> mdict-utils       1.0.11
> apy               0.8.0
> ---===[oh-my-vocabulary]===---
> No new items in sink. Skipping ...
> No new learned update. Skipping ...
> Update learning ...
> done!


## FAQ

### Questoin: Why not use `~/.goldendict/history` instead of `sink.txt`?

**GoldenDict** doesn't follow symlink to write, but overwrite with a new file instead. That makes it difficult to sync via Dropbox.
