FROM python:3.12.4-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_APP=run.py

WORKDIR /app

RUN addgroup --system taskapp && adduser --system --ingroup taskapp taskapp

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

USER taskapp

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "4", "--timeout", "30", "--worker-tmp-dir", "/dev/shm", "run:app"]
