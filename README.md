# Mini Certificate Authority & HTTPS Setup

Cyber Security Lab (7CS4-22) mini project, B.Tech VII Semester, SKIT Jaipur (Session 2026-27)

- **Student:** Sanyam Singh, Roll No. 23ESKCS199, Batch CS-D-G1
- **Project code:** CSL-G47
- **Linked experiment:** Exp 8 - Secure Storage, Transmission & Digital Signature

## What this project does
Uses OpenSSL to:
1. create a **root Certificate Authority** (4096-bit RSA key encrypted with AES-256, self-signed X.509 certificate),
2. issue and **verify** an X.509 certificate for a web server (with a Subject Alternative Name for `localhost`),
3. enable **HTTPS (TLS 1.3)** on a local web server and test it from a client,
4. run **negative tests** (tampered, untrusted-CA and expired certificates).

There is no programming language involved: the project is a set of OpenSSL commands wrapped in small shell scripts.

## Requirements
- Linux, or Windows with WSL (Ubuntu), or macOS
- OpenSSL 3.x and curl (`openssl version`). On Ubuntu: `sudo apt update && sudo apt install openssl curl`

## How to install
```bash
git clone <this-repository-url>
cd mini-ca-https
```

## How to run
Run the scripts in order from inside the project folder. Use a passphrase you will remember (for example a test one); do not reuse a real password.

```bash
./01_create_root_ca.sh        # creates rootCA.key and rootCA.crt (asks for a passphrase)
./02_issue_server_cert.sh     # creates server.key, server.csr, server.crt (asks for the CA passphrase)
./03_run_https_server.sh      # starts https://localhost:8443 (leave this terminal open)
```
Open a **second terminal** in the same folder:
```bash
./04_test_client.sh           # curl without the CA (fails), with the CA (works), TLS handshake details
./05_negative_tests.sh        # tampered / untrusted / expired certificate tests (all should fail)
```
To see the padlock in a browser, import `rootCA.crt` as a trusted root authority and open `https://localhost:8443/index.html`.

## Expected results
| Test | Expected |
|---|---|
| `openssl verify -CAfile rootCA.crt server.crt` | `server.crt: OK` |
| `curl` without `--cacert` | error 60 / 20, unable to get local issuer certificate |
| `curl --cacert rootCA.crt` | page is shown |
| `openssl s_client` | TLSv1.3, `TLS_AES_256_GCM_SHA384`, `Verify return code: 0 (ok)` |
| tampered certificate | error 7, certificate signature failure |
| fake CA | error 20, unable to get local issuer certificate |
| expired (date 2030) | error 10, certificate has expired |

## Files
| File | Purpose |
|---|---|
| `server.ext` | certificate extensions (SAN, CA:FALSE, key usage) |
| `index.html` | test page served over HTTPS |
| `01`-`05_*.sh` | step-by-step scripts |
| `.gitignore` | keeps private keys out of the repository |

## Ethics and safety
All activity happens on `localhost` with test data only. Private keys (`*.key`) are generated locally and are never committed to GitHub.
