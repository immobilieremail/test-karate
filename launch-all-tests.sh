#!/bin/bash

rm -rf target
java -jar karate.jar tests/*.feature
