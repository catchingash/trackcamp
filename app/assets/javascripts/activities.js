// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $('.btn-graph.activity').click(function(event) {
    event.preventDefault();

    var graphType = $(this).val()
    var activityHandler = new ActivityHandler(graphType);
    activityHandler.toggleGraph();
  });
});
