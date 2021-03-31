# oh-my-vocabulary

A lightweight personal vocabulary management tool taking the advantages of GoldenDict, Anki, and Dropbox.

## What problem does it solve? (aka. Motivation)

GoldenDict is an highly customizable dictionary lookup program. Anki is a powerful flashcard program. Both of them are great, but the experience of putting them together is meh :(

As a user of both, I would like to: 

1. Collect my lookup history from **GoldenDict**.
2. Import new words from above into **Anki**, with decent paraphrases and error handling.
3. Mark a word as "known" in **Anki**, which means it won't show up when reviewing in **Anki**
4. Export known words from **Anki** to a "known" list.
5. Maintain a list of my known words. (So that my other scripts can read it for further usage, such as filtering an article for new words before reading it)
6. Do above in a program-friendly, automatable way.
7. Sync between devices.

Unfortunatly, I didn't find an out-of-box solution to meet my needs yet. So I build it on my own :)


## How does it work?

1. A script `tosink` will be called when lookup in **GoldenDict**. The word will be appended in `sink.txt`, which is a plain txt file in Dropbox.
2. **ECDICT** is a well maintained open-source En-Zh dictionary. **mdict-utils** extracts a sqlite database from the mdx file as cache to speedup query, and query each words in `sink.txt`to get the HTML of paraphrases.
3. **apy** is the best cli to manage Anki I can find so far. It adds new `Note` to **Anki** with the lookup word as front and the HTML-format paraphrase as back.

TBD

### Questoin: Why not use `~/.goldendict/history` instead of `sink.txt`?

It doesn't follow symlink to write, but overwrite with a new file instead. That makes it difficult to sync via Dropbox.
One command `omv` to import the **GoldenDict** lookup history into **Anki** with paraphrases from**ECDICT**, and then export 

## Install

TBD

## Usage

TBD
