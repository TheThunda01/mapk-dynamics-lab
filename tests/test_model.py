import json
from pathlib import Path
import shutil
import tempfile
import unittest
import xml.etree.ElementTree as ET

import numpy as np

from mapk_lab.model import ROOT, MATH, load_model, numerical_checks, evaluate_math, verify_sources


class ModelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.model = load_model()

    def test_source_hash_tampering_fails(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp)
            for item in (ROOT / "data").iterdir():
                if item.is_file():
                    shutil.copy(item, directory / item.name)
            (directory / "model.xml").write_bytes((directory / "model.xml").read_bytes() + b"\n")
            with self.assertRaisesRegex(ValueError, "integrity"):
                load_model(directory)

    def test_manifest_rejects_parent_path(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)
            manifest = json.loads((ROOT / "data/manifest.json").read_text())
            manifest["files"][0]["path"] = "../model.xml"
            (path / "manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "filenames"):
                verify_sources(path)

    def test_rates_match_source_mathml_across_valid_states(self):
        rng = np.random.default_rng(123)
        for _ in range(12):
            y = np.r_[rng.dirichlet([2, 2]) * 100, rng.dirichlet([2, 2, 2]) * 300,
                      rng.dirichlet([2, 2, 2]) * 300]
            for scale, ki in ((.7, 4.5), (1., 9.), (1.3, 13.5)):
                np.testing.assert_allclose(self.model.fluxes(y, scale, ki),
                                           self.model.source_fluxes(y, scale, ki), rtol=1e-13, atol=1e-13)

    def test_reduced_derivative_and_conservation(self):
        y = np.array([60., 40., 100., 80., 120., 140., 90., 70.])
        full = self.model.rhs(0, y, .9, 10.)
        reduced = self.model.reduced_rhs(0, y[[1, 3, 4, 6, 7]], .9, 10.)
        np.testing.assert_allclose(full[[1, 3, 4, 6, 7]], reduced)
        np.testing.assert_allclose([sum(full[:2]), sum(full[2:5]), sum(full[5:])], 0., atol=1e-14)

    def test_solver_checks_and_nonnegative_trajectory(self):
        checks, trajectory = numerical_checks(self.model, np.linspace(0, 1200, 25))
        self.assertTrue(checks["passed"])
        self.assertGreaterEqual(trajectory.min(), 0)
        self.assertLess(checks["conservation_max_abs"], 1e-8)

    def test_invalid_times_and_parameters(self):
        for times in ([0, 0], [-1, 2], [0, float("nan")], [2], [[0, 1]]):
            with self.assertRaises(ValueError):
                self.model.simulate(times)
        for scale, ki in ((0, 9), (1, -1), (float("inf"), 9)):
            with self.assertRaises(ValueError):
                self.model.simulate([0, 1], scale, ki)

    def test_mathml_unsupported_code_is_not_evaluated(self):
        expression = ET.fromstring(f'<math xmlns="{MATH[1:-1]}"><apply><sin/><cn>1</cn></apply></math>')
        with self.assertRaisesRegex(ValueError, "Unsupported"):
            evaluate_math(expression, {})


if __name__ == "__main__":
    unittest.main()
