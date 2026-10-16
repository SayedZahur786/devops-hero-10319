# Session 17: Local DevSecOps scans

Mohd Jahur | Enrollment 10319

## Work and observations

1. I ran the course app tests and local security tools. The tests passed 8/8. I fixed debug mode and replaced random calls with secrets/SystemRandom, then reran the tests and Bandit.
2. The final Bandit scan reported no issues; pip-audit found no known vulnerabilities for requirements.txt; Gitleaks found no leaks. GitHub Actions, CodeQL, image build/push, container scan and Kubernetes deployment are not done for this session.

## Evidence

Fresh run on 9 October 2026 in a separate disposable lab. These are rendered views of actual captured command output, not live terminal screenshots. Raw logs are included so the text can be checked.

<!-- EVIDENCE -->

## Source changes
The Flask server defaults to loopback with debug disabled. Set HOST explicitly only for a disposable container/demo. Random demo selections now use secrets/SystemRandom. The UI pipeline endpoint simulates stages; it is not evidence of GitHub Actions execution. workflow-reference contains an unexecuted course template only and is not installed as a root workflow.

## Captured output files

- [requirements-dev.txt](requirements-dev.txt)
- [requirements.txt](requirements.txt)
- [sast-fixed-output.txt](sast-fixed-output.txt)
- [sast-output.txt](sast-output.txt)
- [sca-output.txt](sca-output.txt)
- [secret-scan-output.txt](secret-scan-output.txt)
- [tests-fixed-output.txt](tests-fixed-output.txt)
- [tests-output.txt](tests-output.txt)
- [tool-versions.txt](tool-versions.txt)

![Output of the command, captured from the lab run](images/sast-fixed-output-01.png)

![Output of the command, captured from the lab run](images/sca-output-01.png)

![Output of the command, captured from the lab run](images/secret-scan-output-01.png)

![Output of the command, captured from the lab run](images/tests-fixed-output-01.png)
