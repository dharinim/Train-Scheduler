// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require jquery
//= require jquery-ui
//= require bootstrap-datepicker

$(document).ready(function (){
  var passenger_booking_source   = $("#render_passender_booking").html();
  var passenger_booking_template = Handlebars.compile(passenger_booking_source);

  $("#passenger_booking").on("submit", function (e){
    e.preventDefault();

    var from_city = $(this).find("#from_city").val();
    var to_city = $(this).find("#to_city").val();
    var start_date = $(this).find("#start_date").val();

    $.ajax({
      url: "/schedules/trains",
      data: {
        start_date: start_date,
        from_city: from_city,
        to_city: to_city
      },
      type: "get",
      success: function(response) {
        //Do Something
        console.log(response);
        rendered_html = passenger_booking_template({
          train_schedules: response.train_schedules
        });
        $("#booking_results").html(rendered_html);
      },
      error: function(xhr) {
        //Do Something to handle error
      }
    });
  });
});