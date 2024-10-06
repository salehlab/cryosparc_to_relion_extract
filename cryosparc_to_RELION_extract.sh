#!/bin/bash

# Display the welcome message
echo "                                                      "
echo "  ___    _    _     ___  _  _       _       _    ___  "
echo " / __|  /_\  | |   | __|| || | ___ | |     /_\  | _ ) "
echo " \__ \ / _ \ | |__ | _| | __ ||___|| |__  / _ \ | _ \ "
echo " |___//_/ \_\|____||___||_||_|     |____|/_/ \_\|___/ "
echo "                                                      "
echo "            cryosparc_to_RELION_extract.sh            "
echo "                   Saleh-Lab 2024                     "
echo "                                                      "
echo "                                                      "

# Print current working directory location
echo "The current folder location is: $(pwd)"
echo "Do you know where the cryosparc main project folder is? If not, exit."

# Prompt user for input
read -p "Enter the cryosparc main project directory (e.g. /your/directory/P1): " PROJECT
read -p "Enter the cryosparc job number (e.g. J567): " JOB
PARTICLES_FILE="extracted_particles.cs"  # Updated file name based on directory listing

# Set directories, relion-project name includes JOB
SOURCE_DIR="$PROJECT/$JOB/extract"
RELION_DIR="$PROJECT/relion-project_$JOB"
JOB_DIR="$RELION_DIR/$JOB"

# Print the paths where files will be generated
echo "The project directory is set to: $PROJECT"
echo "The job directory is set to: $JOB"
echo "The source directory for .mrc files is: $SOURCE_DIR"
echo "The relion directory will be created at: $RELION_DIR"
echo "The job-specific relion directory is: $JOB_DIR"

# Function to check file existence
check_file() {
    if [ ! -f "$1" ]; then
        echo "File not found: $1"
        exit 1
    fi
}

# Check if the required .cs files exist before running csparc2star.py
check_file "$PROJECT/$JOB/$PARTICLES_FILE"
check_file "$PROJECT/$JOB/${JOB}_passthrough_particles.cs"

# Step 1: Set up directories for Relion project
echo "Setting up directories for Relion in $JOB_DIR..."
mkdir -p "$JOB_DIR/extract"  # Ensure the directory structure exists

# Step 2: Create symbolic links for .mrc files in the extract directory
if [ -d "$SOURCE_DIR" ]; then
    echo "Creating symbolic links for .mrc files in $JOB_DIR/extract..."
    for mrc_file in $SOURCE_DIR/*.mrc; do
        if [ -e "$mrc_file" ]; then
            ln -s "$mrc_file" "$JOB_DIR/extract/"
        else
            echo "No .mrc files found in $SOURCE_DIR."
            exit 1
        fi
    done
else
    echo "Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Step 3: Rename .mrc files to .mrcs
echo "Renaming .mrc files to .mrcs in $JOB_DIR/extract..."
cd "$JOB_DIR/extract"
rename 's/\.mrc$/\.mrcs/' *.mrc

# Step 4: Verify symbolic links and renaming
echo "Files in $JOB_DIR/extract after renaming:"
ls -la

# Step 5: Convert cryoSPARC metadata to Relion STAR format
STAR_FILE="$JOB_DIR/${JOB}_particles.star"  # Create .star file in the correct absolute location
echo "Converting cryoSPARC metadata to Relion STAR format..."
csparc2star.py "$PROJECT/$JOB/$PARTICLES_FILE" "$PROJECT/$JOB/${JOB}_passthrough_particles.cs" "$STAR_FILE"

# Step 6: Verify that the STAR file was created successfully
if [ -f "$STAR_FILE" ]; then
    echo "STAR file created successfully at: $STAR_FILE"
else
    echo "Failed to create STAR file."
    exit 1
fi

# Step 7: Edit the STAR file to use .mrcs extensions
echo "Editing the STAR file to use .mrcs extensions..."
sed -i 's/\.mrc/\.mrcs/g' "$STAR_FILE"

# Step 8: Final verification of the STAR file modification
echo "STAR file after modification:"
grep ".mrcs" "$STAR_FILE"

echo "Conversion process completed successfully!"
echo "The final STAR file is located at: $STAR_FILE"
