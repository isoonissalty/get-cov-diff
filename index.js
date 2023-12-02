const { reportDiff } = require('./report-diff.js')

// Access command-line arguments
const [,, currentCoverageOutput, targetCoverageOutput, currentChangeOutput] = process.argv

function getCoverageDiff(currentCoverageOutput, targetCoverageOutput, currentChangeOutput) {
  try {
    return reportDiff(currentCoverageOutput, targetCoverageOutput, currentChangeOutput)
  } catch (error) {
    console.error('An error occurred:', error.message)
    process.exit(1)
  }
}

// Output the result
console.log(getCoverageDiff(currentCoverageOutput, targetCoverageOutput, currentChangeOutput))
