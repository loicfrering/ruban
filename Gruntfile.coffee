module.exports = (grunt) ->

  # Project configuration
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    meta:
      banner: """
              // <%= pkg.name %> v<%= pkg.version %>
              //
              // Copyright (c) 2013 <%= pkg.author %>
              // Distributed under the <%= pkg.license %> license

              """
    coffee:
      compile:
        files:
          'js/ruban.js': 'coffee/ruban.coffee'
      dist:
        files:
          'dist/ruban.js': 'coffee/ruban.coffee'
    less:
      compile:
        files:
          'css/ruban.css': 'less/ruban.less'
      dist:
        files:
          'dist/ruban.css': 'less/ruban.less'
    uglify:
      options:
        banner: '<%= meta.banner %>'
      dist:
        files:
          'dist/ruban.min.js': 'dist/ruban.js'
    cssmin:
      dist:
        files:
          'dist/ruban.min.css': 'dist/ruban.css'
    watch:
      coffee:
        files: 'coffee/ruban.coffee'
        tasks: 'coffee:compile'
      less:
        files: 'less/ruban.less'
        tasks: 'less:compile'
  )

  # Load plugins
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-watch');

  # Default tasks
  grunt.registerTask('default', ['coffee:compile', 'less:compile'])
  grunt.registerTask('dist', ['coffee:dist', 'uglify', 'less:dist', 'cssmin'])
