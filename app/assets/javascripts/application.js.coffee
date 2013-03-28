# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require modernizr
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.transit
#= require bootstrap
#= require bootstrap_ujs
#= require select2
#= require fullcalendar.min
#= require bootstrap-datepicker
#= require_self
#= require_tree .

-
-$.ajaxSetup
-  dataType: 'json'
-
-$ ->
-  window.Rails =
-    controller_name: $('body').data('controller')
-    action_name: $('body').data('action')
-    resource_name: $('body').data('resource')
