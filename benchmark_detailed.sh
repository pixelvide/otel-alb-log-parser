#!/bin/bash

LOG_FILE="../545734669840_elasticloadbalancing_ap-south-1_app.k8s-ifmists-77301eb642.1afac668357f0e47_20251204T0100Z_35.154.220.67_2e3zhl6q.log.gz"

echo "========================================================"
echo "🚀 Detailed Benchmark"
echo "========================================================"

# 1. Python
echo "🐍 Python (Total):"
time python3 ../alb_to_otel.py "$LOG_FILE" > /dev/null

# 2. Go Parsing Only
echo ""
echo "🐹 Go (Parsing Only):"
time ./bin/parse-demo "$LOG_FILE" > /dev/null

# 3. Go Total
echo ""
echo "🐹 Go (Total):"
time ./bin/convert-otel "$LOG_FILE" > /dev/null
