# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    value = $('#contact_contact_type').val()
    entityFlag = $('#contact_is_company').val()
    $(document).find('#legal-ending-wrapper').hide()
    if value == 'Counter-Party'
        $(document).find('#contact-role_wrapper').hide()
        if entityFlag 
            $(document).find('#legal-ending-wrapper').show()
    else
        $(document).find('#contact-role_wrapper').show()
        if value == 'Personnel'
            $(document).find('#cp-role-wrapper').hide()
            $(document).find('#per-role-wrapper').show()
        else
            $(document).find('#cp-role-wrapper').show()
            $(document).find('#per-role-wrapper').hide()
            if entityFlag 
                $(document).find('#legal-ending-wrapper').show()


    