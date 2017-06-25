$(document).ready(function (){

  // Load schedule on page load
  var schedule_source   = $("#render_dispatcher_schedule").html();
  var schedule_template = Handlebars.compile(schedule_source);


  $.ajax({
    url: "/schedules",
    type: "get",
    success: function(response) {
      schedule_html = schedule_template({
        schedules: response.schedules
      });

      $("#dispatch_schedules").html(schedule_html);
    },
    error: function(xhr) {
      //Todo: Display error in UI
    }
  });


  // Booking related JS
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
        rendered_html = passenger_booking_template({
          train_schedules: response.train_schedules
        });
        $("#booking_results").html(rendered_html);
      },
      error: function(xhr) {
        //Todo: Display error in UI
      }
    });
  });
});