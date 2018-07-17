#!/bin/sh
echo Usage $0 host port
ssh -L $2:localhost:$2 $1 -N
