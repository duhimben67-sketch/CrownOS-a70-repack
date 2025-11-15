#!/bin/bash

workdir="$1"

echo "Applying CrownOS tweaks..."

# Example tweaks:
# Remove unwanted apps
rm -rf "$workdir/system/app/Browser"
rm -rf "$workdir/system/app/Email"

# Add any other edits here
echo "Tweaks complete."
echo "CrownOS tweaks applied successfully!"
