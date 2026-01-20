import unittest
import os
import strutils
from ../src/qax_utils import secureJoin, getID, readArtifact, QiimeArtifact

suite "qax_utils tests":
  test "secureJoin should prevent path traversal":
    # Test case 1: Path traversal with absolute path
    var caughtError = false
    try:
      discard secureJoin("/tmp", "../../../etc/passwd")
    except ValueError:
      caughtError = true
    check caughtError == true

    # Test case 2: Path traversal with relative path
    caughtError = false
    try:
      discard secureJoin("/tmp", "a/b/../../c/../../../d")
    except ValueError:
      caughtError = true
    check caughtError == true

    # Test case 3: Valid path
    caughtError = false
    try:
      discard secureJoin("/tmp", "a/b/c")
    except ValueError:
      caughtError = true
    check caughtError == false
    check secureJoin("/tmp", "a/b/c") == "/tmp/a/b/c".replace('/', os.DirSep)

  test "getID should return the UUID of a valid artifact":
    let artifactPath = "input/rep-seqs.qza"
    if fileExists(artifactPath):
      let uuid = getID(artifactPath)
      check uuid.len == 36

  test "readArtifact should correctly parse a valid artifact":
    let artifactPath = "input/rep-seqs.qza"
    if fileExists(artifactPath):
      let artifact = readArtifact(artifactPath)
      check artifact.uuid.len == 36
      check artifact.artifacttype == "FeatureData[Sequence]"

