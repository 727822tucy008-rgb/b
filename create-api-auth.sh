#!/bin/bash
echo "=== Creating API Authentication File ==="

echo "1. Creating directory..."
sudo mkdir -p /var/ossec/api/configuration/auth

echo "2. Creating user file..."
sudo tee /var/ossec/api/configuration/auth/user << 'EOF'
{"username":"admin","password":"admin"}
EOF

echo "3. Setting permissions..."
sudo chown -R wazuh:wazuh /var/ossec/api/configuration/auth
sudo chmod 640 /var/ossec/api/configuration/auth/user

echo "4. Updating dashboard config..."
sudo tee -a /etc/wazuh-dashboard/opensearch_dashboards.yml << 'EOF'
wazuh_core.api.host: "https://localhost:55000"
wazuh_core.api.port: 55000
wazuh_core.api.username: "admin"
wazuh_core.api.password: "admin"
wazuh_core.api.protocol: "https"
EOF

echo "5. Restarting services..."
sudo systemctl restart wazuh-manager
sleep 10
sudo systemctl restart wazuh-dashboard

echo "6. Checking..."
ls -la /var/ossec/api/configuration/auth/

echo "=== Done ==="
echo "API auth file created. Refresh dashboard in 30 seconds."
