{TextEditorView} = require 'atom-space-pen-views'
{BufferedProcess} = require 'atom'
ScalaProcess = require './scala-process'
ScalaLineProcessor = require './scala-line-processor'

module.exports =
  config:
    scalaProcess:
      default: 'scala'
      type: 'string'

  activate: (state) ->
    atom.commands.add 'atom-workspace',
     'scala-worksheet-plus:run': =>
        @prepareRun () => @executeWorkSheet @sourcesEditor.getText(), @sourcesEditors

  deactivate: ()->
    @scalaProcess.stdin.end()
    @scalaProcess.kill()

  prepareRun: (callback)->
    sourcesPane = @findSourcesPane()

    @sourcesEditor = sourcesPane.getActiveEditor()
    @scalaLiner = new ScalaLineProcessor @sourcesEditor
    if not @scalaProcess?
      @scalaProcess = new ScalaProcess atom.config.get 'scala-worksheet-plus.scalaProcess'
      @scalaProcess.setBlockCallback (block) =>
        for line in block.split "\n"
          @scalaLiner.processLine line
      @scalaProcess.setErrorCallback (error) ->
        console.log "Error: #{error}"
      @scalaProcess.initialize ()-> callback()
      callback()
    else
      @scalaProcess.reset ()-> callback()


  findSourcesPane: () ->
    panes = atom.workspace.getPanes()
    panes[0]

  executeWorkSheet: (source, targetEditor)->
    @scalaProcess.writeBlock source
