# terraform/init-mysql.sql
-- Создание таблиц для приложения shvirtd-test
-- Аналогично тому, что делает main.py

-- Основная таблица для метрик/запросов
CREATE TABLE IF NOT EXISTS requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    endpoint VARCHAR(255) NOT NULL,
    method VARCHAR(10) NOT NULL,
    status_code INT,
    response_time_ms INT,
    user_agent TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_endpoint (endpoint),
    INDEX idx_created_at (created_at),
    INDEX idx_status_code (status_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Таблица для метрик системы
CREATE TABLE IF NOT EXISTS system_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cpu_percent FLOAT,
    memory_percent FLOAT,
    disk_usage_percent FLOAT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    server_id VARCHAR(100),
    INDEX idx_timestamp (timestamp),
    INDEX idx_server_id (server_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Таблица для пользовательских метрик
CREATE TABLE IF NOT EXISTS custom_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    metric_name VARCHAR(100) NOT NULL,
    metric_value FLOAT NOT NULL,
    metric_labels JSON,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_metric_name (metric_name),
    INDEX idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Таблица для ошибок/исключений
CREATE TABLE IF NOT EXISTS error_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    error_type VARCHAR(100),
    error_message TEXT,
    stack_trace TEXT,
    endpoint VARCHAR(255),
    user_id INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_error_type (error_type),
    INDEX idx_timestamp (timestamp),
    INDEX idx_endpoint (endpoint)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Таблица для конфигурации приложения
CREATE TABLE IF NOT EXISTS app_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT,
    config_type VARCHAR(50) DEFAULT 'string',
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Вставляем начальную конфигурацию
INSERT INTO app_config (config_key, config_value, config_type, description) VALUES
('app_version', '1.0.0', 'string', 'Версия приложения'),
('maintenance_mode', 'false', 'boolean', 'Режим обслуживания'),
('max_requests_per_minute', '1000', 'integer', 'Максимальное количество запросов в минуту'),
('enable_metrics_collection', 'true', 'boolean', 'Сбор метрик')
ON DUPLICATE KEY UPDATE config_value = VALUES(config_value);

-- Создаем пользователя для приложения (если нужно отдельного)
-- CREATE USER IF NOT EXISTS 'shvirtd_app'@'%' IDENTIFIED BY 'strong_password_here';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON app_database.* TO 'shvirtd_app'@'%';
-- FLUSH PRIVILEGES;

-- Проверяем создание таблиц
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH,
    CREATE_TIME
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME;
