# TaskApp Backend

Flask API for TaskApp.

## Production Behavior

- The app does not create or migrate tables during web process startup.
- Schema changes run through `flask db upgrade`.
- Optional demo users are seeded through `flask seed-default-users` only when `TASKAPP_SEED_DEFAULT_USERS=true`.
- Kubernetes probes use `GET /api/health`.
- Production runtime is Gunicorn through the Dockerfile.

## Required Environment

- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_NAME`
- `DATABASE_USER`
- `DATABASE_PASSWORD`
- `SECRET_KEY`

Optional seed variables:

- `TASKAPP_SEED_DEFAULT_USERS`
- `TASKAPP_ADMIN_USERNAME`
- `TASKAPP_ADMIN_PASSWORD`
- `TASKAPP_DEMO_USERNAME`
- `TASKAPP_DEMO_PASSWORD`

Secret values must come from the deployment environment or External Secrets, not git.

## Local Commands

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
flask db upgrade
flask run
```
