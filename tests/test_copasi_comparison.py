"""Failure-sensitive checks that do not require the optional COPASI binary."""
import unittest
from pathlib import Path
import tempfile
import numpy as np
from scripts.compare_copasi import ROOT, compare, compare_arrays


class CrossEngineChecks(unittest.TestCase):
    def setUp(self):
        self.baseline = np.array([[0,90,10,280,10,10,280,10,10],
                                  [50,80,20,260,25,15,250,30,20]], dtype=float)

    def test_matching_trajectories_pass(self):
        self.assertTrue(compare_arrays(self.baseline, self.baseline.copy())['passed'])

    def test_conservation_preserving_disagreement_fails(self):
        candidate = self.baseline.copy()
        candidate[1,1] += .01
        candidate[1,2] -= .01
        result = compare_arrays(self.baseline, candidate)
        self.assertEqual(result['conservation_max_absolute_difference_nM'], 0)
        self.assertFalse(result['passed'])

    def test_small_but_nonconserving_error_fails(self):
        candidate = self.baseline.copy()
        candidate[1,1] += .0001
        self.assertFalse(compare_arrays(self.baseline, candidate)['passed'])

    def test_wrong_time_grid_or_nonfinite_values_fail(self):
        for change in ('time', 'nan'):
            candidate = self.baseline.copy()
            candidate[1,0 if change == 'time' else 1] = 51 if change == 'time' else np.nan
            with self.assertRaises(ValueError):
                compare_arrays(self.baseline, candidate)

    def test_changed_initial_state_fails(self):
        candidate = self.baseline.copy()
        candidate[0,1] += 1e-6
        candidate[0,2] -= 1e-6
        self.assertFalse(compare_arrays(self.baseline, candidate)['passed'])

    def test_existing_output_is_preserved_without_running_copasi(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)
            marker = path / 'baseline.cps'
            marker.write_bytes(b'preserve this existing model')
            with self.assertRaisesRegex(ValueError, 'already exists'):
                compare('not-an-executable', path)
            self.assertEqual(marker.read_bytes(), b'preserve this existing model')

    def test_source_and_result_subtrees_are_rejected(self):
        for path in (ROOT, ROOT/'data/new-model', ROOT/'results/new-comparison'):
            with self.subTest(path=path), self.assertRaisesRegex(ValueError, 'outside source'):
                compare('not-an-executable', path)


if __name__ == '__main__':
    unittest.main()
