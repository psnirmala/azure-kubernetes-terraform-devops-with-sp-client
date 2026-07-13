# Step 1: Use an official lightweight Python runtime as a base image
FROM python:3.11-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy only requirements first to leverage Docker cache layers
COPY requirements.txt .

# Step 4: Install the application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy the rest of the application code into the container
COPY . .

# Step 6: Document that the container listens on port 5000
EXPOSE 5000

# Step 7: Define the command execution parameter when the container launches
CMD ["python", "app.py"]
