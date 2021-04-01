# &#128214; oh-my-vocabulary

An adapter to import your lookups from GoldenDict to Anki. It also exports your learned words to a plain text file managed by Dropbox.

## What problem does it solve?

[GoldenDict](http://goldendict.org/) is a customizable dictionary lookup program. [Anki](https://apps.ankiweb.net/) is a powerful flashcard program. Both of them are great, but the experience of putting them together is meh :(


As a user of both, I would like to: 

1. Use **GoldenDict** to look up a new word.
2. Import the new word into **Anki** automagically.
3. Mark the new word as known when learned in **Anki**.
4. Maintain a list of my "known" words for further usage.
5. Sync between devices (mbp, ubuntu@thinkpad, iOS, etc.)

Furthermore, it would great if I can do the above in a program-friendly, automatable way.

Unfortunately, I didn't find an out-of-box solution to meet my needs yet. So I build it on my own :)


## How does it work?

### 1) Collect my lookup history from **GoldenDict**

When you look up a word in GoldenDict, it runs a script named `tosink` with input `%GDWORD%` as this word. `tosink` is configured in `Dictionaries->Sources->Programs` beforehand. It appends this word in `sink.txt`, which is a plain text file managed in Dropbox.

### 2) Import new words from above into **Anki**

[**ECDICT**](https://github.com/skywind3000/ECDICT) is a well-maintained open-source En-Zh dictionary. First, `omv` uses [**mdict-utils**](https://github.com/liuyug/mdict-utils) to extracts an SQLite database from the mdx file as a cache to speed up the query. Then it queries each word in the `sink.txt`to get the HTML of paraphrases. Finally, `omv` calls [**apy**](https://github.com/lervag/apy) to add a new `Note` to **Anki** for each word. The `Note` uses the word as the front and the HTML-format paraphrase as the back.

### 3) Sync **Anki** to AnkiWeb
`omv` calls `apy sync` to do so. (Credits to **apy**)

### 4) Update the known.txt
For a learned word, you can mark it as "suspended" in **Anki** so that it won't show up in further reviews. `omv` calls `apy list` to get such words. It appends these words to the known.txt, which is yet another plain text file managed in Dropbox.

## Getting Started 

### Prerequisites
- A Unix-like operating system: macOS, Linux, BSD.
- `Anki` should be installed (2.1.42 as of March 2021)
- `GoldenDict` should be installed (1.5.0-RC2 as of March 2021)
- `git` should be installed
- `wget` should be installed
- `pyenv` is optional but recommended

### Installation

#### Hook in GoldenDict
Configure `tosink` in "Dictionaries->Sources->Programs" **GoldenDict**, such as:
```bash
/home/everbird/bin/tosink "%GDWORD%"
```
So far `~` can not be expanded to the user's home yet in **GoldenDict**. Please use an absolute path here.


#### Run Install

```bash
pyenv virtualenv 3.9.2 ohmyvocabulary-run  # optional
pyenv activate ohmyvocabulary-run  # optional
git clone https://github.com/everbird/ohmyvocabulary.git
cd ohmyvocabulary
make install
make fetch-and-init-db
cp ohmyvocabularyrc ~/.ohmyvocabularyrc
# Change .ohmyvocabularyrc to set your Anki base, profile, deck, and paths for *.txt, etc.
pyenv deactivate  # optional
```

#### Addtional Styling
To apply the styling from **ECDICT**, you can get the css below:

```shell
cat cache/concise-enhanced.css
```
Copy & paste the css to the Styling of your Card Type.
(Find the Styling editor at `Tools->Manage Note Types->Select default "Basic" and click "Cards..."->Styling`)

### Using Oh My Vocabulary

Close your **Anki** to avoid the SQLite database lock first. Let's lookup a word in **GoldenDict**. Ensure the word appears in the `sink.txt`.
``` bash
cat ~/Dropbox/vocabulary/sink.txt
# Output:
# invincible
```

Run `omv` (I use pyenv so I wraps the `omv` with virtualenv activate/deactivate as below)
```bash
pyenv activate ohmyvocabulary-run; omv; pyenv deactivate
# Output:
# Checking dependencies ...
#   mdict-utils       1.0.11
# apy               0.8.0
# ---===[oh-my-vocabulary]===---
# Database was modified.
# Remember to sync!
# Syncing deck ... done!
# Syncing media ... done!
# No new learned update. Skipping ...
# Update learning ...
# done!
```

Check your **Anki** and browse your target deck. The new word is imported with decent paraphrase.

![image](https://live.staticflickr.com/65535/51084303298_52027143cf_b.jpg)

## FAQ

### Q: Why not use `~/.goldendict/history` instead of `sink.txt`?

**GoldenDict** doesn't follow symlink to write but overwrite with a new file instead. That makes it hard to sync via Dropbox.
