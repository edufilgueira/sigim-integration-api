$(document).ready ->
  $(".cities").on "change", ->
    $.ajax
      url: "/site/system_occurrences/neighborhood_by_city"
      type: "GET"
      dataType: "script"
      data:
        city_id: $(this).val()
        cont: $(this).attr("id")

  $(".submit").on "click", ->
    if (confirm("Tem certeza que deseja salvar?"))
      id = $(this).attr("id")
      resource_id   = $("tr#"+id+" [name=resource_id]").val()
      resource_text = $("tr#"+id+" [name=resource]").val()
      source_system = $("tr#"+id+" [name=source_system]").val()
      classfy_id    = $("tr#"+id+" [name=classfy_id]").val()
      ids           = $("tr#"+id+" [name=ids]").val()
      validated     = $("tr#"+id+" [name=validated]").is(':checked')
      ignore        = $("tr#"+id+" [name=ignore]").is(':checked')

      $.ajax
        url: "/site/system_occurrences/authorize"
        async: false
        type: "GET"
        dataType: "script"
        data:
          resource_id: resource_id
          resource: resource_text
          source_system: source_system
          classfy_id: classfy_id
          validated: validated
          ignore: ignore
          ids: ids

      $.ajax
        url: "/site/system_occurrences/total_errors"
        async: false
        type: "GET"
        dataType: "script"
        data:
          source_system: $("#source_system").val()

    $("tr#"+id).fadeOut "slow", ->
      $("tr#"+id).remove()