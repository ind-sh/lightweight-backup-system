# Lightweight Backup System

A simple backup and recovery automation project built using Bash and rsync.

The project simulates a production application backup workflow with restore support, cleanup automation, logging, and a basic HTML dashboard.

---

# Features

* Incremental backups using rsync
* Restore deleted files and folders
* Automatic cleanup of old backups
* HTML status dashboard
* Backup and restore logging
* Timestamp-based backup folders

---

# Tech Used

* Bash
* Linux
* rsync
* HTML/CSS

---

# Project Structure

```bash id="eb4vxu"
lightweight-backup-system/

├── backup.sh
├── restore.sh
├── cleanup.sh
├── generate_report.sh

├── config/
├── production_app/
├── backups/
├── logs/
├── reports/

├── README.md
└── .gitignore
```

---

# Setup

Clone the repository:

```bash id="90c8sj"
git clone YOUR_REPOSITORY_URL
```

Move into the project folder:

```bash id="gjz2v9"
cd lightweight-backup-system
```

Install required packages:

```bash id="jlwmoy"
sudo apt update
sudo apt install rsync tree -y
```

Make scripts executable:

```bash id="rzjwgm"
chmod +x *.sh
```

---

# Run Backup

```bash id="x4k3jo"
./backup.sh
```

---

# Generate Dashboard

```bash id="nnqjkp"
./generate_report.sh
```

Open dashboard:

```bash id="cjlwmz"
explorer.exe "$(wslpath -w reports/backup_status.html)"
```

---

# Restore Deleted Data

```bash id="r3jqkg"
./restore.sh
```

---

# Cleanup Old Backups

```bash id="ztj1u2"
./cleanup.sh
```

---

# Learning Outcome

This project helped me practice:

* Bash scripting
* Linux file handling
* rsync backups
* Restore workflows
* Automation concepts
* Basic operational monitoring

---

# Future Improvements

* Backup compression
* Email alerts
* Docker support
* Cloud storage backup
