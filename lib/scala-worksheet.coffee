{EditorView} = require 'atom'
{BufferedProcess} = require 'atom'
ChildProcess = require 'child_process'
ScalaLineProcessor = require './scala-line-processor'

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
    @processor = new ScalaLineProcessor @sourcesEditor
    if @scalaProcess?
      @processor.metFirstScalaPrompt = true
      @processor.processData "scala>"
    @executeWorkSheet @sourcesEditor.getText(), @sourcesEditor


  findSourcesPane: () ->
    panes = atom.workspace.getPanes()
    panes[0]

  executeWorkSheet: (source, targetEditor)->
    # scalaOut = ''
    if not @scalaProcess?
      console.log "creating scala process"
      @scalaProcess = ChildProcess.spawn 'scala'

      @scalaProcess.stdout.on 'data', (data) =>
        @processor.processData data.toString 'utf-8'

      @scalaProcess.stderr.on 'data', (data) ->
        console.log('stderr')
        console.log(stderr.toString 'utf-8')

      @scalaProcess.on 'close', (code) =>
        console.log "close #{code}"
        # @processResults scalaOut, targetEditor

      @scalaProcess.stdin.on 'drain', ()->
        console.log "stdin.drain"

      @scalaProcess.stdout.on 'drain', ()->
        console.log "stdout.drain"

    console.log "writing"

    res = @scalaProcess.stdin.write source
    console.log "write res: #{res}"
    # @scalaProcess.stdin.end()
