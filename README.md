# OPUS Extractor

## Usage

This script extracts Finnish and Hungarian word pairs using the word alignments in OPUS (https://opus.nlpl.eu/).
To use the script, run:

```bash process_opus.sh <OUTPUT_FOLDER>```

where <OUTPUT_FOLDER> is the desired output path. In case it doesn't exists, the script creates the necessary folder.

The output file will be saved as `<OUTPUT_FOLDER>/opus_fi_hu.tsv`
