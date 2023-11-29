const { reportDiff } = require('./report-diff.js')

// Access command-line arguments
const [,, currentCoverageOutput, targetCoverageOutput] = process.argv

function getCoverageDiff(currentCoverageOutput, targetCoverageOutput) {
  try {
    return reportDiff(currentCoverageOutput, targetCoverageOutput)
  } catch (error) {
    console.error('An error occurred:', error.message)
    process.exit(1)
  }
}

// Output the result
console.log(getCoverageDiff(currentCoverageOutput, targetCoverageOutput))
