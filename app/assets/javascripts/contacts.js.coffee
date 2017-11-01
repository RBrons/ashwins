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

    $(document).on "click", "a.delete-contact", ->
        id = $(this).attr 'data-id'

        $.ajax
            type: "POST"
            url: "/xhr/contacts_delete_warning"
            data: {id: id}
            dataType: "html"
            success: (val) ->
                $("#md-delete-contact .modal-body").html(val)
                $("#md-delete-contact").modal 'show'
                $("#md-delete-contact .delete-contact-yes").attr 'data-id', id
            error: (e) ->
                console.log e

      $(document).on "click", "a.delete-contact-yes", ->
            id = $(this).attr 'data-id'
            $(this).attr("disabled", "disabled")

            $.ajax
                type: "DELETE"
                url: "/contacts/" + id
                dataType: "json"
                success: (val) ->
                    if val.success == true
                        $("#md-delete-contact").modal 'hide'
                        window.location.href = '/contacts'
                error: (e) ->
                    console.log e