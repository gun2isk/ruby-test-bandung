# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready', ->
  $('select#backup_version').on 'change', ->
    backupId = $(this).val()

    document.location = $(this).data('target-url') + "&backup_id=" + backupId