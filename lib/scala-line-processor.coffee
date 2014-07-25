module.exports =
class ScalaLineProcessor
  constructor: (@targetEditor)->
    @targetEditor.moveCursorToTop()
    @editorLines = @targetEditor.getText().split "\n"
    @editorLineIndex = 0
    @metFirstScalaPrompt = false
    @firstEmptyLine = true
    @currentLine = ""
    @maxLength = 50
    console.log "scala-line-processor created"

  processData: (data)->
    @currentLine += data
    if @currentLine.contains "\n"
      lines = @currentLine.split "\n"
      @currentLine = lines.pop()
      for line in lines
        @processLine line

  processLine: (line)->
    isScalaPrompt = line.match @regexps.scalaPrompt
    isEmptyLine = line.match @regexps.emptyLine
    isLineBreak = line.match @regexps.lineBreak

    @metFirstScalaPrompt = isScalaPrompt unless @metFirstScalaPrompt
    return unless @metFirstScalaPrompt

    return if isScalaPrompt
    line = "" if isLineBreak

    if isEmptyLine
      if @firstEmptyLine
        @firstEmptyLine = false
        return
    else
      @firstEmptyLine = true



    unless isEmptyLine or isLineBreak
      editorLine = @editorLines[@editorLineIndex]
      console.log 'setting editor text: '+@editorLineIndex
      editorLine = @formatLine editorLine
      @editorLines[@editorLineIndex] = editorLine + "  // " + line
      @targetEditor.setText(@editorLines.join("\n"))

    @editorLineIndex = @editorLineIndex + 1


  formatLine: (line)->
    line = line.replace @regexps.comment
    if line.length > @maxLength
      return line.substring 0, @maxLength

    return line + @repeat " ", (@maxLength - line.length)

  repeat: `function repeat(pattern, count) {
    if (count < 1) return '';
    var result = '';
    while (count > 1) {
        if (count & 1) result += pattern;
        count >>= 1, pattern += pattern;
    }
    return result + pattern;
  }`

  regexps:
    scalaPrompt: /^scala\>/
    lineBreak: /^\s+\|/
    emptyLine: /^\s*$/
    comment: /\/\/.*$/
