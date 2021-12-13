FROM python:3.9.7
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# CMD ["gunicorn ", "-w", "4", "-k",  "uvicorn.workers.UvicornWorker", "app.main:app", "--bind",  "0.0.0.0:8000"]

