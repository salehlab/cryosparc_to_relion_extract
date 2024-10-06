# cryosparc_to_relion_extract
Easily convert cryoSPARC extracted particles to RELION

This repository contains the `cryosparc_to_relion_extract.sh` script, which converts CryoSPARC particle data into a RELION format. It facilitates the extraction of particles, creation of symbolic links for `.mrc` files, and conversion of cryoSPARC metadata into the RELION `.star` format.

## Prerequisites

Make sure the following prerequisites are met before running the script:

- **CryoSPARC project with extracted particles**: You should have an extracted particles job in CryoSPARC (e.g., `J5`).
- **Python environment with required dependencies**: Ensure that you have `csparc2star.py` installed. You can install it from the `pyem` repository:

   ```bash
  pip install pyem
  ```

## Installation

Clone this repository to your local machine:

  ```bash
git clone https://github.com/salehlab/cryosparc_to_relion_extract.git
  ```

### Ensure the Script is in your PATH

To run the script from anywhere, add the script directory to your PATH environment variable:

  ```bash
export PATH=/path/to/cryosparc_to_relion_extract/:$PATH
  ```

If the script is not already executable, you can make it executable by running:

  ```bash
chmod +x cryosparc_to_relion_extract.sh
  ```

## Usage

To use the script, navigate to the CryoSPARC job directory where the particles have been extracted (e.g., `J5`), and execute the script:
 
  ```bash
cd /path/to/your/cryosparc/project/J5
./cryosparc_to_relion_extract.sh
  ```
This will initiate the conversion of CryoSPARC metadata into the RELION-compatible `.star` format, and will create symbolic links for `.mrc` files in the specified RELION project directory.

Notes
- The script automatically handles renaming `.mrc` files to `.mrcs` to comply with RELION’s format requirements.
- Ensure that you have the necessary permissions to create symbolic links in the project directory.

## Contributing
We welcome contributions! Feel free to submit pull requests or open an issue if you find bugs or have suggestions.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
