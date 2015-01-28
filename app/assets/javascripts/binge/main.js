// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(function($){
  $('#attributes_body').on('show.bs.collapse', function () {
    $("#attributes_status_icon").removeClass("glyphicon-chevron-right").addClass("glyphicon-chevron-up");
  });

  $('#attributes_body').on('hide.bs.collapse', function () {
    $("#attributes_status_icon").removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-right");
  });

  $('.error-text').tooltip();

  // Preview errors...
  $('#preview_button').click(function (event) {
    event.preventDefault();
    var form = $(this).parent('#data_upload_form');

    form.attr('action', '/import/datasets/preview');

    $(form).submit();
  });
});
