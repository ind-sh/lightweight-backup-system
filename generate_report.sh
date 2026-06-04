#!/bin/bash

# Get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration file
source "$SCRIPT_DIR/config/backup.conf"

# Count total backup folders
TOTAL_BACKUPS=$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)

# Get latest backup folder
LATEST_BACKUP=$(ls "$BACKUP_DIR" | tail -n 1)

# Get total backup storage size
BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | awk '{print $1}')

# Get last 5 log events
RECENT_EVENTS=$(tail -n 5 "$LOG_FILE")

# Generate HTML dashboard
cat <<EOF > "$SCRIPT_DIR/reports/backup_status.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backup Dashboard</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #e9eff5 0%, #f4f6f8 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08), 0 8px 16px rgba(0, 0, 0, 0.04);
            max-width: 900px;
            width: 100%;
            padding: 40px;
            transition: all 0.3s ease;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        h1 {
            font-size: 28px;
            color: #1a202c;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        h1 i {
            color: #4f46e5;
            font-size: 32px;
        }

        .status-badge {
            background: #dcfce7;
            color: #166534;
            padding: 8px 20px;
            border-radius: 30px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 15px;
            border: 1px solid #bbf7d0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 35px;
        }

        .stat-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 24px 20px;
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.06);
        }

        .stat-card i {
            font-size: 26px;
            color: #4f46e5;
            margin-bottom: 12px;
            background: #eef2ff;
            padding: 10px;
            border-radius: 12px;
        }

        .stat-label {
            font-size: 14px;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 500;
        }

        .stat-value {
            font-size: 22px;
            font-weight: 700;
            color: #0f172a;
            margin-top: 4px;
        }

        .events-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 24px;
        }

        .events-card h2 {
            font-size: 20px;
            color: #1e293b;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .events-card h2 i {
            color: #4f46e5;
        }

        .events-box {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            font-family: 'SF Mono', 'Fira Code', monospace;
            font-size: 14px;
            line-height: 1.6;
            color: #334155;
            max-height: 250px;
            overflow-y: auto;
            white-space: pre-wrap;
            word-break: break-word;
        }

        .events-box::-webkit-scrollbar {
            width: 6px;
        }

        .events-box::-webkit-scrollbar-track {
            background: #f1f5f9;
            border-radius: 10px;
        }

        .events-box::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }

        @media (max-width: 600px) {
            .container {
                padding: 25px;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <i class="fas fa-shield-haltered"></i> Backup Dashboard
            </h1>
            <div class="status-badge">
                <i class="fas fa-check-circle"></i> SUCCESS
            </div>
        </div>

        <!-- Quick stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-archive"></i>
                <span class="stat-label">Total Backups</span>
                <span class="stat-value">$TOTAL_BACKUPS</span>
            </div>
            <div class="stat-card">
                <i class="fas fa-clock"></i>
                <span class="stat-label">Latest Backup</span>
                <span class="stat-value">$LATEST_BACKUP</span>
            </div>
            <div class="stat-card">
                <i class="fas fa-history"></i>
                <span class="stat-label">Retention</span>
                <span class="stat-value">$RETENTION_DAYS days</span>
            </div>
        </div>

        <!-- Recent events -->
        <div class="events-card">
            <h2>
                <i class="fas fa-list-alt"></i> Recent Events
            </h2>
            <div class="events-box">$RECENT_EVENTS</div>
        </div>
    </div>
</body>
</html>
EOF
