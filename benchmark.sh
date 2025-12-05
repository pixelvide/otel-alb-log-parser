#!/bin/bash

LOG_FILE="../545734669840_elasticloadbalancing_ap-south-1_app.k8s-ifmists-77301eb642.1afac668357f0e47_20251204T0100Z_35.154.220.67_2e3zhl6q.log.gz"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found at $LOG_FILE"
    exit 1
fi

echo "========================================================"
echo "🚀 Performance Benchmark: Python vs Go"
echo "========================================================"
echo "Log File: $(basename $LOG_FILE)"
echo "Size: $(du -h $LOG_FILE | cut -f1)"
echo "========================================================"

# 1. Benchmark Python
echo ""
echo "🐍 Running Python Parser..."
start_time=$(date +%s%N)
python3 ../alb_to_otel.py "$LOG_FILE" > /dev/null
end_time=$(date +%s%N)
python_duration=$(( (end_time - start_time) / 1000000 ))
echo "Time: ${python_duration}ms"

# 2. Benchmark Go
echo ""
echo "🐹 Running Go Parser..."
# Ensure binary is built
make build > /dev/null 2>&1

start_time=$(date +%s%N)
./bin/convert-otel "$LOG_FILE" > /dev/null
end_time=$(date +%s%N)
go_duration=$(( (end_time - start_time) / 1000000 ))
echo "Time: ${go_duration}ms"

# 3. Results
echo ""
echo "========================================================"
echo "🏆 Results"
echo "========================================================"
echo "Python: ${python_duration}ms"
echo "Go:     ${go_duration}ms"
echo ""

if [ $go_duration -gt 0 ]; then
    speedup=$(echo "scale=2; $python_duration / $go_duration" | bc)
    echo "🚀 Go is ${speedup}x faster than Python!"
else
    echo "Go was too fast to measure accurately!"
fi
echo "========================================================"
