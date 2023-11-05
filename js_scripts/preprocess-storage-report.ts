import fs from 'fs';

function removeFilePathsFromContractColumn(markdown: string): string {
  // Split the markdown table into rows
  const rows: string[] = markdown.trim().split('\n');

  // Find the index of the 'Contract' column in the header row
  const headerRow: string[] = rows[0]
    .trim()
    .split('|')
    .map((header) => header.trim());
  const contractColumnIndex: number = headerRow.indexOf('Contract');

  // Check if the 'Contract' column exists in the table
  if (contractColumnIndex === -1) {
    console.error("The 'Contract' column was not found in the table!");
    return markdown;
  }

  // Modify the 'Contract' column data in each row
  const modifiedRows: string[] = rows.map((row) => {
    const columns: string[] = row.trim().split('|');
    // Get the value of the 'Contract' column
    const contractPath: string = columns[contractColumnIndex].trim();
    const lastSlashIndex: number = contractPath.lastIndexOf('/');
    if (lastSlashIndex !== -1) {
      // Update the 'Contract' column with the filename only
      columns[contractColumnIndex] = contractPath.substring(lastSlashIndex + 1);
    }
    return columns.join('|');
  });

  // Join the rows back into a markdown table
  const modifiedMarkdownTable: string = modifiedRows.join('\n');

  return modifiedMarkdownTable;
}

function cleanMarkdownTable(markdown: string): string {
  const lines = markdown.split('\n');

  // Get the separator line containing multiple dashes
  const separatorLine = lines.find((line) => line.includes('|-'));

  if (separatorLine) {
    // Find the number of columns in the table
    const numberOfColumns = separatorLine.split('|').length - 2; // Account for the first and last empty column

    // Replace separator line with the correct number of '-|'
    lines[lines.indexOf(separatorLine)] = `|${Array(numberOfColumns).fill('-').join('|')}|`;
  }

  // Remove white spaces in column names
  lines[0] = `|${lines[0]
    .slice(1, -1)
    .split('|')
    .map((column) => column.trim())
    .join('|')}|`;

  return lines.join('\n');
}

const reportFile = process.argv[2];
if (!reportFile) {
  console.error('Invalid reportFile for pre-processing storage report');
}

const readData = fs.readFileSync(`reports/${reportFile}.md`, 'utf8');

const cleanedMarkdownTable: string = cleanMarkdownTable(readData);
const modifiedMarkdownTable: string = removeFilePathsFromContractColumn(cleanedMarkdownTable);

fs.writeFileSync(`reports/${reportFile}.md`, modifiedMarkdownTable, 'utf8');
