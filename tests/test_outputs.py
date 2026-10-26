import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

import pandas as pd

from mapk_lab.model import ROOT

spec = importlib.util.spec_from_file_location("verification", ROOT / "scripts/verify_results.py")
verification = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verification)


class OutputTests(unittest.TestCase):
    def test_report_is_utf8_with_a_legacy_default_encoding(self):
        from mapk_lab.experiment import report

        summary = pd.read_csv(ROOT / "results/summary.csv")
        stress_summary = pd.read_csv(ROOT / "results/stress_summary.csv")
        checks = json.loads((ROOT / "results/solver_checks.json").read_text(encoding="utf-8"))
        with tempfile.TemporaryDirectory() as temp:
            out = Path(temp)
            with patch("io.text_encoding", side_effect=lambda encoding, stacklevel=2: encoding or "cp1252"):
                report(out, summary, checks, 20, 49, stress_summary)
            self.assertIn("3650–4000", (out / "report.md").read_text(encoding="utf-8"))

    def test_committed_results_pass_independent_replay(self):
        result = verification.verify()
        self.assertTrue(result["passed"])
        self.assertEqual(result["matched_trials"], 360)
        self.assertEqual(result["stress_trials"], 108)

    def test_hash_and_recomputed_metric_detect_tampering(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp)
            # Copy fixtures so tampering checks also run without symlink privileges.
            for path in (ROOT / "results").iterdir():
                if path.is_file():
                    shutil.copy2(path, directory / path.name)
            target = directory / "trials.csv"
            original = target.read_bytes()
            target.unlink()
            frame = pd.read_csv(ROOT / "results/trials.csv")
            frame.loc[0, "prediction_rmse"] += 1
            frame.to_csv(target, index=False)
            with self.assertRaisesRegex(ValueError, "hash mismatch"):
                verification.verify(directory)
            manifest = json.loads((directory / "run_manifest.json").read_text())
            manifest["artifacts_sha256"]["trials.csv"] = hashlib.sha256(target.read_bytes()).hexdigest()
            (directory / "run_manifest.json").unlink()
            (directory / "run_manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "Metric mismatch"):
                verification.verify(directory)

    def test_missing_posterior_row_detected_even_with_updated_hash(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp)
            for path in (ROOT / "results").iterdir():
                if path.is_file():
                    shutil.copy2(path, directory / path.name)
            target = directory / "posterior_weights.csv"
            target.unlink()
            pd.read_csv(ROOT / "results/posterior_weights.csv").iloc[1:].to_csv(target, index=False)
            manifest = json.loads((directory / "run_manifest.json").read_text())
            manifest["artifacts_sha256"][target.name] = hashlib.sha256(target.read_bytes()).hexdigest()
            (directory / "run_manifest.json").unlink()
            (directory / "run_manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "Incomplete posterior"):
                verification.verify(directory)

    def test_fractional_candidate_id_rejected_after_rehash(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp)
            for path in (ROOT / "results").iterdir():
                if path.is_file():
                    shutil.copy2(path, directory / path.name)
            target = directory / "selection_log.csv"
            target.unlink()
            frame = pd.read_csv(ROOT / "results/selection_log.csv")
            frame["candidate_id"] = frame.candidate_id.astype(float)
            frame.loc[2, "candidate_id"] += .2
            frame.to_csv(target, index=False)
            manifest = json.loads((directory / "run_manifest.json").read_text())
            manifest["artifacts_sha256"][target.name] = hashlib.sha256(target.read_bytes()).hexdigest()
            (directory / "run_manifest.json").unlink()
            (directory / "run_manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "Noninteger identity"):
                verification.verify(directory)


if __name__ == "__main__":
    unittest.main()
