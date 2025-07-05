#!/bin/bash

# Script to run elm-test with proper DNS configuration
# This handles the systemd-resolved DNS issue with Elm on Arch Linux

echo "🧪 Running Elm tests..."

# Check if we have the DNS fix in place
if ! grep -q "8.8.8.8" /etc/resolv.conf; then
    echo "⚠️  DNS not configured for Elm. Please run:"
    echo "   echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf"
    echo "   systemctl restart systemd-resolved"
    echo ""
    echo "Or restore with:"
    echo "   sudo systemctl restart systemd-resolved"
    exit 1
fi

# Run the tests
elm-test

echo "✅ Tests completed!"