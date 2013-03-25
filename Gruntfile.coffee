module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    coffee:
      compile:
        files: [
          expand: true
          cwd:    'coffee/'
          src:    '*.coffee'
          dest:   'js/'
          ext:    '.js'
        ]
    less:
      compile:
        files: [
          expand: true
          cwd:    'less/'
          src:    '*.less'
          dest:   'css/'
          ext:    '.css'
        ]
    watch:
      coffee:
        files: 'coffee/presentation.coffee'
        tasks: 'coffee'
      less:
        files: 'less/presentation.less'
        tasks: 'less'
  )

  # Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');

  # Default task(s).
  grunt.registerTask('default', ['coffee', 'less'])
