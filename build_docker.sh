#!/usr/bin/env bash
# This script builds the docker image of the SMQTK IQR system

nvidia-docker build -t cdeepakroy/smqtk-docker:latest .
