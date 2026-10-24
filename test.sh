#!/usr/bin/env bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

function killgop {
    echo -e "${CYAN}killing $1${NC}"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        kill -9 $1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        kill -TERM $1
    fi
}

check_error() {
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "${RED}[ERROR] Test failed with exit code $status${NC}"
    fi
}

echo -e "${BLUE}===== TEST BEGINNER =====${NC}"

echo -e "${CYAN}----- test HelloWorld -----${NC}"
go run ./beginner/HelloWorld.go
check_error

echo -e "${CYAN}----- test var -----${NC}"
go run ./beginner/var.go
check_error

echo -e "${CYAN}----- test if -----${NC}"
go run ./beginner/if.go Hello
check_error

echo -e "${CYAN}----- test array -----${NC}"
go run ./beginner/array.go
check_error

echo -e "${CYAN}----- test function -----${NC}"
go run ./beginner/function.go
check_error

echo -e "${CYAN}----- test for -----${NC}"
go run ./beginner/for.go
check_error

echo -e "${CYAN}----- test foreach -----${NC}"
go run ./beginner/foreach.go
check_error

echo -e "${CYAN}----- test args -----${NC}"
go run ./beginner/args.go string string2
check_error

echo -e "${CYAN}----- test input -----${NC}"
go run ./beginner/input.go
check_error

echo -e "${CYAN}----- test flag -----${NC}"
go run ./beginner/flag.go
check_error

echo -e "${CYAN}----- test dir -----${NC}"
go run ./beginner/dir.go
check_error

echo -e "${CYAN}----- test time -----${NC}"
go run ./beginner/time.go
check_error

echo -e "${CYAN}----- test random -----${NC}"
go run ./beginner/random.go
check_error

echo -e "${CYAN}----- test cat -----${NC}"
go run ./beginner/cat.go
check_error

echo -e "${CYAN}----- test modulo -----${NC}"
go run ./beginner/modulo.go
check_error

echo -e "${CYAN}----- test split -----${NC}"
go run ./beginner/split.go
check_error

echo -e "${CYAN}----- test hashing -----${NC}"
go run ./beginner/hashing.go
check_error

echo -e "${CYAN}----- test ackermann -----${NC}"
go run ./beginner/ackermann.go
check_error

echo -e "${CYAN}----- test euklid -----${NC}"
go run ./beginner/euklid.go
check_error

echo -e "${CYAN}----- test variadic function -----${NC}"
go run ./beginner/functionvariadic.go
check_error

echo -e "${CYAN}----- test delete fom slice -----${NC}"
go run ./beginner/deleteFromSlice.go
check_error

echo -e "${BLUE}===== TEST ADVANCED =====${NC}"

echo -e "${CYAN}----- test pythagoras -----${NC}"
go run ./advanced/pythagoras.go 10 15 ?
check_error

echo -e "${CYAN}----- test wait -----${NC}"
go run ./advanced/wait.go
check_error

echo -e "${CYAN}----- test lifo -----${NC}"
go run ./advanced/lifo.go
check_error

echo -e "${CYAN}----- test regex -----${NC}"
go run ./advanced/regex.go
check_error

echo -e "${CYAN}----- test fibonacci -----${NC}"
go run ./advanced/fibonacci.go
check_error

echo -e "${CYAN}----- test prime -----${NC}"
go run ./advanced/prime.go 32
check_error

echo -e "${CYAN}----- test numbers -----${NC}"
go run ./advanced/numbers.go
check_error

echo -e "${CYAN}----- test json -----${NC}"
go run ./advanced/json.go
check_error

echo -e "${CYAN}----- test exec -----${NC}"
go run ./advanced/exec.go
check_error

echo -e "${CYAN}----- test suicide -----${NC}"
go run ./advanced/suicide.go
check_error

echo -e "${CYAN}----- test in array search -----${NC}"
go run ./advanced/in_array.go
check_error

echo -e "${CYAN}----- test benchmarking json marshal and unmarshal -----${NC}"
go test -bench=. -benchmem ./advanced/json_bench/main_test.go
check_error

echo -e "${BLUE}===== TEST EXPERT =====${NC}"

echo -e "${CYAN}----- test color -----${NC}"
go run ./expert/color.go
check_error

echo -e "${CYAN}----- test telnet -----${NC}"
go run ./expert/telnet.go &
sleep 10
nc localhost 2223 <lorem
check_error
killgop $!

echo -e "${CYAN}----- test httpd -----${NC}"
go run ./expert/httpd.go &
sleep 10
for i in {1..10}; do curl http://localhost:8080; done
check_error
killgop $!

echo -e "${CYAN}----- test httpsd -----${NC}"
cd expert
go run ./httpsd.go &
sleep 5
echo -e "${CYAN}waiting 10 seconds - then make 10 connections${NC}"
sleep 10
for i in {1..10}; do curl https://localhost:4443 --insecure; done
check_error
killgop $!
cd ..

echo -e "${CYAN}----- test cookies -----${NC}"
go run ./expert/cookies.go &
sleep 10
for i in {1..2}; do curl http://localhost:8080; done
check_error
killgop $!

echo -e "${CYAN}----- test proxy -----${NC}"
go run ./expert/proxy.go &
sleep 10
curl https://localhost:8080 --insecure
check_error
killgop $!

echo -e "${CYAN}----- test ppk-crypto -----${NC}"
go run ./export/ppk-crypto.go
check_error

echo -e "${CYAN}----- test image -----${NC}"
cd expert
go run ./image.go
check_error

echo -e "${CYAN}----- test sqlite -----${NC}"
go get github.com/mxk/go-sqlite/sqlite3
check_error
go run ./sqlite.go insert test
check_error
go run ./sqlite.go select
check_error
cd ..

echo -e "${CYAN}----- test parallel -----${NC}"
export GOMAXPROCS=8
time go run ./expert/parallel.go true
check_error
time go run ./expert/parallel.go false
check_error

echo -e "${CYAN}----- test dynparallel -----${NC}"
time go run ./expert/dynparallel.go 8
check_error
