module.exports = (grunt) ->

  # Project configuration
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    meta:
      banner: """
              /**
               * <%= pkg.name %> v<%= pkg.version %>
               *
               * Copyright (c) 2013 <%= pkg.author %>
               * Distributed under the <%= pkg.license %> license
               */

              """
    coffee:
      compile:
        files:
          'js/ruban-dev.js': 'coffee/ruban.coffee'
      dist:
        files:
          'js/ruban.js': 'coffee/ruban.coffee'
    less:
      compile:
        files:
          'css/ruban-dev.css': 'less/ruban.less'
          'css/ruban-print-dev.css': 'less/ruban-print.less'
      dist:
        files:
          'css/ruban.css': 'less/ruban.less'
          'css/ruban-print.css': 'less/ruban-print.less'
    uglify:
      options:
        banner: '<%= meta.banner %>'
      dist:
        files:
          'js/ruban.min.js': 'js/ruban.js'
    cssmin:
      options:
        banner: '<%= meta.banner %>'
      dist:
        files:
          'css/ruban.min.css': 'css/ruban.css'
          'css/ruban-print.min.css': 'css/ruban-print.css'
    copy:
      libs:
        expand: true
        cwd: 'bower_components/'
        src: [
          'normalize-css/normalize.css',
          'font-awesome/css/font-awesome.min.css'
          'font-awesome/fonts/fontawesome-*'
          'highlightjs/styles/tomorrow.css',
          'jquery/jquery.min.js',
          'keymaster/keymaster.js',
          'hammerjs/hammer.min.js',
          'highlightjs/highlight.pack.js'
        ]
        dest: 'components/'
    watch:
      coffee:
        files: 'coffee/ruban.coffee'
        tasks: 'coffee:compile'
      less:
        files: ['less/ruban.less','less/ruban-print.less']
        tasks: 'less:compile'
  )

  # Load plugins
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');

  # Default tasks
  grunt.registerTask('default', ['copy', 'coffee:compile', 'less:compile', 'watch'])
  grunt.registerTask('dist', ['copy', 'coffee:dist', 'uglify', 'less:dist', 'cssmin'])
