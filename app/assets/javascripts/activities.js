// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var activityRepository = new ActivityRepository();

  $('.btn-graph.activity').click(function(event) {
    var graph_letter = $(this).val()
    event.preventDefault();
    activityRepository.toggleGraph(graph_letter);
  });
});
