FROM python:3.10-slim

WORKDIR /app

# Instalar dependências de sistema, ferramentas de compilação e libs de desenvolvimento do Postgres e MySQL
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    g++ \
    libffi-dev \
    libssl-dev \
    git \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Atualizar o pip, setuptools e wheel
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Copiar e instalar os requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o código fonte
COPY . /app