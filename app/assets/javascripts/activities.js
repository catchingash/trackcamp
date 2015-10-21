// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var exerciseRepository = new ExerciseRepository();

  $('.btn-graph.exercise-a').click(function(event) {
    event.preventDefault();
    exerciseRepository.toggleExerciseA();
  });
});
