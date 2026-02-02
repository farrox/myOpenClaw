#!/usr/bin/env python3
import struct
import sys
import zlib
from pathlib import Path

def read_fmt(file, fmt):
    """
    Reads data from a file based on the provided struct format.

    :param file: File object to read from.
    :param fmt: Struct format string.
    :return: Unpacked data.
    :raises ValueError: If there's an unexpected end of file.
    """
    size = struct.calcsize(fmt)
    data = file.read(size)
    if len(data) != size:
        raise ValueError(f"Unexpected end of file when reading format {fmt}")
    return struct.unpack(fmt, data)[0]

def convert_streams(infile, outfile):
    """
    Converts a WOFF file stream to an OTF file stream.

    :param infile: Input file object (WOFF).
    :param outfile: Output file object (OTF).
    :raises ValueError: If the input file is not a valid WOFF file or other inconsistencies are found.
    """
    # Read WOFF header
    WOFFHeader = {
        'signature': read_fmt(infile, ">I"),
        'flavor': read_fmt(infile, ">I"),
        'length': read_fmt(infile, ">I"),
        'numTables': read_fmt(infile, ">H"),
        'reserved': read_fmt(infile, ">H"),
        'totalSfntSize': read_fmt(infile, ">I"),
        'majorVersion': read_fmt(infile, ">H"),
        'minorVersion': read_fmt(infile, ">H"),
        'metaOffset': read_fmt(infile, ">I"),
        'metaLength': read_fmt(infile, ">I"),
        'metaOrigLength': read_fmt(infile, ">I"),
        'privOffset': read_fmt(infile, ">I"),
        'privLength': read_fmt(infile, ">I")
    }

    # Verify WOFF signature ('wOFF' -> 0x774F4646)
    if WOFFHeader['signature'] != 0x774F4646:
        raise ValueError("Input file is not a valid WOFF file.")

    # Start writing OTF header
    # 'flavor' becomes 'signature' in OTF
    outfile.write(struct.pack(">I", WOFFHeader['flavor']))
    outfile.write(struct.pack(">H", WOFFHeader['numTables']))

    # Calculate searchRange, entrySelector, rangeShift
    max_power = 1
    entry_selector = 0
    while (max_power << 1) <= WOFFHeader['numTables']:
        max_power <<= 1
        entry_selector += 1
    search_range = max_power * 16
    range_shift = WOFFHeader['numTables'] * 16 - search_range
    outfile.write(struct.pack(">H", search_range))
    outfile.write(struct.pack(">H", entry_selector))
    outfile.write(struct.pack(">H", range_shift))

    # Read Table Directory Entries from WOFF
    TableDirectoryEntries = []
    for _ in range(WOFFHeader['numTables']):
        tag = read_fmt(infile, ">I")
        offset = read_fmt(infile, ">I")
        compLength = read_fmt(infile, ">I")
        origLength = read_fmt(infile, ">I")
        origChecksum = read_fmt(infile, ">I")
        TableDirectoryEntries.append({
            'tag': tag,
            'offset': offset,
            'compLength': compLength,
            'origLength': origLength,
            'origChecksum': origChecksum
        })

    # Prepare to write Table Directory in OTF
    current_offset = outfile.tell() + (16 * WOFFHeader['numTables'])
    # Align to 4-byte boundary
    if current_offset % 4 != 0:
        current_offset += 4 - (current_offset % 4)

    # Assign outOffset for each table and calculate padding
    for entry in TableDirectoryEntries:
        entry['outOffset'] = current_offset
        current_offset += entry['origLength']
        # Add padding to 4-byte boundary
        if current_offset % 4 != 0:
            current_offset += 4 - (current_offset % 4)

    # Write Table Directory Entries to OTF
    for entry in TableDirectoryEntries:
        outfile.write(struct.pack(">I", entry['tag']))
        outfile.write(struct.pack(">I", entry['origChecksum']))
        outfile.write(struct.pack(">I", entry['outOffset']))
        outfile.write(struct.pack(">I", entry['origLength']))

    # Write table data
    for entry in TableDirectoryEntries:
        infile.seek(entry['offset'])
        compressedData = infile.read(entry['compLength'])
        if entry['compLength'] != entry['origLength']:
            try:
                uncompressedData = zlib.decompress(compressedData)
            except zlib.error as e:
                raise ValueError(f"Error decompressing table {entry['tag']:08X}: {e}")
        else:
            uncompressedData = compressedData

        # Ensure the uncompressed data is of the correct length
        if len(uncompressedData) != entry['origLength']:
            raise ValueError(f"Decompressed data length mismatch for table {entry['tag']:08X}")

        outfile.write(uncompressedData)

        # Add padding if necessary
        padding = (4 - (entry['origLength'] % 4)) % 4
        if padding:
            outfile.write(b'\x00' * padding)

def convert(infilename, outfilename):
    """
    Opens the input and output files and initiates the conversion.

    :param infilename: Path to the input WOFF file.
    :param outfilename: Path to the output OTF file.
    """
    with open(infilename, 'rb') as infile, open(outfilename, 'wb') as outfile:
        convert_streams(infile, outfile)

def main():
    """
    Converts all WOFF files in the current directory to OTF format.
    """
    current_dir = Path('.')
    woff_files = [file for file in current_dir.iterdir() if file.is_file() and file.suffix.lower() == '.woff']

    if not woff_files:
        print("No WOFF files found in the current directory.")
        sys.exit(0)

    success_count = 0
    failure_count = 0
    failed_files = []

    for woff_file in woff_files:
        otf_file = woff_file.with_suffix('.otf')
        print(f"Converting '{woff_file.name}' to '{otf_file.name}'...")
        try:
            convert(woff_file, otf_file)
            print(f"Successfully converted '{woff_file.name}' to '{otf_file.name}'.\n")
            success_count += 1
        except Exception as e:
            print(f"Error converting '{woff_file.name}': {e}\n", file=sys.stderr)
            failure_count += 1
            failed_files.append((woff_file.name, str(e)))

    # Summary
    print("Conversion Summary:")
    print(f"Total WOFF files found: {len(woff_files)}")
    print(f"Successfully converted: {success_count}")
    print(f"Failed conversions: {failure_count}")

    if failure_count > 0:
        print("\nFailed Files:")
        for fname, error in failed_files:
            print(f"- {fname}: {error}")

    # Exit code
    if failure_count > 0:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == '__main__':
    main()