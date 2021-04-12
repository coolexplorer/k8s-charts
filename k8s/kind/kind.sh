#!/bin/bash

brew install kind

# cluster installation with default (Latest kubenetes version)
kind create cluster

# check the cluster
kind get cluster