---
name: python-dev-style
description: Use this skill whenever Guillaume is writing, reviewing, refactoring, or debugging Python code, regardless of project context. Trigger on any Python task — writing new functions or modules, refactoring, reviewing diffs, fixing bugs, writing tests, setting up linting/formatting, or any code-quality discussion. Also trigger on PyCharm-specific questions (run configurations, inspections, type checker setup, debugger, pytest integration, coverage, scientific mode). The skill encodes Guillaume's Python conventions (PEP 8 + Google Style Guide, type hints everywhere, Google docstrings, black + ruff, pathlib over os.path), testing standards (pytest, fixtures, ~80% coverage, AAA pattern), and PyCharm Pro tips. Apply defaults silently — don't ask permission to use type hints or write docstrings, just do it. Do NOT use for non-Python languages or environment setup (use windows-dev-environment instead).
---

# Python Dev Style — Guillaume's Conventions

Code style, testing standards, and PyCharm Pro integration for Guillaume's Python work. Apply these as silent defaults — don't ask permission to add type hints or write docstrings, that's the baseline. Only deviate if Guillaume explicitly asks.

## Style baseline

**PEP 8 + Google Python Style Guide.** When they conflict, Google's stricter rule wins (Google = "PEP 8 plus opinions" in practice).

**Naming:**
- `snake_case` for functions, methods, variables, modules
- `PascalCase` for classes
- `UPPER_SNAKE_CASE` for module-level constants
- `_leading_underscore` for internal/private (Google: prefer single, never use double-underscore name mangling unless you really mean it)
- Module names short, all lowercase, no underscores when avoidable

**Line length:** 88 characters. This is `black`'s default — don't fight the formatter on PEP 8's 79 or Google's 80; the extra 8 chars meaningfully reduce wrapping in modern code with type hints.

**Imports:** three groups separated by blank lines, in order — stdlib, third-party, local. Alphabetize within each group. Always absolute imports (no `from .foo import bar` unless inside a package's `__init__.py`).

**Strings:** f-strings for interpolation. Never `.format()` or `%`. Triple-quoted for multi-line. Single quotes by default — `black` will normalize anyway, so don't waste energy on quote style.

**Paths:** `pathlib.Path` always, never `os.path`. `Path("foo") / "bar.txt"` reads better than `os.path.join("foo", "bar.txt")`.

## Type hints

**On every function signature.** Parameters AND return type. No exceptions for "obvious" cases — the parser doesn't care about obvious, and IDEs need them for inference.

```python
def parse_filename(path: Path) -> tuple[str, str]:
    """Split a filename into stem and extension."""
    return path.stem, path.suffix
```

**Modern syntax** (Python 3.10+):
- `list[int]` not `List[int]`
- `dict[str, Any]` not `Dict[str, Any]`
- `int | None` not `Optional[int]` or `Union[int, None]`
- Reserve `from typing import ...` for things stdlib generics don't cover (`Callable`, `TypeVar`, `Protocol`, `Literal`, `Final`).

**Variables:** annotate when the type isn't obvious from the assignment, especially for empty containers:

```python
results: list[dict[str, Any]] = []
cache: dict[str, Document] = {}
```

**`Any` is a smell.** Acceptable for incoming JSON or third-party APIs without stubs; otherwise narrow it.

## Docstrings — Google style, always

Every public function, class, and module gets a docstring. Private helpers (`_leading_underscore`) get one if non-obvious.

**Function template:**

```python
def convert_pdf(path: Path, *, force_ocr: bool = False) -> ConversionResult:
    """Convert a PDF to markdown using marker.

    Args:
        path: Path to the source PDF. Must exist and be readable.
        force_ocr: If True, run OCR even on text-extractable pages.
            Slower but produces consistent output for mixed PDFs.

    Returns:
        ConversionResult with markdown content, page count, and any
        warnings raised during conversion.

    Raises:
        FileNotFoundError: If `path` does not exist.
        ConversionError: If marker fails to process the document.
    """
```

**One-line docstring** acceptable for trivial functions:
```python
def to_kebab(s: str) -> str:
    """Convert snake_case or camelCase to kebab-case."""
```

**Class docstrings** describe what the class represents and any non-obvious initialization. Document attributes if they're not type-hinted in `__init__`.

## Tooling

| Tool | Purpose | Notes |
|---|---|---|
| `black` | Formatter | No config. Line length 88 (default). Run on save in PyCharm. |
| `ruff` | Linter (replaces flake8/pylint/isort) | Fast. Configures via `pyproject.toml`. |
| `mypy` | Type checker | Strict mode for new code. Tolerate gradual adoption in legacy code. |
| `pytest` | Test runner | See testing section below. |
| `pytest-cov` | Coverage | Target ~80% overall, 100% for pure-logic modules, untested CLI/IO is fine. |

**`pyproject.toml` skeleton** for new projects (suggest this when scaffolding):

```toml
[tool.black]
line-length = 88
target-version = ["py311"]

[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "C4", "SIM", "PL"]
ignore = ["PLR0913"]  # too many arguments — fine for data-class style

[tool.mypy]
python_version = "3.11"
strict = true
warn_unused_ignores = true

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --strict-markers --cov=src --cov-report=term-missing"
```

If `ruff` isn't available in the env, fall back to `flake8 + isort + pyupgrade` — same intent, more dependencies.

## Testing — pytest conventions

**pytest only, never unittest.** If editing legacy code that uses `unittest`, leave it alone unless asked to migrate.

**File layout:**
```
project/
├── src/
│   └── package_name/
│       └── module.py
└── tests/
    ├── conftest.py        # shared fixtures
    ├── test_module.py     # mirrors src/ structure
    └── unit/, integration/, e2e/  # only if test count justifies it
```

**Test naming:**
- File: `test_<module>.py`, mirrors source path
- Function: `test_<what_is_being_tested>_<condition>_<expected>`
  - Good: `test_parse_filename_with_no_extension_returns_empty_suffix`
  - Bad: `test_parse_filename_2`

**AAA structure** (Arrange / Act / Assert), separated by blank lines:

```python
def test_convert_pdf_with_password_protected_file_raises(tmp_path):
    """Encrypted PDFs without a password should fail loudly."""
    # Arrange
    encrypted = tmp_path / "secret.pdf"
    encrypted.write_bytes(make_encrypted_pdf())

    # Act / Assert
    with pytest.raises(ConversionError, match="encrypted"):
        convert_pdf(encrypted)
```

**Fixtures over setUp/tearDown.** Put shared fixtures in `conftest.py` (auto-discovered by pytest). Scope intentionally — `function` for state-mutating, `module` or `session` for expensive setup like loading models.

```python
# conftest.py
@pytest.fixture(scope="session")
def marker_models() -> MarkerModels:
    """Load marker models once for the entire test session."""
    return load_marker_models(device="cuda")

@pytest.fixture
def sample_pdf(tmp_path) -> Path:
    """Provide a small valid PDF in a temp directory."""
    path = tmp_path / "sample.pdf"
    path.write_bytes(SAMPLE_PDF_BYTES)
    return path
```

**Parametrize aggressively.** Don't write three near-identical test functions:

```python
@pytest.mark.parametrize("filename,expected_stem,expected_suffix", [
    ("doc.pdf", "doc", ".pdf"),
    ("archive.tar.gz", "archive.tar", ".gz"),
    ("noext", "noext", ""),
    (".hidden", ".hidden", ""),
])
def test_parse_filename(filename, expected_stem, expected_suffix):
    stem, suffix = parse_filename(Path(filename))
    assert stem == expected_stem
    assert suffix == expected_suffix
```

**Markers for slow/external tests:**
```python
@pytest.mark.slow      # skipped by default in dev, run in CI
@pytest.mark.gpu       # requires CUDA
@pytest.mark.network   # hits external APIs
```
Then `pytest -m "not slow"` for fast iteration locally.

**Mocking:** use `pytest-mock`'s `mocker` fixture, not `unittest.mock` directly. Mock at the boundary (HTTP calls, filesystem, time) — don't mock your own code unless you have a reason.

**Coverage targets:**
- ~80% overall — anything below is suspicious, anything chasing 100% is wasted effort
- 100% for pure logic (parsers, transformers, calculators) — no excuse there
- 0% acceptable for thin CLI wrappers, `__main__` blocks, simple I/O glue
- Use `# pragma: no cover` sparingly; comment why

## PyCharm Professional integration

Guillaume uses **PyCharm Pro**, so don't suggest workarounds for features that are first-class there.

**Run configurations:**
- Default to **pytest** as the test runner (Settings → Tools → Python Integrated Tools → Testing).
- For scripts that need `op run --env-file=op-env.txt`, configure as an **Shell Script** run config wrapping `op run -- python script.py`, OR set environment variables in the Python run config manually for development (less secure but faster iteration).
- Save run configs to the `.idea/runConfigurations/` folder and commit them — share with the laptop via git.

**Code quality:**
- Enable **black** as External Tool, set as "Format on save" via the BlackConnect plugin or PyCharm's built-in formatter integration.
- Enable **ruff** via the Ruff plugin (JetBrains marketplace) — runs as you type, surfaces in the same UI as PyCharm's own inspections.
- **mypy** via PyCharm's built-in type checker (Settings → Editor → Inspections → Python → Type checker). Set severity to Warning, not Error, to avoid noise on gradual typing.

**Useful Pro-only features to suggest when relevant:**
- **Scientific mode** for any data exploration in the marker pipeline (View → Scientific Mode). Variables panel + plot inline, much better than running the script repeatedly.
- **Database tool** for any DB work (Postgres, SQLite, etc.) — no need for a separate DBeaver/TablePlus.
- **Profiler** (Run → Profile) for the `cProfile`-style call graph. Use this before reaching for `line_profiler`.
- **Coverage view** (Run → Run with Coverage) — colors lines green/red in the editor based on test hits.
- **Endpoints tool** if any FastAPI/Flask work appears — auto-discovers routes.

**Things to avoid:**
- Don't suggest VS Code extensions or workflows unless Guillaume explicitly mentions VS Code.
- Don't suggest installing tools (`black`, `ruff`, `mypy`) globally — they go in the project's conda env, like everything else.

## Operating principles

1. **Apply defaults silently.** When writing new code, type hints + docstrings are baseline. Don't preface with "I'll add type hints since you mentioned PEP 8" — just do it.

2. **Match existing code in legacy contexts.** If editing a file that doesn't have type hints, don't unilaterally add them everywhere — that's a refactor, not an edit. Add hints to the function being modified, leave the rest, mention "I'd suggest adding hints to the rest of this module if you want a follow-up".

3. **Show, don't preach.** When suggesting a refactor for style, show the before/after, not a lecture about why. Guillaume already knows PEP 8.

4. **Push back when justified.** If a request would produce code that violates these conventions for no good reason ("can you use a global variable here?"), say why it's a bad idea before complying. Guillaume prefers honest disagreement.

5. **Reference specific tools and PyCharm features by name** when relevant. "Run with coverage in PyCharm to see the gaps" beats "you should check coverage." Specificity is helpful.
