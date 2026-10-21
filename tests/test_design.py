import inspect
import unittest
import numpy as np

from mapk_lab.experiment import choose_candidate, fixed_order, normalize_log_weights, run_policy, update_weights


class DesignTests(unittest.TestCase):
    def setUp(self):
        self.predictions = np.random.default_rng(3).normal(0, .2, (5, 18))

    def test_uniform_prior_and_known_gaussian_update(self):
        np.testing.assert_allclose(normalize_log_weights(np.zeros(2)), [.5, .5])
        weights = normalize_log_weights(update_weights(np.zeros(2), np.array([0., 1.]), 0., 1.))
        np.testing.assert_allclose(weights, np.array([1., np.exp(-.5)]) / (1 + np.exp(-.5)))

    def test_update_stable_for_large_residuals(self):
        result = normalize_log_weights(update_weights(np.zeros(2), np.array([0., 1.]), 100., .01))
        self.assertAlmostEqual(result.sum(), 1.)
        self.assertTrue(np.isfinite(result).all())

    def test_invalid_noise_and_shapes_fail(self):
        for sigma in (0, -1, float("nan")):
            with self.assertRaises(ValueError):
                update_weights(np.zeros(2), np.zeros(2), 0, sigma)
        with self.assertRaises(ValueError):
            update_weights(np.zeros(2), np.zeros(3), 0, 1.)

    def test_first_choices_shared_and_truth_unavailable(self):
        signature = set(inspect.signature(choose_candidate).parameters)
        self.assertFalse(signature & {"truth", "truth_id", "observed_pool", "evaluation"})
        for policy in ("fixed", "random", "variance_guided"):
            for weights in (np.ones(5) / 5, np.array([1., 0, 0, 0, 0])):
                self.assertEqual(choose_candidate(policy, self.predictions, weights, [], np.random.default_rng(2)), 0)
                self.assertEqual(choose_candidate(policy, self.predictions, weights, [0], np.random.default_rng(2)), 1)

    def test_future_outcomes_do_not_change_next_choice(self):
        pool_a = np.zeros(18)
        pool_b = pool_a.copy(); pool_b[2:] = 100.
        for policy in ("fixed", "random", "variance_guided"):
            a, _ = run_policy(self.predictions, pool_a, policy, .04, 2, (0, 2, 3))
            b, _ = run_policy(self.predictions, pool_b, policy, .04, 2, (0, 2, 3))
            self.assertEqual(a, b)

    def test_variance_criterion_and_observed_candidate_exclusion(self):
        predictions = np.array([[0., 0., 0., 0.], [0., 0., 1., 4.]])
        self.assertEqual(choose_candidate("variance_guided", predictions, np.array([.5, .5]), [0, 1], np.random.default_rng(2), 3), 3)
        with self.assertRaises(ValueError):
            choose_candidate("fixed", predictions, np.array([.5, .5]), [0, 0], np.random.default_rng(2), 3)

    def test_no_replacement_and_reproducible_policies(self):
        for policy in ("fixed", "random", "variance_guided"):
            a, snapshots = run_policy(self.predictions, np.zeros(18), policy, .04, 3)
            b, _ = run_policy(self.predictions, np.zeros(18), policy, .04, 3)
            self.assertEqual(a, b)
            self.assertEqual(len(set(a)), 12)
            for weights in snapshots.values():
                self.assertAlmostEqual(weights.sum(), 1.)
        self.assertEqual(len(set(fixed_order(72, 12))), 12)


if __name__ == "__main__":
    unittest.main()
