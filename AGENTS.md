# AGENTS.md

- Treat `$HOME` as the real system being managed. This repository is only one source of truth for files in that system.
- Prefer editing managed sources over patching ad hoc runtime copies.
- Keep changes small, reversible, and aligned with existing workflows.
- Put recurring validation in `prek`; avoid heavy automation unless explicitly requested.
- Use extra caution around shell startup, bootstrap hooks, SSH, GPG, credentials, DNS, and machine-specific inventory.
- Do not silently broaden privileges, rewrite trust settings, delete user data, or generalize this environment into a public template.
- Keep this file short and global: it describes how agents should treat the managed home directory, not a catalog of repo contents.
- Prefer `uvx`-backed aliases for `prek`, `ty`, and `ruff` when matching this environment.
- Default interactive Git usage to gitoxide via `gix`; when classic Git is required inside aliases or functions, call `command git`.
