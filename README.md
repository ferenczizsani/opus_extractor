# OPUS Extractor

## Usage

This script extracts Finnish and Hungarian word pairs using the word alignments in OPUS (https://opus.nlpl.eu/).
To use the script, run:

```
bash process_opus.sh <OUTPUT_FOLDER>
```

where `<OUTPUT_FOLDER>` is the desired output path. In case it doesn't exists, the script creates the necessary folder.

The output file will be saved as `<OUTPUT_FOLDER>/opus_fi_hu.tsv`

In case the frequency of word pairs should be kept, please, run the following:

```
bash process_opus.sh <OUTPUT_FOLDER> true
```

or

```
bash process_opus.sh <OUTPUT_FOLDER> 1
```


## License

This work is licensed under the <a href="LICENSE">GNU AGPL v3.0 License</a>.
