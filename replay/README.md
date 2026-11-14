# Local 3D replay

This is the same viewer in both setups: Docker Compose exposes it at
http://localhost:3201/replay?task=MOT-E01, while native execution uses
http://localhost:3200/replay?task=MOT-E01. Choose one setup.

The viewer includes successful condition-0 reference display recordings for all
100 tasks and selected model-submission examples. `viewer/catalog.json`,
`viewer/tasks/`, `viewer/presentation/`, and `layouts/` contain the data used by
the viewer. A single replay does not establish success across every condition.
The viewer displays recorded states using partly schematic geometry; it does
not recompute physics or scores.

## Included recordings and raw traces

This package includes display recordings, case-level evaluation results, and
archived raw trace collections:

| Directory | Contents |
| --- | --- |
| `traces/reference/` | Reference-controller recordings for all 100 tasks, with source manifests |
| `traces/paper-samples/` | 19 selected model-execution recordings and their manifests |
| `traces/fixtures/` | Diagnostic recordings and test fixtures |

The raw collections preserve their original source metadata. They are archived
execution evidence, not newly computed results from the bundled runtime.
`verification/integrity.json` pins both raw and display files. The viewer plays
the adapted display data; raw recordings are provided for inspection and reuse.

New API generations are evaluated locally and adapted into a separate display
catalog under `outputs/generated/`. Refresh the viewer and select **My runs**
after successful adaptation. An invalid program without an executable trace has
no replay link. See the root README for generation commands.

New raw traces can be saved with `evaluator/evaluate.py --keep-traces` or
`scripts/export_replay_trace.py`. No model API request is needed to evaluate a
saved program. The original raw source collections are available for inspecting how the bundled
reference display recordings were produced.
