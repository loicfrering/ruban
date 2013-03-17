module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    coffee:
      compile:
        files:
          'js/presentation.js': 'coffee/presentation.coffee'
    watch:
      coffee:
        files: 'coffee/presentation.coffee'
        tasks: 'coffee'
  )

  # Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');

  # Default task(s).
  grunt.registerTask('default', ['coffee'])
