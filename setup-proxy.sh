#!/bin/bash

# Set the directory name for the proxy server files
PROXY_DIR="$HOME/.proxy-server"

# Create the hidden directory
mkdir -p "$PROXY_DIR"

# Create the proxy server script
cat > "$PROXY_DIR/proxy.js" <<EOF
const http = require('http');
const httpProxy = require('http-proxy');

// Create a proxy server
const proxy = httpProxy.createProxyServer({});

// Create a local server that will forward requests to the test server
const server = http.createServer((req, res) => {
  // Forward the request to the test server
  proxy.web(req, res, {
    target: 'http://14.99.126.171:8000'
  });
});

// Start the local proxy server on port 80
server.listen(3000, () => {
  console.log('Local proxy server started on port 3000');
});
EOF

# Install the required dependencies
cd "$PROXY_DIR"
npm install http-proxy

# Create the proxy executable script
cat > "$PROXY_DIR/start-proxy.sh" <<EOF
#!/bin/bash
node $PROXY_DIR/proxy.js
EOF

# Make the script executable
chmod +x "$PROXY_DIR/start-proxy.sh"

# Create a symlink to the script
sudo ln -s "$PROXY_DIR/start-proxy.sh" /usr/local/bin/proxy

echo "Proxy server setup complete!"
echo "You can now run the proxy server @ localhost:3000 by typing 'proxy' in the terminal from anywhere in the system."
