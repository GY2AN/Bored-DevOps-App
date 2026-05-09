# DevOps CI/CD Pipeline Project

A production-style CI/CD pipeline built with **Python Flask**, **Docker**, and **GitHub Actions**. Every push to `main` automatically runs tests, builds a Docker image, pushes it to Docker Hub, and simulates a zero-downtime deployment — no manual steps required.

---

## Architecture

```
Developer → GitHub Push
               │
               ▼
        GitHub Actions
               │
       ┌───────┴────────┐
       ▼                ▼
   Run Tests        (on fail → stop)
       │
       ▼ (on pass)
  Docker Build
  & Push to Hub
       │
       ▼
    Deploy
  (docker pull + run)
       │
       ▼
   Live App ✓
```

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| Python + Flask | Web application |
| pytest | Automated testing |
| Docker | Containerisation |
| Docker Hub | Container registry |
| GitHub Actions | CI/CD automation |

---

## Project Structure

```
devops-pipeline-project/
├── app.py                        # Flask web application
├── test_app.py                   # pytest test suite
├── requirements.txt              # Python dependencies
├── Dockerfile                    # Container build instructions
└── .github/
    └── workflows/
        └── ci-cd.yml             # GitHub Actions pipeline
```

---

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed locally
- A [GitHub](https://github.com) account
- A [Docker Hub](https://hub.docker.com) account

### Run Locally

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/devops-pipeline-project.git
cd devops-pipeline-project

# Install dependencies
pip install -r requirements.txt

# Run tests
pytest test_app.py -v

# Build and run the Docker container
docker build -t devops-app:local .
docker run -p 5000:5000 devops-app:local
```

The app will be live at `http://localhost:5000`.

### API Endpoints

| Endpoint | Method | Response |
|----------|--------|----------|
| `/` | GET | App info and version |
| `/health` | GET | Health check — returns `{"status": "healthy"}` |

---

## CI/CD Pipeline

The pipeline is defined in `.github/workflows/ci-cd.yml` and runs automatically on every push to `main` or on any pull request.

### Pipeline Stages

**1. Test**
Spins up a clean Ubuntu VM, installs dependencies, and runs the full pytest suite. If any test fails, the pipeline stops here — nothing gets built or deployed.

**2. Build & Push**
Builds the Docker image and pushes two tags to Docker Hub:
- `latest` — always points to the most recent successful build
- `<git-sha>` — a pinned tag for traceability (e.g. `devops-app:a3f92c1`)

**3. Deploy**
Pulls the new image and runs it. In this project the deploy step is simulated with `echo` commands; in a production setup this would SSH into a remote server.

### Setting Up Secrets

The pipeline requires two GitHub repository secrets:

1. Go to your repo → **Settings → Secrets and variables → Actions**
2. Add the following:

| Secret | Value |
|--------|-------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | A Docker Hub access token (Account Settings → Security → New Access Token) |

---

## Docker

### Build the Image

```bash
docker build -t devops-app:local .
```

### Run the Container

```bash
docker run -d -p 5000:5000 --name devops-app devops-app:local
```

### Stop the Container

```bash
docker stop devops-app && docker rm devops-app
```

### Pull from Docker Hub

```bash
docker pull YOUR_USERNAME/devops-app:latest
```

---

## Running Tests

```bash
# Run all tests with verbose output
pytest test_app.py -v

# Run a specific test
pytest test_app.py::test_health_endpoint -v
```

The test suite covers:
- `GET /` returns HTTP 200
- `GET /` response body contains a `message` field
- `GET /health` returns HTTP 200 with `{"status": "healthy"}`

---

## Key DevOps Concepts Demonstrated

**Containerisation** — the app runs identically on a developer laptop, the CI runner, and a production server. No "works on my machine" problems.

**Pipeline as code** — the entire CI/CD process lives in a YAML file, version-controlled alongside the application code.

**Fail fast** — the `needs:` dependency in GitHub Actions ensures Docker builds never start if tests fail, preventing broken code from reaching the registry.

**Immutable artefacts** — each build is tagged with its git commit SHA, so you can always trace exactly which code version is running in any environment.

**Secrets management** — credentials are stored in GitHub Secrets and injected at runtime, never hardcoded in source code.

---

## Extending This Project

Ideas to take this further:

- **Docker Compose** — add a database service (e.g. PostgreSQL) and wire it to Flask
- **Nginx reverse proxy** — put Nginx in front of Flask for SSL termination and load balancing
- **Real deployment** — replace the simulated deploy step with an SSH action targeting an AWS EC2 or DigitalOcean Droplet
- **Monitoring** — add Prometheus metrics to Flask and visualise them in Grafana
- **Multi-environment pipeline** — add separate `staging` and `production` deployment jobs

---

## License

MIT — feel free to use this as a template for your own projects.