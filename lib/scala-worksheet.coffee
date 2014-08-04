{EditorView} = require 'atom'
{BufferedProcess} = require 'atom'
ScalaProcess = require './scala-process'
ScalaLineProcessor = require './scala-line-processor'

module.exports =
  activate: (state) ->
    console.log 'activate'
    atom.workspaceView.command "scala-worksheet:run", =>
      @prepareRun () => @executeWorkSheet @sourcesEditor.getText(), @sourcesEditors

  deactivate: ()->
    console.log 'deactivate'
    @scalaProcess.stdin.end()
    @scalaProcess.kill()

  prepareRun: (callback)->
    sourcesPane = @findSourcesPane()

    @sourcesEditor = sourcesPane.getActiveEditor()
    @scalaLiner = new ScalaLineProcessor @sourcesEditor

    if not @scalaProcess?
      @scalaProcess = new ScalaProcess()
      @scalaProcess.setBlockCallback (block) =>
        console.log "new block: "
        console.log block
        for line in block.split "\n"
          @scalaLiner.processLine line
      @scalaProcess.initialize ()-> callback()

    callback()


  findSourcesPane: () ->
    panes = atom.workspace.getPanes()
    panes[0]

  executeWorkSheet: (source, targetEditor)->
    @scalaProcess.writeBlock source
