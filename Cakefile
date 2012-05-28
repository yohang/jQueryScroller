{exec} = require 'child_process'
task 'build', 'Build scroller.jquery.js', ->
    exec 'coffee -s -c -p *.coffee < ./*.coffee > scroller.jquery.js', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr

task 'uglify', 'Build scroller.jquery.js', ->
    exec 'uglifyjs -nc -o scroller.jquery.min.js scroller.jquery.js', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
