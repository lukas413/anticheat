CREATE TABLE IF NOT EXISTS anticheat_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    ip VARCHAR(50) NOT NULL,
    license VARCHAR(50) NOT NULL,
    discord VARCHAR(50) NOT NULL,
    reason VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS anticheat_screenshots (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    reason VARCHAR(255) NOT NULL,
    image LONGTEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
