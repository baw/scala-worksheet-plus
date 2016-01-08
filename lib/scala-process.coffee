ChildProcess = require 'child_process'

module.exports=
class ScalaProcess
  constructor: (executable) ->
    @executable = executable
  setBlockCallback: (blockCallback)->
    @blockCallback = blockCallback

  setErrorCallback: (errorCallback)->
    @errorCallback = errorCallback

  initialize: (readyCallback)->
    console.log "Spawning scala process: #{@executable}"
    @scala = ChildProcess.spawn @executable
    @scala.stdout.on 'data', (data) => @processOut data
    @scala.stderr.on 'data', (data) => @processErr data
    @scala.stdout.on 'close', (res) => @processClose res
    @readyCallback = readyCallback

    @waitingFirstLine = true

  buffer: ""
  error_buffer: ""
  is_resetting: false

  constants:
    END_OF_BLOCK: "//[SCALA_WORKSHEET_END_OF_DATA]\n"

  reset: (afterResetCallback)->
    @is_resetting = true
    @buffer = ""
    @error_buffer = ""
    @writeBlock ":reset"
    @is_resetting = false
    afterResetCallback()

  writeBlock: (block)->
    @scala.stdin.write block
    @scala.stdin.write "\n"
    @scala.stdin.write @constants.END_OF_BLOCK

  processResultBlock: (resultBlock) ->
    if !@is_resetting
      if @waitingFirstLine
        @waitingFirstLine = false
        @readyCallback()
      else
        @blockCallback resultBlock

  processOut: (data) ->
    if !@is_resetting
      str = data.toString('utf-8')
      @buffer += str
      if str.includes "\n"
        blocks = @buffer.split @constants.END_OF_BLOCK
        @buffer = blocks.pop()
        # console.log "buffer now: #{@buffer}"
        # console.log blocks
        @processResultBlock block for block in blocks


  processErr: (data) ->
    if !@is_resetting
      @error_buffer += data.toString('utf-8')
      if @error_buffer.contains "\n"
        tokens = @error_buffer.split "\n"
        @error_buffer = tokens.pop()
        @errorCallback token for token in tokens

  processClose: (res) ->
    console.log "scala process closed with res: #{res}"
