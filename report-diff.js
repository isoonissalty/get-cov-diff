const fs = require('fs')

const reportDiff = (filePathTarget, filePathMain, fileChangesPath, useFilter) => {
  const fileContentTarget = fs.readFileSync(filePathTarget, 'utf-8')
  const fileContentMain = fs.readFileSync(filePathMain, 'utf-8')
  const fileContentChanges = fs.readFileSync(fileChangesPath, 'utf-8')

  const lineTargets = fileContentTarget.split('\n')
  const lineMains = fileContentMain.split('\n')
  const lineChanges = fileContentChanges.split('\n')

  const getDataFromCoverage = (lines) => {
    const data = {}
    let currentFolder = ''
    for (const line of lines) {
      const regex =
        /([\w\.\/\-\#\!]+)\s+\|\s+([0-9\.]+)\s+\|\s+([0-9\.]+)\s+\|\s+([0-9\.]+)\s+\|\s+([0-9\.]+)\s+\|\s*\.*\s*([0-9\,\.]*)\s+\|/g

      const matches = regex.exec(line)

      if (matches && !matches[0].includes('.js')) {
        currentFolder = matches[1]
      } else if (matches && !matches[0].startsWith('files')) {
        data[`${currentFolder}/${matches[1]}`] = {
          stmts: Number(matches[2]),
          branch: Number(matches[3]),
          funcs: Number(matches[4]),
          lines: Number(matches[5]),
          uncovered: matches[6],
        }
      }
    }

    return data
  }

  const dataTarget = getDataFromCoverage(lineTargets)
  const dataMain = getDataFromCoverage(lineMains)
  const dataChanges = lineChanges
    .filter((v) => (v.startsWith('app/') || v.startsWith('src/')) && !(v.includes('.test.') || v.includes('.spec.')))
    .map((v) => useFilter ? v.replace('app/', '') : v)

  return dataChanges.map((v) => ({
    files: v,
    stmts: {
      main: dataMain?.[v]?.stmts,
      target: dataTarget?.[v]?.stmts,
      diff: dataTarget?.[v]?.stmts ?? 0 - dataMain?.[v]?.stmts ?? 0,
    },
    branch: {
      main: dataMain?.[v]?.branch,
      target: dataTarget?.[v]?.branch,
      diff: dataTarget?.[v]?.branch ?? 0 - dataMain?.[v]?.stmts ?? 0,
    },
    funcs: {
      main: dataMain?.[v]?.funcs,
      target: dataTarget?.[v]?.funcs,
      diff: dataTarget?.[v]?.funcs ?? 0 - dataMain?.[v]?.stmts ?? 0,
    },
    lines: {
      main: dataMain?.[v]?.lines,
      target: dataTarget?.[v]?.lines,
      diff: dataTarget?.[v]?.lines ?? 0 - dataMain?.[v]?.stmts ?? 0,
    },
    avg: {
      main: (dataMain?.[v]?.stmts + dataMain?.[v]?.branch + dataMain?.[v]?.funcs + dataMain?.[v]?.lines) / 4,
      target: (dataTarget?.[v]?.stmts + dataTarget?.[v]?.branch + dataTarget?.[v]?.funcs + dataTarget?.[v]?.lines) / 4,
    },
  }))
}

exports.reportDiff = reportDiff
