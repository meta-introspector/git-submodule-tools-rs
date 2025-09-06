## `index_newer_files.sh`

**Summary:**
This script is responsible for indexing files that are newer than a previously recorded timestamp. It first ensures that the `crate_indexer` Rust binary is built. It then determines a `LAST_TIMESTAMP` by sourcing logic from `test.sh`. Files in the `/data/data/com.termux/files/home/storage/github/` directory that are newer than this timestamp are identified and their paths are saved to a timestamped `.txt` file. If no previous timestamp is found, all files are indexed. Finally, the `crate_indexer` binary is run with the list of identified files to generate a timestamped JSON output file containing the indexed data. The script supports a dry-run mode.
