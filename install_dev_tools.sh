#!/bin/bash
sudo apt update
if command -v docker &> /dev/null; then 
echo "Docker is already installed" 
else 
echo "Installing Docker..."
sudo apt install -y docker.io 
echo "Docker installed successfully"
fi
if docker compose version &> /dev/null; then 
echo "Docker Compose is already installed" 
else 
echo "Installing Docker Compose..."
sudo apt install -y docker-compose-plugin
echo "Docker Compose installed successfully"
fi
if command -v python3 &> /dev/null; then 
echo "Python is already installed" 
else 
echo "Installing Python..."
sudo apt install -y python3
echo "Python installed successfully"
fi
if command -v pip3 &> /dev/null; then 
echo "pip is already installed" 
else 
echo "Installing pip..."
sudo apt install -y python3-pip
echo "pip installed successfully"
fi
if command -v django-admin &> /dev/null; then 
echo "Django is already installed" 
else 
echo "Installing Django..."
sudo apt install python3-django
echo "Django installed successfully"
fi

