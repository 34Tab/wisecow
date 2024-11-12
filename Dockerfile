FROM python:3.9-slim

WORKDIR /app

COPY wisecow.py .

CMD ["python", "wisecow.py"]
