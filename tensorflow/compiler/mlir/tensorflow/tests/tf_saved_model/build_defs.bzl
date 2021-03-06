"""SavedModel testing harness macros."""

load("//tensorflow/compiler/mlir:glob_lit_test.bzl", "lit_test")

def tf_saved_model_test(name, data):
    """Create a SavedModel test."""
    native.py_binary(
        name = name,
        testonly = 1,
        python_version = "PY3",
        srcs = [name + ".py"],
        deps = [
            "//tensorflow/compiler/mlir/tensorflow/tests/tf_saved_model:common",
        ],
    )

    # We use the lit_test macro for each individual test
    # (rather than glob_lit_tests for all tests) because each individual
    # py_binary is actually quite a large file, so we want fine-grained data deps.
    # With glob_lit_tests, we would need to feed in all the py_binary's into each test,
    # which would hit total file size limits for individual test invocations.
    lit_test(
        name = name + ".py",
        data = [name] + data,
        # TODO(b/146012975): PY3 reports ASAN leaks, while PY2 doesn't, disable
        # until resolved as the leak reports is not specific to these.
        tags = ["noasan"],
        driver = "@local_config_mlir//:run_lit.sh",
    )
