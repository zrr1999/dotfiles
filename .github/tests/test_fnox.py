import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
MIGRATE = ROOT / ".local/bin/migrate-auto-token-to-fnox"


class FnoxMigrationTest(unittest.TestCase):
    def setUp(self):
        for name in ("fnox", "age-keygen", "zsh"):
            if shutil.which(name) is None:
                self.fail(f"Install {name} before running the migration tests.")
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.home = Path(self.temporary.name)
        self.source = self.home / ".config/auto-token/config.toml"
        self.tokens = self.source.parent / "tokens"
        self.tokens.mkdir(parents=True)
        self.source.write_text(f"token_dir = {json.dumps(str(self.tokens))}\n")
        self.destination = self.home / ".config/fnox"
        self.env = {
            "PATH": os.environ["PATH"],
            "HOME": str(self.home),
            "XDG_CONFIG_HOME": str(self.home / ".config"),
            "FNOX_CONFIG_DIR": str(self.destination),
        }

    def token(self, name, values, active=True):
        text = f"active = {'true' if active else 'false'}\n"
        for key, value in values.items():
            text += (
                f"\n[[envs]]\nname = {json.dumps(key)}\n"
                f'value = {json.dumps(value)}\ntype = "env"\n'
            )
        (self.tokens / f"{name}.toml").write_text(text)

    def migrate(self, mode="--apply"):
        return subprocess.run(
            [sys.executable, str(MIGRATE), mode, "--source", str(self.source)],
            env=self.env,
            capture_output=True,
            text=True,
            cwd=self.home,
        )

    def values(self, profile="default"):
        result = subprocess.run(
            ["fnox", "--profile", profile, "export", "--format", "json", "--all"],
            env=self.env,
            capture_output=True,
            text=True,
            cwd=self.home,
            check=True,
        )
        return json.loads(result.stdout)["secrets"]

    def test_roundtrip_preserves_values_and_disabled_profile(self):
        values = {"TEST_SECRET": "do-not-log-'quote'\"$;\n中文", "EMPTY_VALUE": ""}
        self.token("enabled", values)
        self.token("duplicate", {"TEST_SECRET": values["TEST_SECRET"]})
        self.token("base", {"AUTO_TOKEN_ENV_DIR": "/old/output"})
        self.token("disabled", {"DISABLED_SECRET": "disabled-test-value"}, active=False)
        original = {p: p.read_bytes() for p in self.source.parent.rglob("*.toml")}
        preview = self.migrate("--dry-run")
        self.assertEqual(preview.returncode, 0, preview.stderr)
        self.assertFalse(self.destination.exists())
        result = self.migrate()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.values(), values)
        self.assertEqual(
            self.values("disabled"), values | {"DISABLED_SECRET": "disabled-test-value"}
        )
        self.assertEqual(original, {p: p.read_bytes() for p in original})
        for secret in (values["TEST_SECRET"], "disabled-test-value"):
            self.assertNotIn(secret, result.stdout + result.stderr + preview.stdout)
            self.assertNotIn(secret, (self.destination / "config.toml").read_text())
        self.assertEqual(stat.S_IMODE(self.destination.stat().st_mode), 0o700)
        for name in ("config.toml", "age.txt"):
            self.assertEqual(
                stat.S_IMODE((self.destination / name).stat().st_mode), 0o600
            )

    def test_conflicting_values_stop_before_writing(self):
        self.token("one", {"SAME_KEY": "first-secret"})
        self.token("two", {"SAME_KEY": "different-secret"})
        result = self.migrate()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Conflicting values", result.stderr)
        self.assertNotIn("first-secret", result.stdout + result.stderr)
        self.assertNotIn("different-secret", result.stdout + result.stderr)
        self.assertFalse(self.destination.exists())

    def test_existing_key_is_never_overwritten(self):
        self.token("enabled", {"TEST_SECRET": "test-value"})
        self.destination.mkdir()
        key = self.destination / "age.txt"
        key.write_text("existing-key")
        result = self.migrate()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(key.read_text(), "existing-key")
        self.assertFalse((self.destination / "config.toml").exists())

    def test_repeated_apply_preserves_configuration(self):
        self.token("enabled", {"TEST_SECRET": "test-value"})
        first = self.migrate()
        self.assertEqual(first.returncode, 0, first.stderr)
        before = {p.name: p.read_bytes() for p in self.destination.iterdir()}
        result = self.migrate()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(
            before, {p.name: p.read_bytes() for p in self.destination.iterdir()}
        )

    def test_provider_failure_removes_partial_output_and_hides_diagnostics(self):
        self.token("enabled", {"TEST_SECRET": "test-value"})
        binaries = self.home / "bin"
        binaries.mkdir()
        fake = binaries / "fnox"
        fake.write_text(
            "#!/bin/sh\nprintf 'provider-leaked-secret'\n"
            "printf 'provider-leaked-secret' >&2\nexit 23\n"
        )
        fake.chmod(0o755)
        self.env["PATH"] = f"{binaries}:{self.env['PATH']}"
        result = self.migrate()
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("provider-leaked-secret", result.stdout + result.stderr)
        self.assertFalse(self.destination.exists())
        self.assertTrue((self.tokens / "enabled.toml").exists())

    def shell(self, command):
        zsh_dir = self.home / ".config/zsh"
        zsh_dir.mkdir(exist_ok=True)
        for name in (".zi.zsh", ".aliases.zsh", ".functions.zsh"):
            (zsh_dir / name).touch()
        shutil.copyfile(ROOT / ".zshrc", self.home / ".zshrc")
        return subprocess.run(
            ["zsh", "-d", "-i", "-c", command],
            env=self.env | {"ZDOTDIR": str(self.home), "DOTFILES_FASTFETCH": "0"},
            capture_output=True,
            text=True,
            cwd=self.home,
        )

    def test_shell_loads_immediately_and_restores_after_directory_change(self):
        self.token("enabled", {"TEST_SECRET": "global-test-value"})
        self.token("disabled", {"DISABLED_SECRET": "disabled-test-value"}, active=False)
        result = self.migrate()
        self.assertEqual(result.returncode, 0, result.stderr)
        project = self.home / "project"
        project.mkdir()
        (project / "fnox.toml").write_text(
            '[secrets]\nTEST_SECRET = { default = "project-test-value" }\n'
        )
        result = self.shell(
            '[[ "$TEST_SECRET" == global-test-value && -z "${DISABLED_SECRET+x}" ]] || exit 11; '
            'cd "$HOME/project"; [[ "$TEST_SECRET" == project-test-value ]] || exit 12; '
            'cd "$HOME"; [[ "$TEST_SECRET" == global-test-value ]] || exit 13'
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("global-test-value", result.stdout + result.stderr)

    def test_shell_starts_without_a_configuration(self):
        result = self.shell('[[ -z "${TEST_SECRET+x}" ]]')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.destination.exists())


if __name__ == "__main__":
    unittest.main()
