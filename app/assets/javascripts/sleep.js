// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $('.btn-graph.sleep').click(function(event) {
    event.preventDefault();

    var graphType = $(this).attr('data-value');
    var sleepHandler = new SleepHandler(graphType);
    sleepHandler.toggleGraph();
  });
});
