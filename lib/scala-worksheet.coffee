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

    sourcesEditor = sourcesPane.getActiveEditor()
    atom.workspace.open("SCALAWORKSHEET", {
      split: 'right'
      searchAllPanes: true
      }).then (targetEditor) =>
        @executeWorkSheet sourcesEditor.getText(), targetEditor

  findSourcesPane: () ->
    panes = atom.workspace.getPanes()
    panes[0]

  executeWorkSheet: (source, targetEditor)->
    scalaOut = ''
    if not @scalaProcess?
      console.log "creating scala process"
      @scalaProcess = ChildProcess.spawn 'scala'
      @scalaProcess.stdout.on 'data', (data)->
        scalaOut += data.toString 'utf-8'

      @scalaProcess.stderr.on 'data', (data)->
        console.log('stderr')
        console.log(stderr.toString 'utf-8')

      @scalaProcess.on 'close', (code)->
        console.log "close #{code}"
        targetEditor.setText scalaOut

    @scalaProcess.stdin.write source


    # scalaProcess = new BufferedProcess({command, stdout, exit})
    # console.log scalaProcess.stdin.write 'val a = 1', 'utf-8', ()->
      # console.log('written')
      # scalaProcess.stdin.end()
