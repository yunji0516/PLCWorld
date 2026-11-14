# PLCWorld model inputs

The model inputs contain one system instruction and 100 task prompts grouped
under `tasks/<suite>/<difficulty>/<task>/`.
`manifest.json` records the current prompt/specification hashes; `input-seal.json`
binds the packaged files. `../artifact.json` binds this input release to the
integrated evaluator.

The plain declaration skeleton gives I/O declarations, not a control algorithm,
internal state or hidden scenarios. `base_evaluator` and `base_input_sha256`
record historical input-authoring lineage, not a local path or an instruction
to run an older evaluator. Do not relabel archived outputs as newly generated.

Use `python3 scripts/generate_once.py` from the artifact root for one optional
API-backed generation. See `../README.md` for commands and evaluation scope.
