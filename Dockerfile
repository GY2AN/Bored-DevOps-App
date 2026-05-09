# Base image — slim Python to keep the image small
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy requirements FIRST (Docker layer caching trick)
# If requirements.txt hasn't changed, Docker skips the pip install step
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Now copy the rest of your code
COPY . .

# Tell Docker which port the app uses (documentation + networking)
EXPOSE 5000

# The command that runs when the container starts
CMD ["python", "app.py"]