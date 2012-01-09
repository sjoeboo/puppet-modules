#!/bin/bash

JOIN_USER=""
JOIN_PASSWORD=""

net ads join -U$JOIN_USER%$JOIN_PASSWORD
