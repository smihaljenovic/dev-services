# Dev Services

A comprehensive Docker Compose setup providing essential development services including databases, caching, search engines, and admin interfaces. All services are pre-configured with sensible defaults for local development.

## 🚀 Services Overview

### Active Services

| Service           | Version             | Port(s)        | Purpose                            |
| ----------------- | ------------------- | -------------- | ---------------------------------- |
| **nginx**         | 1.28.1-alpine3.23   | 8000           | Web server and reverse proxy       |
| **MySQL**         | 8.0.41              | 3306           | Relational database                |
| **phpMyAdmin**    | 5.2.3               | via nginx:8000 | MySQL web interface                |
| **Adminer**       | 5.4.1               | via nginx:8000 | Universal database management tool |
| **Redis**         | 8.4.0-alpine        | 6379           | In-memory data store and cache     |
| **PostgreSQL**    | 17.2-alpine         | 5432           | Advanced relational database       |
| **pgAdmin**       | 9.11                | via nginx:8000 | PostgreSQL web interface           |
| **MongoDB**       | 8.0                 | 27017          | NoSQL document database            |
| **Mongo Express** | 1.0.2-20-alpine3.19 | via nginx:8000 | MongoDB web interface              |
| **Elasticsearch** | 9.2.4               | 9200, 9300     | Search and analytics engine        |
| **Kibana**        | 9.2.4               | 5601           | Elasticsearch visualization        |

## 📋 Prerequisites

- Docker Engine 20.10+
- Docker Compose V2+
- At least 8GB RAM available for Docker
- Ports 80, 3306, 5432, 6379, 8000, 8080, 9200, 27017 available

## 🎯 Running Instructions

### Scenario 1: Start All Services (Fresh Start)

Start all services defined in docker-compose.yml:

```bash
# Start all services in detached mode (background)
docker compose up -d

# Verify all services are running
docker compose ps

# Check health status
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

**What happens:**
- All 11 services will start
- Docker will pull images if not already downloaded
- Volumes will be created for data persistence
- Health checks will run to verify service readiness

---

### Scenario 2: Start Specific Services Only

Run only the services you need for your current work:

```bash
# Example 1: Start only MySQL and its admin interface
docker compose up -d mysql_dev phpmyadmin_dev

# Example 2: Start database services only (no admin interfaces)
docker compose up -d mysql_dev postgres_dev mongo_dev redis_dev

# Example 3: Start full database stack with admin tools
docker compose up -d mysql_dev phpmyadmin_dev adminer_dev postgres_dev pgadmin_dev mongo_dev

# Example 4: Start search stack (Elasticsearch + Kibana)
docker compose up -d elasticsearch_dev kibana_dev

# Example 5: Start web server and specific database
docker compose up -d nginx_dev mysql_dev phpmyadmin_dev
```

**Note:** Docker Compose automatically starts dependent services. For example, starting `phpmyadmin_dev` will also start `mysql_dev`.

---

### Scenario 3: Update Running Services to New Versions

When you've updated service versions in docker-compose.yml and services are already running:

```bash
# Step 1: Pull the latest images
docker compose pull

# Step 2: Recreate containers with new images (keeps data in volumes)
docker compose up -d --force-recreate

# Alternative: Recreate specific services only
docker compose up -d --force-recreate mysql_dev redis_dev
```

**What happens:**
- Existing containers are stopped and removed
- New containers are created with updated images
- **Data is preserved** in named volumes
- Services restart with new versions

**Safe Update Process (Zero Downtime for Critical Services):**

```bash
# 1. Pull new images first
docker compose pull

# 2. Update services one at a time
docker compose up -d --force-recreate --no-deps mysql_dev
docker compose up -d --force-recreate --no-deps redis_dev

# 3. Verify each service after update
docker compose logs mysql_dev
docker compose ps mysql_dev
```

---

### Scenario 4: Add New Services to Running Stack

When you want to add new services without restarting existing ones:

```bash
# Start new services while keeping existing ones running
docker compose up -d elasticsearch_dev kibana_dev

# Verify only new services were started
docker compose ps
```

**Example workflow:**
```bash
# Currently running: MySQL, Redis, PostgreSQL
docker compose ps

# Add MongoDB and Mongo Express without affecting others
docker compose up -d mongo_dev

# Add Elasticsearch stack
docker compose up -d elasticsearch_dev kibana_dev

# All services now running together
docker compose ps
```

---

### Scenario 5: Restart Services (Troubleshooting)

When a service is misbehaving or you've changed configuration:

```bash
# Restart specific service
docker compose restart mysql_dev

# Restart multiple services
docker compose restart mysql_dev redis_dev

# Restart all services
docker compose restart

# Stop and start (full cycle) for specific service
docker compose stop mysql_dev
docker compose start mysql_dev
```

---

### Common Operations

#### Stop Services (Keep Data)
```bash
# Stop all services (volumes and data preserved)
docker compose stop

# Stop specific services
docker compose stop mysql_dev redis_dev
```

#### Stop and Remove Containers (Keep Data)
```bash
# Remove all containers but keep volumes
docker compose down

# Remove specific service
docker compose rm -s mysql_dev
```

#### Complete Cleanup (Remove Everything)
```bash
# WARNING: This deletes all data!
docker compose down -v

# Remove specific volume
docker volume rm dev-services_mysql_dev_volume
```

#### View Logs
```bash
# All services (real-time)
docker compose logs -f

# Specific service (real-time)
docker compose logs -f mysql_dev

# Last 100 lines
docker compose logs --tail=100 mysql_dev

# Multiple services
docker compose logs -f mysql_dev redis_dev
```

#### Check Service Status
```bash
# List all services
docker compose ps

# Show only running services
docker compose ps --filter "status=running"

# Detailed status with ports
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

---

### Quick Reference Commands

| Task                       | Command                                                        |
| -------------------------- | -------------------------------------------------------------- |
| Start all services         | `docker compose up -d`                                         |
| Start specific services    | `docker compose up -d mysql_dev redis_dev`                     |
| Stop all services          | `docker compose stop`                                          |
| Stop and remove containers | `docker compose down`                                          |
| Update to new versions     | `docker compose pull && docker compose up -d --force-recreate` |
| Restart a service          | `docker compose restart mysql_dev`                             |
| View logs                  | `docker compose logs -f mysql_dev`                             |
| Check status               | `docker compose ps`                                            |
| Remove everything          | `docker compose down -v`                                       |

## 🔐 Service Access & Login Instructions

### 1. nginx (Web Server)
- **URL**: http://localhost:8000
- **Purpose**: Reverse proxy for phpMyAdmin and Mongo Express
- **Configuration**: `./dockerData/nginx/nginx.conf`
- **Web Root**: `./dockerData/nginx/www`

### 2. MySQL
- **Host**: `localhost`
- **Port**: `3306`
- **Username**: `root`
- **Password**: `root`
- **Connection String**: `mysql://root:root@localhost:3306`
- **CLI Access**:
  ```bash
  docker exec -it mysql_dev mysql -uroot -proot
  ```

### 3. phpMyAdmin (MySQL Web Interface)
- **URL**: http://localhost:8000/phpmyadmin/
- **Username**: `root`
- **Password**: `root`
- **Server**: `mysql_dev` (auto-configured)
- **Features**: 6GB upload limit enabled

### 4. Adminer (Universal Database Manager)
- **URL**: http://localhost:8000/adminer/
- **System**: Select database type (MySQL, PostgreSQL, MongoDB, etc.)
- **Server**: 
  - MySQL: `mysql_dev`
  - PostgreSQL: `postgres_dev`
  - MongoDB: `mongo_dev`
- **Username**: `root`
- **Password**: `root`
- **Database**: Leave empty or specify database name
- **Note**: Accessible only through nginx proxy, not on direct port

### 5. Redis
- **Host**: `localhost`
- **Port**: `6379`
- **Password**: None (no authentication)
- **Connection String**: `redis://localhost:6379`
- **CLI Access**:
  ```bash
  docker exec -it redis_dev redis-cli
  ```
- **Test Connection**:
  ```bash
  docker exec -it redis_dev redis-cli ping
  # Should return: PONG
  ```

### 6. PostgreSQL
- **Host**: `localhost`
- **Port**: `5432`
- **Username**: `root`
- **Password**: `root`
- **Database**: `postgres` (default)
- **Connection String**: `postgresql://root:root@localhost:5432/postgres`
- **CLI Access**:
  ```bash
  docker exec -it postgres_dev psql -U root
  ```
- **Backups Directory**: `./dockerData/postgres/backups`

### 7. pgAdmin (PostgreSQL Web Interface)
- **URL**: http://localhost:8000/pgadmin/
- **Email**: `root@root.com`
- **Password**: `root`
- **Adding Server Connection**:
  1. Right-click "Servers" → "Register" → "Server"
  2. **General Tab**: Name: `postgres_dev`
  3. **Connection Tab**:
     - Host: `postgres_dev`
     - Port: `5432`
     - Username: `root`
     - Password: `root`
  4. Click "Save"
- **Note**: Accessible only through nginx proxy, not on direct port

### 8. MongoDB
- **Host**: `localhost`
- **Port**: `27017`
- **Username**: `root`
- **Password**: `root`
- **Auth Database**: `admin`
- **Connection String**: `mongodb://root:root@localhost:27017/?authSource=admin`
- **CLI Access**:
  ```bash
  docker exec -it mongo_dev mongosh -u root -p root --authenticationDatabase admin
  ```
- **Init Script**: `./dockerData/mongodb/init-mongo.js`
- **Version**: MongoDB 8.0 (latest stable)

### 9. Mongo Express (MongoDB Web Interface)
- **URL**: http://localhost:8000/mongoexpress/
- **Basic Auth Username**: `admin`
- **Basic Auth Password**: `pass`
- **MongoDB Credentials**: Auto-authenticated with MongoDB
- **Server**: `mongo_dev` (auto-configured)
- **Admin Username**: `root`
- **Admin Password**: `root`
- **Note**: Accessible only through nginx proxy, not on direct port

### 10. Elasticsearch
- **URL**: http://localhost:9200
- **Transport Port**: `9300`
- **Mode**: Single-node (development)
- **Authentication**: None (development mode)
- **Health Check**:
  ```bash
  curl http://localhost:9200/_cluster/health
  ```
- **Java Heap**: 256MB (configurable via ES_JAVA_OPTS)

### 11. Kibana (Elasticsearch Visualization)
- **URL**: http://localhost:8000/kibana
- **Elasticsearch Host**: `http://elasticsearch_dev:9200` (auto-configured)
- **No Authentication Required**
- **First Time Setup**: Kibana will auto-connect to Elasticsearch

## 📁 Directory Structure

```
dev-services/
├── docker-compose.yml          # Main compose configuration
├── dockerData/                 # Service configurations and data
│   ├── mongodb/
│   │   └── init-mongo.js      # MongoDB initialization script
│   ├── mysql/
│   │   └── my.cnf             # MySQL configuration
│   ├── nginx/
│   │   ├── hosts              # Custom hosts file
│   │   ├── nginx.conf         # Nginx configuration
│   │   └── www/               # Web root directory
│   ├── phpmyadmin/
│   │   ├── config.user.inc.php
│   │   └── php.ini
│   └── postgres/
│       └── backups/           # PostgreSQL backup directory
└── README.md
```

## 🔧 Configuration

### Resource Limits

Each service has CPU and memory limits configured for optimal development performance:

- **MySQL**: 1 CPU, 1GB RAM
- **PostgreSQL**: 1 CPU, 1GB RAM
- **Elasticsearch**: 1 CPU, 1GB RAM
- **MongoDB**: 1 CPU, 1GB RAM
- **Kibana**: 1 CPU, 2GB RAM
- **nginx**: 0.5 CPU, 512MB RAM
- **Redis**: 0.5 CPU, 512MB RAM
- **phpMyAdmin/Adminer/pgAdmin/Mongo Express**: 0.25 CPU, 256MB RAM

### Persistent Data

All databases use named Docker volumes for data persistence:
- `mysql_dev_volume`
- `postgres_dev_volume`
- `mongo_dev_volume`
- `redis_dev_volume`
- `elasticsearch_dev_volume`
- `pgadmin_dev_volume`

### Health Checks

All services include health checks with:
- **Interval**: 30 seconds
- **Timeout**: 10 seconds
- **Retries**: 3 attempts

## 🛠️ Common Tasks

### Reset a Database
```bash
# Stop services
docker compose down

# Remove specific volume
docker volume rm dev-services_mysql_dev_volume

# Restart service
docker compose up -d mysql_dev
```

### View Service Resource Usage
```bash
docker stats
```

### Access Service Logs
```bash
# Real-time logs for all services
docker compose logs -f

# Last 100 lines for specific service
docker compose logs --tail=100 mysql_dev
```

### Restart a Service
```bash
docker compose restart mysql_dev
```

### Update Service Images
```bash
# Pull latest images
docker compose pull

# Recreate containers with new images
docker compose up -d --force-recreate
```

## 🔍 Troubleshooting

### Port Already in Use
```bash
# Find process using port (e.g., 3306)
lsof -i :3306

# Kill the process or change port in docker-compose.yml
```

### Service Won't Start
```bash
# Check logs
docker compose logs <service_name>

# Check service status
docker compose ps
```

### Reset Everything
```bash
# Stop and remove all containers, networks, volumes
docker compose down -v

# Start fresh
docker compose up -d
```

### Elasticsearch Memory Issues
If Elasticsearch fails to start, increase Docker's memory allocation to at least 4GB or adjust `ES_JAVA_OPTS` in docker-compose.yml.

## 📝 Notes

- **MongoDB Atlas Local**: Provides Atlas-compatible features for local development
- **MySQL**: Configured with `log_bin_trust_function_creators=1` for stored procedures
- **PostgreSQL**: Backups can be stored in `./dockerData/postgres/backups`
- **Elasticsearch**: Running in single-node mode (not for production)
- **All credentials**: Default `root:root` - **CHANGE FOR PRODUCTION**

## 🔄 Version Information

Last updated: January 2026

All services are running the latest stable versions as of January 2026:
- nginx: 1.28.1
- MySQL: 8.0.41
- phpMyAdmin: 5.2.3
- Adminer: 5.4.1
- Redis: 8.4.0
- PostgreSQL: 17.2
- pgAdmin: 9.11
- MongoDB: 8.0
- Mongo Express: 1.0.2
- Elasticsearch: 9.2.4
- Kibana: 9.2.4

## 📄 License

This is a development environment setup. Individual services are licensed under their respective licenses.
