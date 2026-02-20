#!/usr/bin/env node
/**
 * md2adf.js - Convert Markdown to Atlassian Document Format (ADF)
 * Uses official Atlassian libraries
 *
 * Usage: node md2adf.js input.md
 * Or: echo "markdown" | node md2adf.js
 */

const fs = require('fs');
const { defaultSchema } = require('@atlaskit/adf-schema');
const { JSONTransformer } = require('@atlaskit/editor-json-transformer');
const {
  MarkdownTransformer,
} = require('@atlaskit/editor-markdown-transformer');

// Initialize transformers
const jsonTransformer = new JSONTransformer();
const markdownTransformer = new MarkdownTransformer(defaultSchema);

function convertMarkdownToAdf(markdownContent) {
  try {
    const pmNode = markdownTransformer.parse(markdownContent);
    const adfDocument = jsonTransformer.encode(pmNode);
    return JSON.stringify(adfDocument);
  } catch (error) {
    console.error('Error converting markdown to ADF:', error.message);
    process.exit(1);
  }
}

// Check if input is from file or stdin
if (process.argv.length >= 3) {
  // Read from file
  const inputFile = process.argv[2];
  try {
    const markdownContent = fs.readFileSync(inputFile, 'utf8');
    console.log(convertMarkdownToAdf(markdownContent));
  } catch (error) {
    console.error(`Error reading file ${inputFile}:`, error.message);
    process.exit(1);
  }
} else {
  // Read from stdin (non-blocking)
  let stdinData = '';

  process.stdin.setEncoding('utf8');

  process.stdin.on('data', (chunk) => {
    stdinData += chunk;
  });

  process.stdin.on('end', () => {
    if (stdinData.trim()) {
      console.log(convertMarkdownToAdf(stdinData));
    } else {
      console.error('Error: No input provided');
      process.exit(1);
    }
  });

  // Handle case where stdin is not a pipe
  process.stdin.on('error', (error) => {
    console.error('Error reading stdin:', error.message);
    process.exit(1);
  });
}
