#!/bin/bash
# Setup environment for kunterbunt and start the ide

# Setzen der Sprache auf default wert für automatische Auswertung von Nachrichten...
export LANG=C

sed 's/$password/*****/g' "$TMP_LOG_FILE" >> "$LOG_FILE"
rm -f $TMP_LOG_FILE