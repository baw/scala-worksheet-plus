{EditorView} = require 'atom'
{BufferedProcess} = require 'atom'
ChildProcess = require 'child_process'
module.exports =
  activate: (state) ->
    console.log 'activate'
    atom.workspaceView.command "scala-worksheet:run", => @runWorksheet()

  deactivate: ()->
    console.log 'deactivate'
    @scalaProcess.stdin.end()
    @scalaProcess.kill()

  runWorksheet: () ->
    sourcesPane = @findSourcesPane()

    @sourcesEditor = sourcesPane.getActiveEditor()
    atom.workspace.open("SCALAWORKSHEET", {
      split: 'right'
      searchAllPanes: true
      }).then (targetEditor) =>
        @executeWorkSheet @sourcesEditor.getText(), targetEditor

  findSourcesPane: () ->
    panes = atom.workspace.getPanes()
    panes[0]

  executeWorkSheet: (source, targetEditor)->
    scalaOut = ''
    if not @scalaProcess? or true
      console.log "creating scala process"
      @scalaProcess = ChildProcess.spawn 'scala'
      @scalaProcess.stdout.on 'data', (data)->
        scalaOut += data.toString 'utf-8'

      @scalaProcess.stderr.on 'data', (data)->
        console.log('stderr')
        console.log(stderr.toString 'utf-8')

      @scalaProcess.on 'close', (code) =>
        console.log "close #{code}"
        @processResults scalaOut, targetEditor

    @scalaProcess.stdin.write source
    @scalaProcess.stdin.end()

  processResults: (rawRestults, targetEditor)->
    resultLines = []
    metFirstScalaPrompt = false
    firstEmptyLine = true
    for line in rawRestults.split "\n"
      isScalaPrompt = line.match @regexps.scalaPrompt
      isEmptyLine = line.match @regexps.emptyLine

      metFirstScalaPrompt = isScalaPrompt unless metFirstScalaPrompt
      continue unless metFirstScalaPrompt
      continue if isScalaPrompt or line.match @regexps.lineNotEnd
      if isEmptyLine
        if firstEmptyLine
          firstEmptyLine = false
          continue
      else
        firstEmptyLine = true
      resultLines.push line

    targetEditor.setText resultLines.join "\n"


  regexps:
    scalaPrompt: /^scala\>/
    lineNotEnd: /^\s+\|/
    emptyLine: /^\s*$/
